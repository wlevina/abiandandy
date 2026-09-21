import { SignJWT, importPKCS8 } from 'jose';

interface ServiceAccountKey {
  client_email: string;
  private_key: string;
}

// Cached across requests within the same warm isolate — trims a round-trip
// on warm requests, but isn't required for correctness (a cold isolate just
// does the exchange, which is fast, nowhere near Apps Script's cold start).
let cachedToken: { accessToken: string; expiresAt: number } | null = null;

export async function getAccessToken(env: Env): Promise<string> {
  const now = Math.floor(Date.now() / 1000);
  if (cachedToken && cachedToken.expiresAt - 60 > now) {
    return cachedToken.accessToken;
  }

  const key: ServiceAccountKey = JSON.parse(env.GCP_SERVICE_ACCOUNT_KEY_JSON);
  const privateKey = await importPKCS8(key.private_key, 'RS256');

  const assertion = await new SignJWT({
    scope: 'https://www.googleapis.com/auth/spreadsheets',
  })
    .setProtectedHeader({ alg: 'RS256' })
    .setIssuer(key.client_email)
    .setAudience('https://oauth2.googleapis.com/token')
    .setIssuedAt(now)
    .setExpirationTime(now + 3600)
    .sign(privateKey);

  const response = await fetch('https://oauth2.googleapis.com/token', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({
      grant_type: 'urn:ietf:params:oauth:grant-type:jwt-bearer',
      assertion,
    }),
  });
  if (!response.ok) {
    throw new Error(`Token exchange failed: ${response.status} ${await response.text()}`);
  }

  const { access_token, expires_in } = (await response.json()) as {
    access_token: string;
    expires_in: number;
  };
  cachedToken = { accessToken: access_token, expiresAt: now + expires_in };
  return access_token;
}
