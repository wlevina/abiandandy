import 'package:flutter/foundation.dart';
import 'package:gsheets/gsheets.dart';
import 'package:wedding_website/model/guests.dart';

class RsvpSheetsApi {
  static const _credentials = r'''
{
  "type": "service_account",
  "project_id": "rsvps-410610",
  "private_key_id": "REDACTED-KEY-ID",
  "private_key": "REDACTED-PRIVATE-KEY",
  "client_email": "rsvp-gsheet@rsvps-410610.iam.gserviceaccount.com",
  "client_id": "REDACTED-CLIENT-ID",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/rsvp-gsheet%40rsvps-410610.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}

''';
  static const _spreadsheetId = '13z_3zY4CCziXTkT9mbS6aDq-19izSD6uqzVFpUM5Roo';
  static get _gsheets => GSheets(_credentials);
  static Worksheet? _guestSheet;

  static Future init() async {
    try {
      final spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);
      _guestSheet = await _getWorkSheet(spreadsheet, title: 'Guests');

      final firstRow = GuestFields.getFields();
      _guestSheet!.values.insertRow(1, firstRow);
    } catch (e) {
      debugPrint('Init Error: $e');
    }
  }

  static Future<Worksheet> _getWorkSheet(
    Spreadsheet spreadsheet, {
    required String title,
  }) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }

  // Resolves a guest by name (case/whitespace-insensitive) and, in the same
  // sheet fetch, their party if they belong to one — avoids a second round
  // trip to look the group up separately.
  static Future<(Guest?, List<Guest>)> getGuestAndParty(String name) async {
    if (_guestSheet == null) return (null, <Guest>[]);

    final rows = await _guestSheet!.values.map.allRows();
    if (rows == null) return (null, <Guest>[]);

    final normalized = name.trim().toLowerCase();
    Map<String, String>? primaryRow;
    for (final row in rows) {
      if (row[GuestFields.name]?.trim().toLowerCase() == normalized) {
        primaryRow = row;
        break;
      }
    }
    if (primaryRow == null) return (null, <Guest>[]);

    final primary = Guest.fromJson(primaryRow);
    final groupId = primary.groupId?.trim() ?? '';
    if (groupId.isEmpty) return (primary, [primary]);

    final party =
        rows.where((row) => row[GuestFields.groupId] == groupId).toList();
    if (!party.any((row) => row[GuestFields.name] == primary.name)) {
      party.insert(0, primaryRow);
    }
    return (primary, party.map(Guest.fromJson).toList());
  }

  static Future insert(List<Map<String, dynamic>> rowList) async {
    _guestSheet!.values.map.appendRows(rowList);
  }

  static Future<bool> update(
    String name,
    Map<String, dynamic> guestDetails,
  ) async {
    if (_guestSheet == null) return false;

    return _guestSheet!.values.map.insertRowByKey(name, guestDetails);
  }
}
