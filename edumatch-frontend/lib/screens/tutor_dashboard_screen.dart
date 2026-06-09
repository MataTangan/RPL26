import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/booking_session.dart';
import '../services/mock_data.dart';
import '../theme.dart';

class TutorDashboardScreen extends StatelessWidget {
  const TutorDashboardScreen({super.key});

  List<BookingSession> get _upcoming =>
      MockData.sessions.where((s) => s.status == SessionStatus.active).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Greeting
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.deepBlue, Color(0xFF3949AB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Good Morning! 🌤️',
                        style: GoogleFonts.nunito(
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                            color: Colors.white)),
                    const SizedBox(height: 4),
                    Text('Here\'s your schedule for today.',
                        style: GoogleFonts.nunito(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Colors.white70)),
                  ]),
            ),
            const SizedBox(height: 22),

            // Stats row
            Text('📊  Overview',
                style: AppTextStyles.cardTitle.copyWith(fontSize: 16)),
            const SizedBox(height: 10),
            Row(children: [
              _MiniStat(
                  emoji: '📅',
                  label: 'This Week',
                  value: '${_upcoming.length}',
                  accent: AppColors.mustardYellow),
              const SizedBox(width: 10),
              _MiniStat(
                  emoji: '✅',
                  label: 'Completed',
                  value:
                      '${MockData.sessions.where((s) => s.status == SessionStatus.past).length}',
                  accent: AppColors.mintGreen),
              const SizedBox(width: 10),
              const _MiniStat(
                  emoji: '⭐',
                  label: 'Rating',
                  value: '4.9',
                  accent: AppColors.pastelPurple),
            ]),
            const SizedBox(height: 24),

            // Upcoming sessions
            Text('🗓️  Upcoming Sessions',
                style: AppTextStyles.cardTitle.copyWith(fontSize: 16)),
            const SizedBox(height: 10),

            if (_upcoming.isEmpty)
              Center(
                  child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(children: [
                  const Text('🎉', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 8),
                  Text('You\'re all caught up!',
                      style: AppTextStyles.cardTitle),
                ]),
              ))
            else
              ...(_upcoming.asMap().entries.map((e) {
                final i = e.key;
                final s = e.value;
                final accent =
                    AppColors.cardAccents[i % AppColors.cardAccents.length];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                            color: accent.withValues(alpha: 0.2),
                            blurRadius: 16,
                            offset: const Offset(0, 6))
                      ],
                    ),
                    child: Row(children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                            child: Text(s.tutorAvatarEmoji,
                                style: const TextStyle(fontSize: 26))),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text(s.studentName,
                                style: AppTextStyles.cardTitle
                                    .copyWith(fontSize: 15)),
                            const SizedBox(height: 2),
                            Text(s.subject, style: AppTextStyles.bodyMuted),
                            const SizedBox(height: 4),
                            Row(children: [
                              Icon(Icons.access_time_rounded,
                                  size: 13, color: accent),
                              const SizedBox(width: 4),
                              Text('${s.date}  •  ${s.timeSlot}',
                                  style: AppTextStyles.bodyMuted),
                            ]),
                          ])),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text('Rp ${s.ratePerHour.toStringAsFixed(0)}',
                            style: AppTextStyles.chip
                                .copyWith(color: AppColors.deepBlue)),
                      ),
                    ]),
                  ),
                );
              }).toList()),

            const SizedBox(height: 10),
          ]),
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String emoji, label, value;
  final Color accent;
  const _MiniStat(
      {required this.emoji,
      required this.label,
      required this.value,
      required this.accent});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20)),
          child: Column(children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 4),
            Text(value, style: AppTextStyles.cardTitle.copyWith(fontSize: 18)),
            Text(label, style: AppTextStyles.bodyMuted),
          ]),
        ),
      );
}
