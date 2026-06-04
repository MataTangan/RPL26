import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages authentication state for EduMatch.
///
/// Persists JWT token and user role ("siswa" | "tutor") in SharedPreferences.
/// Notifies listeners on every state change so the UI can react accordingly.
class AuthProvider with ChangeNotifier {
  // ── Private state ──────────────────────────────────────────────────────
  bool _isLoggedIn = false;
  String? _token;
  String? _role; // "siswa" | "tutor"
  bool _isLoading = true; // true while checking auth on startup

  // ── Public getters ─────────────────────────────────────────────────────
  bool get isLoggedIn => _isLoggedIn;
  String? get token => _token;
  String? get role => _role;
  bool get isLoading => _isLoading;

  // ── SharedPreferences keys ─────────────────────────────────────────────
  static const _keyToken = 'auth_token';
  static const _keyRole = 'auth_role';

  // ── Check persisted auth on startup ────────────────────────────────────
  /// Call this once from the AuthGate widget in main.dart.
  /// Reads token & role from SharedPreferences and updates state.
  Future<void> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString(_keyToken);
      _role = prefs.getString(_keyRole);
      _isLoggedIn = _token != null && _token!.isNotEmpty;
    } catch (e) {
      debugPrint('AuthProvider.checkAuthStatus error: $e');
      _isLoggedIn = false;
    }

    _isLoading = false;
    notifyListeners();
  }

  // ── Dummy login (simulates network call) ───────────────────────────────
  /// Simulates a 1.5‑second network delay, then saves a mock JWT token and
  /// the chosen [role] to SharedPreferences.
  ///
  /// Returns `true` on success, `false` on failure.
  Future<bool> login(String email, String password, String role) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate network latency
      await Future.delayed(const Duration(milliseconds: 1500));

      // --- Mock validation (replace with real API call later) ---
      if (email.isEmpty || password.isEmpty) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Generate a mock JWT token
      const mockToken =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9'
          '.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkVkdU1hdGNoIFVzZXIiLCJpYXQiOjE3MTcwMDAwMDB9'
          '.mock_signature_edumatch';

      // Persist to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyToken, mockToken);
      await prefs.setString(_keyRole, role);

      // Update in‑memory state
      _token = mockToken;
      _role = role;
      _isLoggedIn = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('AuthProvider.login error: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ── Logout ─────────────────────────────────────────────────────────────
  /// Clears persisted auth data and resets in‑memory state.
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyRole);

    _token = null;
    _role = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}
