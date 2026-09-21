# RSVP backend (Cloudflare Worker)

Replaces the Google Apps Script backend (`tool/apps_script/`) to fix its
multi-second cold-start delay. Same job, same contract: reads/writes the
"Guests" Google Sheet on behalf of the Flutter web app, gated by a shared
token. The Sheet stays the only data store — nothing here migrates guest
data anywhere else, and the Apps Script deployment stays live untouched as
a rollback path.

## Setup

1. **Google Cloud service account** (this replaces Apps Script's "runs as
   your Google account" model):
   - In a GCP project, enable the **Google Sheets API**.
   - Create a service account (IAM & Admin → Service Accounts).
   - Create a JSON key for it and download it.
   - Open the "Guests" spreadsheet → Share → add the service account's
     email (looks like `...@...iam.gserviceaccount.com`) as **Editor**.
2. **Install dependencies**: `npm install` in this directory.
3. **Set secrets**:
   ```
   wrangler secret put API_TOKEN
   # paste a long random string, e.g. output of `openssl rand -hex 32`

   wrangler secret put GCP_SERVICE_ACCOUNT_KEY_JSON
   # paste the *entire* contents of the downloaded JSON key file
   ```
4. **Deploy**: `npm run deploy` (runs `wrangler deploy`). Note the
   `*.workers.dev` URL it prints — that's `RSVP_API_URL`.

## Wire it into the app

Same mechanism as before — the Flutter app reads the URL and token from
`--dart-define` at build time (`lib/api/sheets/rsvp_sheets_api.dart`):

- **Local dev**: `flutter run -d chrome --dart-define=RSVP_API_URL=... --dart-define=RSVP_API_TOKEN=...`
- **CI/GitHub Pages**: update the `RSVP_API_URL` and `RSVP_API_TOKEN` repo
  secrets (Settings → Secrets and variables → Actions) to point at this
  Worker, then re-run the "Deploy to GitHub Pages" workflow.

## Rotating the shared token

```
wrangler secret put API_TOKEN
```
then update the `RSVP_API_TOKEN` GitHub secret and re-run the deploy
workflow. No code changes needed.

## Rotating the service-account key

Generate a new key for the service account in the GCP console, then:
```
wrangler secret put GCP_SERVICE_ACCOUNT_KEY_JSON
```
paste the new key's contents, redeploy, then delete the old key in the GCP
console.

## Note on exposure

The service-account private key lives **only** as a Worker secret on
Cloudflare's servers — it's never bundled into the client JS, unlike the
old embedded key `tool/apps_script/README.md` describes moving away from.
That's a materially different situation, not a step backwards. The shared
`API_TOKEN` is the only thing that ends up in the compiled client bundle
(same as before): a leaked token only lets someone read/write this one
sheet through this one endpoint, nothing else in the GCP project.

## Debugging

`npm run tail` (or `wrangler tail`) streams live logs from the deployed
Worker, useful for seeing the `internal error` responses that wrap any
unexpected Sheets API failure.
