import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:wedding_website/model/guests.dart';

class RsvpSheetsApi {
  static const _endpoint = String.fromEnvironment('RSVP_API_URL');
  static const _token = String.fromEnvironment('RSVP_API_TOKEN');

  static Future<(Guest?, List<Guest>)> getGuestAndParty(String name) async {
    final response = await _post({'action': 'lookup', 'name': name});
    final guestJson = response?['guest'] as Map<String, dynamic>?;
    if (guestJson == null) return (null, <Guest>[]);

    final party = (response!['party'] as List)
        .map((row) => Guest.fromJson(Map<String, dynamic>.from(row)))
        .toList();
    return (Guest.fromJson(guestJson), party);
  }

  // Submits every party member's update in one request, so the Apps Script
  // backend only spins up (and reads/writes the sheet) once per RSVP
  // submission instead of once per party member.
  static Future<bool> updateParty(
    Map<String, Map<String, dynamic>> guestDetailsByName,
  ) async {
    final response = await _post({
      'action': 'update',
      'updates': [
        for (final entry in guestDetailsByName.entries)
          {'name': entry.key, 'details': entry.value},
      ],
    });
    return response?['success'] == true;
  }

  static Future<Map<String, dynamic>?> _post(
    Map<String, dynamic> body,
  ) async {
    try {
      // text/plain avoids a CORS preflight (OPTIONS), which Apps Script
      // Web Apps don't implement — the JSON body is unaffected since
      // Code.gs parses e.postData.contents regardless of content type.
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {'Content-Type': 'text/plain;charset=utf-8'},
        body: jsonEncode({...body, 'token': _token}),
      );
      if (response.statusCode != 200) return null;
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('RsvpSheetsApi error: $e');
      return null;
    }
  }
}
