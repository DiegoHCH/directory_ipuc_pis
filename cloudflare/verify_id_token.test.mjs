// Pruebas de verifyIdToken (worker.js). Ejecutar con: node verify_id_token.test.mjs
import assert from 'node:assert';

const PROJECT_ID = 'ipuc-pis-directory';
const KID = 'test-kid-1';

const b64url = (buf) =>
  Buffer.from(buf).toString('base64').replace(/=/g, '').replace(/\+/g, '-').replace(/\//g, '_');

const pair = await crypto.subtle.generateKey(
  { name: 'RSASSA-PKCS1-v1_5', modulusLength: 2048, publicExponent: new Uint8Array([1, 0, 1]), hash: 'SHA-256' },
  true,
  ['sign', 'verify']
);
const attackerPair = await crypto.subtle.generateKey(
  { name: 'RSASSA-PKCS1-v1_5', modulusLength: 2048, publicExponent: new Uint8Array([1, 0, 1]), hash: 'SHA-256' },
  true,
  ['sign', 'verify']
);

const jwk = await crypto.subtle.exportKey('jwk', pair.publicKey);
// Sirve el JWKS falso en lugar del de Google.
globalThis.fetch = async () =>
  new Response(JSON.stringify({ keys: [{ ...jwk, kid: KID, alg: 'RS256', use: 'sig' }] }), {
    headers: { 'content-type': 'application/json', 'cache-control': 'max-age=3600' },
  });

const { verifyIdToken } = await import('./worker.js');

const now = () => Math.floor(Date.now() / 1000);

async function mint(payloadOverrides = {}, headerOverrides = {}, key = pair.privateKey) {
  const header = { alg: 'RS256', kid: KID, typ: 'JWT', ...headerOverrides };
  const payload = {
    iss: `https://securetoken.google.com/${PROJECT_ID}`,
    aud: PROJECT_ID,
    sub: 'uid-123',
    iat: now() - 10,
    exp: now() + 3600,
    ...payloadOverrides,
  };
  const signingInput = `${b64url(JSON.stringify(header))}.${b64url(JSON.stringify(payload))}`;
  const sig = await crypto.subtle.sign(
    'RSASSA-PKCS1-v1_5',
    key,
    new TextEncoder().encode(signingInput)
  );
  return `${signingInput}.${b64url(sig)}`;
}

async function rejects(name, token) {
  await assert.rejects(() => verifyIdToken(token, PROJECT_ID), `debía rechazar: ${name}`);
  console.log(`  ✓ rechaza ${name}`);
}

// Caso feliz
const ok = await verifyIdToken(await mint(), PROJECT_ID);
assert.equal(ok.sub, 'uid-123');
console.log('  ✓ acepta un token válido');

// Ataques / casos borde
await rejects('firma de otra clave', await mint({}, {}, attackerPair.privateKey));
await rejects('token expirado', await mint({ exp: now() - 60 }));
await rejects('emitido en el futuro', await mint({ iat: now() + 600 }));
await rejects('audiencia de otro proyecto', await mint({ aud: 'otro-proyecto' }));
await rejects('emisor falso', await mint({ iss: 'https://evil.example.com' }));
await rejects('sin sub', await mint({ sub: '' }));
await rejects('alg: none', await mint({}, { alg: 'none' }));
await rejects('alg HS256 (confusión de algoritmo)', await mint({}, { alg: 'HS256' }));
await rejects('kid desconocido', await mint({}, { kid: 'kid-inexistente' }));
await rejects('token malformado', 'no.es.un.jwt.valido');
await rejects('cadena vacía', '');

// Payload manipulado tras firmar (misma firma, otro sub)
const [h, , s] = (await mint()).split('.');
const tampered = `${h}.${b64url(JSON.stringify({
  iss: `https://securetoken.google.com/${PROJECT_ID}`,
  aud: PROJECT_ID,
  sub: 'uid-atacante',
  iat: now() - 10,
  exp: now() + 3600,
}))}.${s}`;
await rejects('payload manipulado', tampered);

console.log('\nTodas las pruebas pasaron.');
