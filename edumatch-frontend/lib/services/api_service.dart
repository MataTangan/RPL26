import '../models/tutor.dart';
import '../models/booking_session.dart';
import 'mock_data.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  ApiService — Standalone MVP (100% Offline)
//  All methods return data from MockData with a simulated network delay.
//  No HTTP calls, no backend dependency.
// ─────────────────────────────────────────────────────────────────────────────

class ApiService {
  /// Simulated network latency (feels realistic to investors).
  static const _delay = Duration(seconds: 1);

  // ─── Tutors ───────────────────────────────────────────────────────────────

  /// Returns the full list of mock tutors after a simulated delay.
  static Future<List<Tutor>> fetchTutors() async {
    await Future.delayed(_delay);
    return MockData.tutors;
  }

  /// Returns a single tutor by [id] from the mock list.
  static Future<Tutor> fetchTutorById(int id) async {
    await Future.delayed(_delay);
    final tutor = MockData.findTutorById(id);
    if (tutor != null) return tutor;
    throw Exception('Tutor $id not found');
  }

  // ─── Booking Sessions ─────────────────────────────────────────────────────

  /// Returns all booking sessions from the in-memory mock list.
  static Future<List<BookingSession>> fetchSessions() async {
    await Future.delayed(_delay);
    return MockData.sessions;
  }

  /// Alias for [fetchSessions] — used by some UI pages.
  static Future<List<BookingSession>> fetchBookingHistory() async {
    await Future.delayed(_delay);
    return MockData.sessionHistory.isNotEmpty 
        ? MockData.sessionHistory 
        : MockData.sessions; // fallback to dummy list if history is empty
  }

  /// Creates a new booking and adds it to the in-memory list.
  /// Always returns `true` (success).
  static Future<bool> createBooking({
    required int tutorId,
    required String slot,
    required String subject,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1500));

    final tutor = MockData.findTutorById(tutorId);
    final session = BookingSession(
      id: MockData.nextId(),
      tutorId: tutorId,
      tutorName: tutor?.name ?? 'Unknown Tutor',
      studentName: 'Rizky Maulana', // demo user
      subject: subject,
      date: _formatToday(),
      timeSlot: slot,
      ratePerHour: tutor?.ratePerHour ?? 0,
      status: SessionStatus.pending,
      tutorAvatarEmoji: tutor?.avatarEmoji ?? '🎓',
    );

    MockData.addBooking(session);
    return true;
  }

  /// Accept or reject a pending booking (tutor action).
  static Future<bool> respondToBooking(int sessionId,
      {required bool accept}) async {
    await Future.delayed(_delay);
    final newStatus = accept ? SessionStatus.active : SessionStatus.past;
    return MockData.updateSessionStatus(sessionId, newStatus);
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  /// Returns a nicely formatted date string for today (used for new bookings).
  static String _formatToday() {
    final now = DateTime.now();
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${days[now.weekday - 1]}, ${now.day.toString().padLeft(2, '0')} '
        '${months[now.month - 1]} ${now.year}';
  }
}
