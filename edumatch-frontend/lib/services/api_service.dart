import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/tutor.dart';

/// Central API service for EduMatch.
///
/// All outbound HTTP requests flow through this class. Authenticated
/// endpoints automatically attach the JWT token stored in SharedPreferences.
class ApiService {
  static const String _base = 'http://localhost:3000';

  // ── Auth header helper ─────────────────────────────────────────────────

  /// Reads the persisted JWT token and returns headers suitable for
  /// authenticated requests.
  static Future<Map<String, String>> _getAuthHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  // ── Generic helpers ────────────────────────────────────────────────────

  /// Authenticated GET request to [endpoint] (e.g. `/api/tutors`).
  static Future<http.Response> authenticatedGet(String endpoint) async {
    final url = Uri.parse('$_base$endpoint');
    final headers = await _getAuthHeaders();
    return http.get(url, headers: headers);
  }

  /// Authenticated POST request to [endpoint] with a JSON [body].
  static Future<http.Response> authenticatedPost(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final url = Uri.parse('$_base$endpoint');
    final headers = await _getAuthHeaders();
    return http.post(url, headers: headers, body: json.encode(body));
  }

  // ── Domain endpoints ──────────────────────────────────────────────────

  /// Fetches the list of available tutors.
  static Future<List<Tutor>> fetchTutors() async {
    final res = await authenticatedGet('/api/tutors');
    if (res.statusCode == 200) {
      final body = json.decode(res.body);
      final list = (body['data'] as List).cast<Map<String, dynamic>>();
      return list.map((e) => Tutor.fromJson(e)).toList();
    }
    throw Exception('Failed to load tutors: ${res.statusCode}');
  }
}
