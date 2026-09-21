import { getAccessToken } from './auth';
import { getSheetData, lookupGuest, updateGuests } from './sheets';

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    if (request.method !== 'POST') {
      return jsonResponse({ error: 'method not allowed' }, 405);
    }

    let body: Record<string, unknown>;
    try {
      body = JSON.parse(await request.text());
    } catch {
      return jsonResponse({ error: 'invalid body' }, 400);
    }

    if (body.token !== env.API_TOKEN) {
      // 200, not 401: the Flutter client treats any non-200 response as a
      // silent failure (returns null), so an unauthorized result needs to
      // reach it as parseable JSON, matching Code.gs's existing behavior.
      return jsonResponse({ error: 'unauthorized' });
    }

    try {
      const accessToken = await getAccessToken(env);
      const { headers, rows } = await getSheetData(env, accessToken);

      switch (body.action) {
        case 'lookup':
          return jsonResponse(lookupGuest(headers, rows, String(body.name ?? '')));
        case 'update':
          return jsonResponse(
            await updateGuests(
              env,
              accessToken,
              headers,
              rows,
              body.updates as { name: string; details: Record<string, unknown> }[],
            ),
          );
        default:
          return jsonResponse({ error: 'unknown action' });
      }
    } catch (e) {
      return jsonResponse({ error: 'internal error', message: String(e) }, 500);
    }
  },
};

function jsonResponse(obj: unknown, status = 200): Response {
  return new Response(JSON.stringify(obj), {
    status,
    headers: {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
    },
  });
}
