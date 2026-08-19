import 'dart:convert';

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

  static Future<bool> update(
    String name,
    Map<String, dynamic> guestDetails,
  ) async {
    final response = await _post({
      'action': 'update',
      'name': name,
      'details': guestDetails,
    });
    return response?['success'] == true;
  }

  static Future<Map<String, dynamic>?> _post(
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({...body, 'token': _token}),
      );
      if (response.statusCode != 200) return null;
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }
}
