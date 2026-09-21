// Field name map — must stay identical to tool/apps_script/Code.gs's FIELDS
// and lib/model/guests.dart's GuestFields. These are both the Sheet's column
// headers and the JSON keys sent to/from the Flutter client.
export const FIELDS = {
  name: 'Guest Name',
  ceremony: 'Ceremony Attendance',
  reception: 'Reception Attendance',
  dietary: 'Dietary Requirements',
  groupId: 'Group ID',
} as const;

type Row = unknown[];
type GuestObject = Record<string, unknown>;

export async function getSheetData(
  env: Env,
  accessToken: string,
): Promise<{ headers: string[]; rows: Row[] }> {
  const url =
    `https://sheets.googleapis.com/v4/spreadsheets/${env.SPREADSHEET_ID}` +
    `/values/${encodeURIComponent(env.SHEET_NAME)}?valueRenderOption=UNFORMATTED_VALUE`;
  const response = await fetch(url, {
    headers: { Authorization: `Bearer ${accessToken}` },
  });
  if (!response.ok) {
    throw new Error(`Sheets read failed: ${response.status} ${await response.text()}`);
  }
  const { values } = (await response.json()) as { values: Row[] };
  const [headers, ...rows] = values as [string[], ...Row[]];
  return { headers, rows };
}

export function lookupGuest(headers: string[], rows: Row[], name: string) {
  const nameIdx = headers.indexOf(FIELDS.name);
  const groupIdx = headers.indexOf(FIELDS.groupId);
  const normalized = String(name || '').trim().toLowerCase();

  let primary: GuestObject | null = null;
  for (const row of rows) {
    if (String(row[nameIdx] ?? '').trim().toLowerCase() === normalized) {
      primary = rowToObject(headers, row);
      break;
    }
  }
  if (!primary) return { guest: null, party: [] };

  const groupId = String(primary[FIELDS.groupId] ?? '').trim();
  if (!groupId) return { guest: primary, party: [primary] };

  const party: GuestObject[] = [];
  for (const row of rows) {
    if (String(row[groupIdx] ?? '').trim() === groupId) {
      party.push(rowToObject(headers, row));
    }
  }
  if (!party.some((g) => g[FIELDS.name] === primary![FIELDS.name])) {
    party.unshift(primary);
  }
  return { guest: primary, party };
}

// Merges every party member's update into its row in memory, then writes all
// changed rows in a single batchUpdate call (one Sheets API write per
// submission, not one per party member).
export async function updateGuests(
  env: Env,
  accessToken: string,
  headers: string[],
  rows: Row[],
  updates: { name: string; details: Record<string, unknown> }[],
) {
  const nameIdx = headers.indexOf(FIELDS.name);
  const results: Record<string, boolean> = {};
  const changedRows: { rowIndex: number; values: Row }[] = [];

  for (const update of updates || []) {
    const normalized = String(update.name || '').trim().toLowerCase();
    const rowIndex = rows.findIndex(
      (row) => String(row[nameIdx] ?? '').trim().toLowerCase() === normalized,
    );
    if (rowIndex === -1) {
      results[update.name] = false;
      continue;
    }
    const row = rows[rowIndex];
    for (const [key, value] of Object.entries(update.details || {})) {
      const colIdx = headers.indexOf(key);
      if (colIdx !== -1) row[colIdx] = value;
    }
    changedRows.push({ rowIndex, values: row });
    results[update.name] = true;
  }

  if (changedRows.length > 0) {
    await batchWriteRows(env, accessToken, changedRows);
  }

  const success =
    Object.keys(results).length > 0 && Object.values(results).every(Boolean);
  return { success, results };
}

async function batchWriteRows(
  env: Env,
  accessToken: string,
  changedRows: { rowIndex: number; values: Row }[],
) {
  const sheet = env.SHEET_NAME;
  const data = changedRows.map(({ rowIndex, values }) => ({
    // +2: +1 for the header row, +1 because Sheets ranges are 1-indexed.
    range: `${sheet}!A${rowIndex + 2}`,
    values: [values],
  }));

  const url = `https://sheets.googleapis.com/v4/spreadsheets/${env.SPREADSHEET_ID}/values:batchUpdate`;
  const response = await fetch(url, {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${accessToken}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ valueInputOption: 'RAW', data }),
  });
  if (!response.ok) {
    throw new Error(`Sheets write failed: ${response.status} ${await response.text()}`);
  }
}

function rowToObject(headers: string[], row: Row): GuestObject {
  const obj: GuestObject = {};
  headers.forEach((header, i) => {
    obj[header] = row[i];
  });
  return obj;
}
