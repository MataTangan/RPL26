import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/tutor.dart';
import '../models/booking_session.dart';
import '../config/env.dart';
import 'mock_data.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  ApiService
//  Provides reusable HTTP helpers that automatically inject the saved JWT
//  token into every request.  All data methods respect the [useMockData] flag.
// ─────────────────────────────────────────────────────────────────────────────

class ApiService {
  // ── Token retrieval ────────────────────────────────────────────────────────

  /// Reads the saved JWT token from SharedPreferences.
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('edumatch_token');
  }

  // ── Authenticated HTTP helpers ─────────────────────────────────────────────

  /// Builds the standard request headers, injecting the Bearer token
  /// if one is available in SharedPreferences.
  static Future<Map<String, String>> _authHeaders({
    bool contentTypeJson = false,
  }) async {
    final token = await getToken();
    return {
      if (contentTypeJson) 'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Authenticated GET request to [path] (relative to [apiBase]).
  static Future<http.Response> get(String path) async {
    final headers = await _authHeaders();
    return http.get(
      Uri.parse('$apiBase$path'),
      headers: headers,
    );
  }

  /// Authenticated POST request to [path] with a JSON [body].
  static Future<http.Response> post(
    String path,
    Map<String, dynamic> body,
  ) async {
    final headers = await _authHeaders(contentTypeJson: true);
    return http.post(
      Uri.parse('$apiBase$path'),
      headers: headers,
      body: json.encode(body),
    );
  }

  /// Authenticated PUT request to [path] with a JSON [body].
  static Future<http.Response> put(
    String path,
    Map<String, dynamic> body,
  ) async {
    final headers = await _authHeaders(contentTypeJson: true);
    return http.put(
      Uri.parse('$apiBase$path'),
      headers: headers,
      body: json.encode(body),
    );
  }

  /// Authenticated PATCH request to [path] with an optional JSON [body].
  static Future<http.Response> patch(
    String path, [
    Map<String, dynamic>? body,
  ]) async {
    final headers = await _authHeaders(contentTypeJson: body != null);
    return http.patch(
      Uri.parse('$apiBase$path'),
      headers: headers,
      body: body != null ? json.encode(body) : null,
    );
  }

  // ─── Tutors ───────────────────────────────────────────────────────────────

  /// Fetch all tutors.
  ///
  /// Returns [MockData.tutors] after a simulated delay when [useMockData] is
  /// `true`; otherwise performs a real GET request to `[apiBase]/api/tutors`.
  static Future<List<Tutor>> fetchTutors() async {
    if (useMockData) {
      await Future.delayed(mockDelay);
      return MockData.tutors;
    }

    final res = await get('/api/tutors');
    if (res.statusCode == 200) {
      final body = json.decode(res.body);
      final list = (body['data'] as List).cast<Map<String, dynamic>>();
      return list.map((e) => Tutor.fromJson(e)).toList();
    }
    throw Exception('fetchTutors failed — HTTP ${res.statusCode}');
  }

  // ─── Booking Sessions ─────────────────────────────────────────────────────

  /// Fetch all booking sessions for the current user.
  ///
  /// Returns [MockData.sessions] after a simulated delay when [useMockData] is
  /// `true`; otherwise performs an authenticated GET to `[apiBase]/api/sessions`.
  static Future<List<BookingSession>> fetchSessions() async {
    if (useMockData) {
      await Future.delayed(mockDelay);
      return MockData.sessions;
    }

    final res = await get('/api/sessions');
    if (res.statusCode == 200) {
      final body = json.decode(res.body);
      final list = (body['data'] as List).cast<Map<String, dynamic>>();
      return list.map((e) => BookingSession.fromJson(e)).toList();
    }
    throw Exception('fetchSessions failed — HTTP ${res.statusCode}');
  }

  /// Fetch a single tutor by [id].
  static Future<Tutor> fetchTutorById(int id) async {
    if (useMockData) {
      await Future.delayed(mockDelay);
      return MockData.tutors.firstWhere(
        (t) => t.id == id,
        orElse: () => throw Exception('Tutor $id not found in mock data'),
      );
    }

    final res = await get('/api/tutors/$id');
    if (res.statusCode == 200) {
      return Tutor.fromJson(json.decode(res.body)['data']);
    }
    throw Exception('fetchTutorById($id) failed — HTTP ${res.statusCode}');
  }

  /// Submit a new booking request.
  ///
  /// [tutorId]  — ID of the selected tutor.
  /// [slot]     — The chosen time-slot string.
  /// [subject]  — Subject to study.
  ///
  /// Returns `true` on success.
  static Future<bool> createBooking({
    required int tutorId,
    required String slot,
    required String subject,
  }) async {
    if (useMockData) {
      await Future.delayed(mockDelay * 2);
      return true;
    }

    final res = await post('/api/bookings', {
      'tutorId': tutorId,
      'slot': slot,
      'subject': subject,
    });
    if (res.statusCode == 201) return true;
    throw Exception('createBooking failed — HTTP ${res.statusCode}');
  }

  /// Accept or reject a pending booking (tutor action).
  ///
  /// [accept] — `true` to accept, `false` to decline.
  static Future<bool> respondToBooking(int sessionId,
      {required bool accept}) async {
    if (useMockData) {
      await Future.delayed(mockDelay);
      return true;
    }

    final action = accept ? 'accept' : 'decline';
    final res = await patch('/api/bookings/$sessionId/$action');
    if (res.statusCode == 200) return true;
    throw Exception('respondToBooking($sessionId) failed — HTTP ${res.statusCode}');
  }
}
