# RSVP backend (Google Apps Script)

Replaces the old embedded service-account key. `Code.gs` runs as a Web App
under your own Google account, so it can read/write the "Guests" sheet
without any credential ever being shipped in the Flutter web bundle.

## Deploy

1. Go to [script.google.com](https://script.google.com) → New project.
2. Rename it (e.g. "RSVP Sheet Backend") and replace the default `Code.gs`
   contents with the file in this directory.
3. **Project Settings → Script Properties → Add script property**:
   - Name: `API_TOKEN`
   - Value: a long random string (e.g. `openssl rand -hex 32`) — this is a
     shared secret the Flutter app sends with every request.
4. **Deploy → New deployment**:
   - Type: Web app
   - Execute as: **Me**
   - Who has access: **Anyone**
5. Authorize the requested Sheets scope when prompted (it's your own
   consent, not a shared key).
6. Copy the resulting `.../exec` URL — that's `RSVP_API_URL`.

## Wire it into the app

The Flutter app reads the URL and token from `--dart-define` at build time
(see `lib/api/sheets/rsvp_sheets_api.dart`), so they never live in source.

- **Local dev**: `flutter run -d chrome --dart-define=RSVP_API_URL=... --dart-define=RSVP_API_TOKEN=...`
- **CI/GitHub Pages**: add `RSVP_API_URL` and `RSVP_API_TOKEN` as repo
  secrets (Settings → Secrets and variables → Actions), already wired into
  `.github/workflows/*.yml`.

## Rotating the token later

Change the `API_TOKEN` script property, redeploy (Deploy → Manage
deployments → Edit → New version), then update the `RSVP_API_TOKEN` GitHub
secret and re-run the deploy workflow. No code changes needed.

## Note on exposure

This app is a static site with no server component, so the token still
ends up inside the compiled JS bundle — same as any client-only app. What
changed is the blast radius: a leaked token only lets someone read/write
this one "Guests" sheet through this one endpoint, not use the Google
Sheets API as your service account or touch anything else in the GCP
project the way the old private key could.
