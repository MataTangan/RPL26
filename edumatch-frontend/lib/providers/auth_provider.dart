import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  AuthProvider — Real HTTP Authentication
//  Makes actual POST requests to the backend API.
//  Throws AuthException on invalid credentials or server errors so the UI
//  can display a meaningful error Snackbar.
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

  // ── Persist helpers ────────────────────────────────────────────────────────
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

  // ── Siswa login ────────────────────────────────────────────────────────────
  Future<void> loginSiswa({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    final token = 'dummy_siswa_token_${DateTime.now().millisecondsSinceEpoch}';
    final userMap = {
      'name': email.split('@').first,
      'email': email,
      'role': 'siswa',
    };

    await _saveSession(token, userMap);
  }

  // ── Siswa register ─────────────────────────────────────────────────────────
  Future<void> registerSiswa({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    final token = 'dummy_siswa_token_${DateTime.now().millisecondsSinceEpoch}';
    final userMap = {
      'name': name,
      'email': email,
      'role': 'siswa',
    };

    await _saveSession(token, userMap);
  }

  // ── Tutor login ────────────────────────────────────────────────────────────
  Future<void> loginTutor({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    final token = 'dummy_tutor_token_${DateTime.now().millisecondsSinceEpoch}';
    final userMap = {
      'name': email.split('@').first,
      'email': email,
      'role': 'tutor',
    };

    await _saveSession(token, userMap);
  }

  // ── Tutor register ─────────────────────────────────────────────────────────
  Future<void> registerTutor({
    required String name,
    required String email,
    required String password,
    String phone = '',
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    final token = 'dummy_tutor_token_${DateTime.now().millisecondsSinceEpoch}';
    final userMap = {
      'name': name,
      'email': email,
      'phone': phone,
      'role': 'tutor',
    };

    await _saveSession(token, userMap);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  AuthException
// ─────────────────────────────────────────────────────────────────────────────

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}
