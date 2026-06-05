import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/env.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  AuthProvider
//  Handles login / register for both Siswa and Tutor roles.
//  Persists the JWT token using SharedPreferences.
// ─────────────────────────────────────────────────────────────────────────────

class AuthProvider with ChangeNotifier {
  // ── State ──────────────────────────────────────────────────────────────────
  String? _token;
  Map<String, dynamic>? _user;

  String? get token => _token;
  Map<String, dynamic>? get user => _user;
  bool get isAuthenticated => _token != null;
  String get userName => _user?['name'] ?? '';
  String get userEmail => _user?['email'] ?? '';
  String get userRole => _user?['role'] ?? '';

  // ── SharedPreferences keys ─────────────────────────────────────────────────
  static const _keyToken = 'edumatch_token';
  static const _keyUser  = 'edumatch_user';

  // ── Initialise from persisted storage ─────────────────────────────────────
  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString(_keyToken);
    final savedUser  = prefs.getString(_keyUser);
    if (savedToken != null && savedUser != null) {
      _token = savedToken;
      _user  = json.decode(savedUser) as Map<String, dynamic>;
      notifyListeners();
    }
  }

  // ── Persist helpers ────────────────────────────────────────────────────────
  Future<void> _saveSession(String token, Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
    await prefs.setString(_keyUser, json.encode(user));
    _token = token;
    _user  = user;
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyUser);
    _token = null;
    _user  = null;
    notifyListeners();
  }

  // ── Internal POST helper ───────────────────────────────────────────────────
  Future<Map<String, dynamic>> _post(String path, Map<String, dynamic> body) async {
    final uri = Uri.parse('$apiBase$path');
    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    ).timeout(const Duration(seconds: 15));

    final decoded = json.decode(res.body) as Map<String, dynamic>;

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return decoded;
    }

    // Extract the human-readable message sent by the backend
    final message = decoded['message'] ?? 'Terjadi kesalahan. Coba lagi.';
    throw AuthException(message);
  }

  // ── Siswa login ────────────────────────────────────────────────────────────
  Future<void> loginSiswa({
    required String email,
    required String password,
  }) async {
    final data = await _post('/siswa/auth/login', {
      'email': email,
      'password': password,
    });
    await _saveSession(data['token'] as String, data['user'] as Map<String, dynamic>);
  }

  // ── Siswa register ─────────────────────────────────────────────────────────
  Future<void> registerSiswa({
    required String name,
    required String email,
    required String password,
  }) async {
    final data = await _post('/siswa/auth/register', {
      'name': name,
      'email': email,
      'password': password,
    });
    await _saveSession(data['token'] as String, data['user'] as Map<String, dynamic>);
  }

  // ── Tutor login ────────────────────────────────────────────────────────────
  Future<void> loginTutor({
    required String email,
    required String password,
  }) async {
    final data = await _post('/tutor/auth/login', {
      'email': email,
      'password': password,
    });
    await _saveSession(data['token'] as String, data['user'] as Map<String, dynamic>);
  }

  // ── Tutor register ─────────────────────────────────────────────────────────
  Future<void> registerTutor({
    required String name,
    required String email,
    required String password,
    String phone = '',
  }) async {
    final data = await _post('/tutor/auth/register', {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
    });
    await _saveSession(data['token'] as String, data['user'] as Map<String, dynamic>);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  AuthException — carries the backend's human-readable error message
// ─────────────────────────────────────────────────────────────────────────────

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}
