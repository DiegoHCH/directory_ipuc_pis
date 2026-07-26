export default {
  async fetch(request, env) {
    // La app web llama a este Worker desde otro origen y manda cabeceras que
    // disparan preflight (Content-Type: application/json + Authorization).
    if (request.method === 'OPTIONS') {
      return new Response(null, { status: 204, headers: corsHeaders() });
    }

    if (request.method !== 'POST') {
      return new Response('Method not allowed', { status: 405, headers: corsHeaders() });
    }

    const projectId = env.FIREBASE_PROJECT_ID;

    // Autenticación: sólo usuarios con sesión de Firebase válida. El ID token
    // se verifica contra las claves públicas de Google, así que el cliente no
    // necesita llevar ningún secreto embebido.
    const auth = request.headers.get('Authorization') ?? '';
    const idToken = auth.startsWith('Bearer ') ? auth.slice(7).trim() : '';
    if (!idToken) {
      return new Response('Unauthorized', { status: 401, headers: corsHeaders() });
    }
    try {
      await verifyIdToken(idToken, projectId);
    } catch {
      return new Response('Unauthorized', { status: 401, headers: corsHeaders() });
    }

    let body;
    try {
      body = await request.json();
    } catch {
      return new Response('Invalid JSON', { status: 400, headers: corsHeaders() });
    }

    const { title, body: notifBody, excludeToken } = body;

    if (typeof title !== 'string' || typeof notifBody !== 'string') {
      return new Response('Missing title or body', { status: 400, headers: corsHeaders() });
    }
    if (title.length > MAX_TITLE || notifBody.length > MAX_BODY) {
      return new Response('Title or body too long', { status: 400, headers: corsHeaders() });
    }

    try {
      const accessToken = await getAccessToken(env.FIREBASE_SERVICE_ACCOUNT);

      // Obtiene todos los tokens (Android + web) y excluye el del registrante
      // para que no se auto-notifique. Se envía individualmente a cada token
      // (en lugar de topics) para poder excluir tokens específicos.
      const allTokens = await getAllTokens(accessToken, projectId);
      const tokens = excludeToken
        ? allTokens.filter((t) => t.token !== excludeToken)
        : allTokens;

      const results = await Promise.allSettled(
        tokens.map(({ token, platform }) =>
          sendToToken({ title, body: notifBody, accessToken, projectId, token, platform })
        )
      );

      return Response.json(
        {
          tokensSent: tokens.length,
          errors: results.filter((r) => r.status === 'rejected').length,
        },
        { headers: corsHeaders() }
      );
    } catch (e) {
      return Response.json({ error: e.message }, { status: 500, headers: corsHeaders() });
    }
  },
};

// ── CORS ──────────────────────────────────────────────────────────────────────

const MAX_TITLE = 200;
const MAX_BODY = 1000;

function corsHeaders() {
  return {
    'Access-Control-Allow-Origin': ALLOWED_ORIGIN,
    'Access-Control-Allow-Methods': 'POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type, Authorization',
    'Access-Control-Max-Age': '86400',
  };
}

const ALLOWED_ORIGIN = 'https://ipuc-pis-directory.web.app';

// ── Verificación del ID token de Firebase ────────────────────────────────────

const JWKS_URL =
  'https://www.googleapis.com/service_accounts/v1/jwk/securetoken@system.gserviceaccount.com';

// Cache a nivel de isolate: evita pedir el JWKS en cada request.
let jwksCache = { keys: null, expiresAt: 0 };

async function getJwks() {
  const now = Date.now();
  if (jwksCache.keys && now < jwksCache.expiresAt) return jwksCache.keys;

  const res = await fetch(JWKS_URL, { cf: { cacheTtl: 3600, cacheEverything: true } });
  if (!res.ok) throw new Error('No se pudo obtener el JWKS de Google');
  const data = await res.json();

  const maxAge = /max-age=(\d+)/.exec(res.headers.get('cache-control') ?? '');
  const ttlMs = maxAge ? Number(maxAge[1]) * 1000 : 3_600_000;
  jwksCache = { keys: data.keys, expiresAt: now + ttlMs };
  return data.keys;
}

function b64urlToBytes(s) {
  const b64 = s.replace(/-/g, '+').replace(/_/g, '/');
  return Uint8Array.from(atob(b64.padEnd(Math.ceil(b64.length / 4) * 4, '=')), (c) =>
    c.charCodeAt(0)
  );
}

function b64urlToJson(s) {
  return JSON.parse(new TextDecoder().decode(b64urlToBytes(s)));
}

// Exportada para poder probarla; el handler del Worker sigue siendo el default.
export async function verifyIdToken(idToken, projectId) {
  const parts = idToken.split('.');
  if (parts.length !== 3) throw new Error('Token malformado');
  const [headerB64, payloadB64, sigB64] = parts;

  const header = b64urlToJson(headerB64);
  // Fijar el algoritmo evita el ataque de "alg: none" / sustitución a HMAC.
  if (header.alg !== 'RS256' || !header.kid) throw new Error('Cabecera de token inválida');

  const jwk = (await getJwks()).find((k) => k.kid === header.kid);
  if (!jwk) throw new Error('Clave de firma desconocida');

  const key = await crypto.subtle.importKey(
    'jwk',
    { kty: jwk.kty, n: jwk.n, e: jwk.e, alg: 'RS256', ext: true },
    { name: 'RSASSA-PKCS1-v1_5', hash: 'SHA-256' },
    false,
    ['verify']
  );

  const valid = await crypto.subtle.verify(
    'RSASSA-PKCS1-v1_5',
    key,
    b64urlToBytes(sigB64),
    new TextEncoder().encode(`${headerB64}.${payloadB64}`)
  );
  if (!valid) throw new Error('Firma inválida');

  const payload = b64urlToJson(payloadB64);
  const now = Math.floor(Date.now() / 1000);

  if (payload.iss !== `https://securetoken.google.com/${projectId}`) {
    throw new Error('Emisor inválido');
  }
  if (payload.aud !== projectId) throw new Error('Audiencia inválida');
  if (typeof payload.exp !== 'number' || payload.exp <= now) throw new Error('Token expirado');
  // 60s de holgura por desfase de reloj entre el cliente y el edge.
  if (typeof payload.iat !== 'number' || payload.iat > now + 60) {
    throw new Error('Token emitido en el futuro');
  }
  if (!payload.sub) throw new Error('Token sin sujeto');

  return payload;
}

// ── FCM ───────────────────────────────────────────────────────────────────────

const ICON_URL = 'https://ipuc-pis-directory.web.app/icons/Icon-512.png';

async function sendToToken({ title, body, accessToken, projectId, token, platform }) {
  const isWeb = platform === 'web';
  const message = {
    token,
    notification: { title, body },
    ...(isWeb
      ? { webpush: { notification: { icon: ICON_URL, badge: ICON_URL, image: ICON_URL } } }
      : {
          android: {
            notification: { channel_id: 'ipuc_directorio', sound: 'default', image: ICON_URL },
          },
          apns: { payload: { aps: { sound: 'default' } } },
        }),
  };

  const res = await fetch(
    `https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`,
    {
      method: 'POST',
      headers: { Authorization: `Bearer ${accessToken}`, 'Content-Type': 'application/json' },
      body: JSON.stringify({ message }),
    }
  );
  if (!res.ok) throw new Error(`FCM error [${platform}]: ${await res.text()}`);
  return res.json();
}

// ── Firestore ────────────────────────────────────────────────────────────────

async function getAllTokens(accessToken, projectId) {
  const res = await fetch(
    `https://firestore.googleapis.com/v1/projects/${projectId}/databases/(default)/documents/fcm_tokens`,
    { headers: { Authorization: `Bearer ${accessToken}` } }
  );
  const data = await res.json();
  if (!data.documents) return [];
  return data.documents
    .map((doc) => ({
      token: doc.fields?.token?.stringValue,
      platform: doc.fields?.platform?.stringValue ?? 'android',
    }))
    .filter((t) => t.token);
}

// ── OAuth2 / JWT ──────────────────────────────────────────────────────────────

async function getAccessToken(serviceAccountJson) {
  const sa = JSON.parse(serviceAccountJson);
  const now = Math.floor(Date.now() / 1000);

  const payload = {
    iss: sa.client_email,
    // cloud-platform cubre tanto FCM como Firestore
    scope: 'https://www.googleapis.com/auth/cloud-platform',
    aud: 'https://oauth2.googleapis.com/token',
    iat: now,
    exp: now + 3600,
  };

  const privateKey = await importPrivateKey(sa.private_key);
  const jwt = await createJwt(payload, privateKey);

  const tokenResponse = await fetch('https://oauth2.googleapis.com/token', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({
      grant_type: 'urn:ietf:params:oauth:grant-type:jwt-bearer',
      assertion: jwt,
    }),
  });

  const tokenData = await tokenResponse.json();
  if (!tokenData.access_token) {
    throw new Error(`Token error: ${JSON.stringify(tokenData)}`);
  }
  return tokenData.access_token;
}

async function importPrivateKey(pem) {
  const pemBody = pem
    .replace('-----BEGIN PRIVATE KEY-----', '')
    .replace('-----END PRIVATE KEY-----', '')
    .replace(/\s/g, '');

  const binaryDer = Uint8Array.from(atob(pemBody), (c) => c.charCodeAt(0));

  return crypto.subtle.importKey(
    'pkcs8',
    binaryDer,
    { name: 'RSASSA-PKCS1-v1_5', hash: 'SHA-256' },
    false,
    ['sign']
  );
}

async function createJwt(payload, privateKey) {
  const encodeB64url = (obj) =>
    btoa(JSON.stringify(obj))
      .replace(/=/g, '')
      .replace(/\+/g, '-')
      .replace(/\//g, '_');

  const header = { alg: 'RS256', typ: 'JWT' };
  const signingInput = `${encodeB64url(header)}.${encodeB64url(payload)}`;

  const signature = await crypto.subtle.sign(
    'RSASSA-PKCS1-v1_5',
    privateKey,
    new TextEncoder().encode(signingInput)
  );

  const sigB64url = btoa(String.fromCharCode(...new Uint8Array(signature)))
    .replace(/=/g, '')
    .replace(/\+/g, '-')
    .replace(/\//g, '_');

  return `${signingInput}.${sigB64url}`;
}
