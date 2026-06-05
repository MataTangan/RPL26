import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/booking_session.dart';
import '../../services/mock_data.dart';
import '../../theme.dart';

class TutorDashboardPage extends StatelessWidget {
  const TutorDashboardPage({super.key});

  // Mock tutor stats
  static const _tutorName = 'Aisha Rahma';
  static const _tutorEmoji = '🌟';
  static const _totalEarnings = 12350.0;
  static const _rating = 4.9;
  static const _totalStudents = 47;

  @override
  Widget build(BuildContext context) {
    final upcoming = MockData.sessions
        .where((s) => s.status == SessionStatus.active)
        .toList();
    final pending = MockData.sessions
        .where((s) => s.status == SessionStatus.pending)
        .toList();
    final completed = MockData.sessions
        .where((s) => s.status == SessionStatus.past)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            // ── Greeting row ──────────────────────────────────────
            Row(children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.mustardYellow,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.mustardYellow.withOpacity(0.4),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(_tutorEmoji, style: const TextStyle(fontSize: 24)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Good morning! 👋',
                      style: AppTextStyles.bodyMuted.copyWith(fontSize: 13)),
                  Text(_tutorName,
                      style: AppTextStyles.cardTitle.copyWith(fontSize: 18)),
                ]),
              ),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.notifications_none_rounded,
                    color: AppColors.deepBlue, size: 22),
              ),
            ]),
            const SizedBox(height: 24),

            // ── Hero earnings card ────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.deepBlue, Color(0xFF3949AB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.deepBlue.withOpacity(0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text('💰  Total Earnings',
                        style: GoogleFonts.nunito(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.85))),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.mintGreen.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text('This Month',
                        style: GoogleFonts.nunito(
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                            color: Colors.white.withOpacity(0.8))),
                  ),
                ]),
                const SizedBox(height: 14),
                Text(
                  'Rp ${_totalEarnings.toStringAsFixed(0)}',
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w900,
                    fontSize: 34,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Row(children: [
                  const Text('📈', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  Text('+12.4% from last month',
                      style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.75))),
                ]),
              ]),
            ),
            const SizedBox(height: 18),

            // ── Quick stats 2×2 Bento ────────────────────────────
            Row(children: [
              _QuickStat(
                emoji: '📅',
                value: '${upcoming.length}',
                label: 'Upcoming',
                accent: AppColors.mintGreen,
              ),
              const SizedBox(width: 12),
              _QuickStat(
                emoji: '⏳',
                value: '${pending.length}',
                label: 'Pending',
                accent: AppColors.mustardYellow,
              ),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              _QuickStat(
                emoji: '👩‍🎓',
                value: '$_totalStudents',
                label: 'Students',
                accent: AppColors.pastelPurple,
              ),
              const SizedBox(width: 12),
              _QuickStat(
                emoji: '⭐',
                value: '$_rating',
                label: 'Avg Rating',
                accent: AppColors.skyBlue,
              ),
            ]),
            const SizedBox(height: 24),

            // ── Upcoming sessions ─────────────────────────────────
            Row(children: [
              Text('Upcoming Sessions 🗓️',
                  style: AppTextStyles.cardTitle.copyWith(fontSize: 16)),
              const Spacer(),
              Text('${upcoming.length} total',
                  style: AppTextStyles.bodyMuted.copyWith(fontSize: 12)),
            ]),
            const SizedBox(height: 12),

            if (upcoming.isEmpty)
              _EmptyCard(
                emoji: '🎉',
                msg: 'No sessions today!',
                sub: 'Check back tomorrow.',
              )
            else
              ...upcoming.asMap().entries.map((e) => _UpcomingCard(
                    session: e.value,
                    index: e.key,
                  )),
            const SizedBox(height: 24),

            // ── Pending requests preview ──────────────────────────
            Row(children: [
              Text('New Requests 📥',
                  style: AppTextStyles.cardTitle.copyWith(fontSize: 16)),
              const Spacer(),
              if (pending.isNotEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.brightOrange,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text('${pending.length} new',
                      style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                          color: Colors.white)),
                ),
            ]),
            const SizedBox(height: 12),

            if (pending.isEmpty)
              _EmptyCard(emoji: '📭', msg: 'No pending requests', sub: '')
            else
              ...pending.take(2).toList().asMap().entries.map((e) =>
                  _RequestPreviewCard(session: e.value, index: e.key)),

            const SizedBox(height: 24),

            // ── Past sessions mini ────────────────────────────────
            Text('Recent Completions ✅',
                style: AppTextStyles.cardTitle.copyWith(fontSize: 16)),
            const SizedBox(height: 12),

            if (completed.isEmpty)
              _EmptyCard(emoji: '📚', msg: 'No past sessions yet', sub: '')
            else
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: completed.take(3).toList().asMap().entries.map((e) {
                    final s = e.value;
                    final accent = AppColors.cardAccents[
                        e.key % AppColors.cardAccents.length];
                    return Padding(
                      padding: EdgeInsets.only(
                          bottom: e.key < completed.length - 1 ? 12 : 0),
                      child: Row(children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration:
                              BoxDecoration(color: accent, shape: BoxShape.circle),
                          child: Center(
                            child: Text(s.tutorAvatarEmoji,
                                style: const TextStyle(fontSize: 16)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(s.studentName,
                                style:
                                    AppTextStyles.chip.copyWith(color: AppColors.deepBlue, fontSize: 13)),
                            Text(s.subject, style: AppTextStyles.bodyMuted.copyWith(fontSize: 11)),
                          ]),
                        ),
                        Text('Rp ${s.ratePerHour.toStringAsFixed(0)}',
                            style:
                                AppTextStyles.priceBadge.copyWith(fontSize: 14)),
                      ]),
                    );
                  }).toList(),
                ),
              ),
          ]),
        ),
      ),
    );
  }
}

// ─── Sub-widgets ─────────────────────────────────────────────────────────────

class _QuickStat extends StatelessWidget {
  final String emoji, value, label;
  final Color accent;
  const _QuickStat(
      {required this.emoji,
      required this.value,
      required this.label,
      required this.accent});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: accent.withOpacity(0.2),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: accent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22))),
            ),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(value, style: AppTextStyles.cardTitle.copyWith(fontSize: 22)),
              Text(label, style: AppTextStyles.bodyMuted.copyWith(fontSize: 11)),
            ]),
          ]),
        ),
      );
}

class _UpcomingCard extends StatelessWidget {
  final BookingSession session;
  final int index;
  const _UpcomingCard({required this.session, required this.index});

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.cardAccents[index % AppColors.cardAccents.length];
    final s = session;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: accent.withOpacity(0.2),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
            child: Center(
              child: Text(s.tutorAvatarEmoji, style: const TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(s.studentName,
                  style: AppTextStyles.cardTitle.copyWith(fontSize: 14)),
              Text(s.subject, style: AppTextStyles.bodyMuted),
              const SizedBox(height: 4),
              Row(children: [
                const Text('🗓️', style: TextStyle(fontSize: 11)),
                const SizedBox(width: 4),
                Text('${s.date}  •  ${s.timeSlot}',
                    style: AppTextStyles.bodyMuted.copyWith(fontSize: 11)),
              ]),
            ]),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.mintGreen.withOpacity(0.15),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text('🟢 Live',
                style: AppTextStyles.chip
                    .copyWith(color: const Color(0xFF006B63), fontSize: 11)),
          ),
        ]),
      ),
    );
  }
}

class _RequestPreviewCard extends StatelessWidget {
  final BookingSession session;
  final int index;
  const _RequestPreviewCard({required this.session, required this.index});

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.cardAccents[
        (index + 2) % AppColors.cardAccents.length];
    final s = session;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: accent.withOpacity(0.3), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: accent.withOpacity(0.2), shape: BoxShape.circle),
            child: Center(child: Text('👤', style: const TextStyle(fontSize: 18))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(s.studentName,
                  style: AppTextStyles.chip.copyWith(color: AppColors.deepBlue, fontSize: 13)),
              Text('wants: ${s.subject}', style: AppTextStyles.bodyMuted.copyWith(fontSize: 11)),
            ]),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.mustardYellow.withOpacity(0.15),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text('⏳ Pending',
                style: AppTextStyles.chip.copyWith(color: const Color(0xFF7A5C00), fontSize: 11)),
          ),
        ]),
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final String emoji, msg, sub;
  const _EmptyCard({required this.emoji, required this.msg, required this.sub});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04), blurRadius: 10)
          ],
        ),
        child: Column(children: [
          Text(emoji, style: const TextStyle(fontSize: 36)),
          const SizedBox(height: 8),
          Text(msg, style: AppTextStyles.cardTitle.copyWith(fontSize: 15)),
          if (sub.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(sub, style: AppTextStyles.bodyMuted.copyWith(fontSize: 12)),
          ],
        ]),
      );
}
