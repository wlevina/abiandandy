// Google Apps Script Web App that stands in for the old service-account
// credential. It runs under the Google account that owns the spreadsheet
// (whoever deploys it), so no key ever needs to leave Google's servers or
// ship inside the Flutter web bundle.
//
// Setup — see tool/apps_script/README.md for the full walkthrough:
//   1. script.google.com > New project, paste this file in as Code.gs.
//   2. Project Settings > Script Properties: add API_TOKEN with a random value.
//   3. Deploy > New deployment > Web app. Execute as "Me", access "Anyone".
//   4. Copy the /exec URL and the token into the Flutter build (see README).

const SPREADSHEET_ID = '13z_3zY4CCziXTkT9mbS6aDq-19izSD6uqzVFpUM5Roo';
const SHEET_NAME = 'Guests';

const FIELDS = {
  name: 'Guest Name',
  ceremony: 'Ceremony Attendance',
  reception: 'Reception Attendance',
  dietary: 'Dietary Requirements',
  groupId: 'Group ID',
};

function doPost(e) {
  const body = JSON.parse(e.postData.contents);

  if (body.token !== PropertiesService.getScriptProperties().getProperty('API_TOKEN')) {
    return jsonResponse({ error: 'unauthorized' });
  }

  const sheet = SpreadsheetApp.openById(SPREADSHEET_ID).getSheetByName(SHEET_NAME);
  const data = sheet.getDataRange().getValues();
  const headers = data[0];

  switch (body.action) {
    case 'lookup':
      return jsonResponse(lookupGuest(headers, data, body.name));
    case 'update':
      return jsonResponse(updateGuests(sheet, headers, data, body.updates));
    default:
      return jsonResponse({ error: 'unknown action' });
  }
}

function lookupGuest(headers, data, name) {
  const nameIdx = headers.indexOf(FIELDS.name);
  const groupIdx = headers.indexOf(FIELDS.groupId);
  const normalized = String(name || '').trim().toLowerCase();

  let primary = null;
  for (let i = 1; i < data.length; i++) {
    if (String(data[i][nameIdx] || '').trim().toLowerCase() === normalized) {
      primary = rowToObject(headers, data[i]);
      break;
    }
  }
  if (!primary) return { guest: null, party: [] };

  const groupId = String(primary[FIELDS.groupId] || '').trim();
  if (!groupId) return { guest: primary, party: [primary] };

  const party = [];
  for (let i = 1; i < data.length; i++) {
    if (String(data[i][groupIdx] || '').trim() === groupId) {
      party.push(rowToObject(headers, data[i]));
    }
  }
  if (!party.some((g) => g[FIELDS.name] === primary[FIELDS.name])) {
    party.unshift(primary);
  }
  return { guest: primary, party: party };
}

// Applies every party member's update within this single script execution,
// writing each changed row back in one setValues() call (instead of one
// call per field) so a party-of-N submission costs N writes, not 3N.
function updateGuests(sheet, headers, data, updates) {
  const nameIdx = headers.indexOf(FIELDS.name);
  const results = {};

  (updates || []).forEach((u) => {
    const normalized = String(u.name || '').trim().toLowerCase();
    for (let i = 1; i < data.length; i++) {
      if (String(data[i][nameIdx] || '').trim().toLowerCase() === normalized) {
        Object.keys(u.details || {}).forEach((key) => {
          const colIdx = headers.indexOf(key);
          if (colIdx !== -1) data[i][colIdx] = u.details[key];
        });
        sheet.getRange(i + 1, 1, 1, headers.length).setValues([data[i]]);
        results[u.name] = true;
        return;
      }
    }
    results[u.name] = false;
  });

  const success =
    Object.keys(results).length > 0 && Object.values(results).every(Boolean);
  return { success: success, results: results };
}

function rowToObject(headers, row) {
  const obj = {};
  headers.forEach((header, i) => {
    obj[header] = row[i];
  });
  return obj;
}

function jsonResponse(obj) {
  return ContentService.createTextOutput(JSON.stringify(obj)).setMimeType(
    ContentService.MimeType.JSON
  );
}
