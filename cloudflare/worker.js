export default {
  async fetch(request, env) {
    if (request.method !== 'POST') {
      return new Response('Method not allowed', { status: 405 });
    }

    let body;
    try {
      body = await request.json();
    } catch {
      return new Response('Invalid JSON', { status: 400 });
    }

    const { title, body: notifBody, secret } = body;

    if (!secret || secret !== env.WORKER_SECRET) {
      return new Response('Unauthorized', { status: 401 });
    }

    try {
      const accessToken = await getAccessToken(env.FIREBASE_SERVICE_ACCOUNT);
      const projectId = env.FIREBASE_PROJECT_ID;

      // 1. Envía al topic → reciben usuarios Android con la app nativa
      const topicResult = await sendToTopic({ title, body: notifBody, accessToken, projectId });

      // 2. Envía a tokens web → reciben usuarios iOS con la PWA
      const webTokens = await getWebTokens(accessToken, projectId);
      const webResults = await Promise.allSettled(
        webTokens.map((token) => sendToWebToken({ title, body: notifBody, accessToken, projectId, token }))
      );

      return Response.json({
        topic: topicResult,
        webTokensSent: webTokens.length,
        webErrors: webResults.filter((r) => r.status === 'rejected').length,
      });
    } catch (e) {
      return Response.json({ error: e.message }, { status: 500 });
    }
  },
};

// ── FCM ───────────────────────────────────────────────────────────────────────

const ICON_URL = 'https://ipuc-pis-directory.web.app/icons/Icon-512.png';

async function sendToTopic({ title, body, accessToken, projectId }) {
  const res = await fetch(
    `https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`,
    {
      method: 'POST',
      headers: { Authorization: `Bearer ${accessToken}`, 'Content-Type': 'application/json' },
      body: JSON.stringify({
        message: {
          topic: 'directorio_ipuc',
          notification: { title, body },
          android: {
            notification: {
              channel_id: 'ipuc_directorio',
              sound: 'default',
              image: ICON_URL,
            },
          },
          apns: {
            payload: { aps: { sound: 'default' } },
          },
        },
      }),
    }
  );
  return res.json();
}

async function sendToWebToken({ title, body, accessToken, projectId, token }) {
  const res = await fetch(
    `https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`,
    {
      method: 'POST',
      headers: { Authorization: `Bearer ${accessToken}`, 'Content-Type': 'application/json' },
      body: JSON.stringify({
        message: {
          token,
          notification: { title, body },
          webpush: {
            notification: {
              icon: ICON_URL,
              badge: ICON_URL,
              image: ICON_URL,
            },
          },
        },
      }),
    }
  );
  if (!res.ok) throw new Error(`FCM web token error: ${await res.text()}`);
  return res.json();
}

// ── Firestore ────────────────────────────────────────────────────────────────

async function getWebTokens(accessToken, projectId) {
  const res = await fetch(
    `https://firestore.googleapis.com/v1/projects/${projectId}/databases/(default)/documents/fcm_tokens`,
    { headers: { Authorization: `Bearer ${accessToken}` } }
  );
  const data = await res.json();
  if (!data.documents) return [];
  return data.documents
    .map((doc) => doc.fields?.token?.stringValue)
    .filter(Boolean);
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
