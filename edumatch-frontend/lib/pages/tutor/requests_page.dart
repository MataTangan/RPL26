import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/booking_session.dart';
import '../../services/mock_data.dart';
import '../../theme.dart';

class TutorRequestsPage extends StatefulWidget {
  const TutorRequestsPage({super.key});

  @override
  State<TutorRequestsPage> createState() => _TutorRequestsPageState();
}

class _TutorRequestsPageState extends State<TutorRequestsPage> {
  late List<BookingSession> _pending;
  final Set<int> _accepted = {};
  final Set<int> _declined = {};

  @override
  void initState() {
    super.initState();
    _pending = MockData.sessions
        .where((s) => s.status == SessionStatus.pending)
        .toList();
  }

  void _accept(int id) => setState(() => _accepted.add(id));
  void _decline(int id) => setState(() => _declined.add(id));

  List<BookingSession> get _active =>
      _pending.where((s) => !_declined.contains(s.id)).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // ── Header ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
            child: Row(children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Requests 📥', style: AppTextStyles.displayBold),
                  const SizedBox(height: 4),
                  Text('Review and respond to booking requests',
                      style: AppTextStyles.appBarSub),
                ]),
              ),
              // Badge
              if (_active.isNotEmpty)
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColors.brightOrange,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.brightOrange.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '${_active.length}',
                      style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                          color: Colors.white),
                    ),
                  ),
                ),
            ]),
          ),

          // ── List ───────────────────────────────────────────────
          Expanded(
            child: _active.isEmpty
                ? Center(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      const Text('🎉', style: TextStyle(fontSize: 56)),
                      const SizedBox(height: 14),
                      Text('All caught up!',
                          style: AppTextStyles.cardTitle),
                      const SizedBox(height: 6),
                      Text('No pending requests right now.',
                          style: AppTextStyles.bodyMuted),
                    ]),
                  )
                : ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    itemCount: _active.length,
                    itemBuilder: (_, i) => _RequestCard(
                      session: _active[i],
                      index: i,
                      isAccepted: _accepted.contains(_active[i].id),
                      onAccept: () => _accept(_active[i].id),
                      onDecline: () => _decline(_active[i].id),
                    ),
                  ),
          ),
        ]),
      ),
    );
  }
}

// ─── Request card ─────────────────────────────────────────────────────────────

class _RequestCard extends StatelessWidget {
  final BookingSession session;
  final int index;
  final bool isAccepted;
  final VoidCallback onAccept;
  final VoidCallback onDecline;
  const _RequestCard({
    required this.session,
    required this.index,
    required this.isAccepted,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    final s = session;
    final accent =
        AppColors.cardAccents[index % AppColors.cardAccents.length];

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          border: isAccepted
              ? Border.all(color: AppColors.mintGreen, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: isAccepted
                  ? AppColors.mintGreen.withOpacity(0.2)
                  : accent.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          // ── Student info ───────────────────────────────────────
          Row(children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
              child: Center(
                child: Text(s.tutorAvatarEmoji,
                    style: const TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(s.studentName,
                    style: AppTextStyles.cardTitle.copyWith(fontSize: 16)),
                const SizedBox(height: 2),
                Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.chipColors[
                          index % AppColors.chipColors.length],
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      s.subject,
                      style: AppTextStyles.chip.copyWith(
                        color: AppColors.chipTextColors[
                            index % AppColors.chipTextColors.length],
                        fontSize: 11,
                      ),
                    ),
                  ),
                ]),
              ]),
            ),
            if (isAccepted)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.mintGreen.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text('Accepted ✓',
                    style: AppTextStyles.chip
                        .copyWith(color: const Color(0xFF006B63))),
              ),
          ]),
          const SizedBox(height: 14),

          // ── Session details strip ──────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(children: [
              _DetailItem(emoji: '🗓️', value: s.date),
              const SizedBox(width: 14),
              _DetailItem(emoji: '⏰', value: s.timeSlot),
              const Spacer(),
              Text(
                'Rp ${s.ratePerHour.toStringAsFixed(0)}',
                style: AppTextStyles.priceBadge.copyWith(fontSize: 17),
              ),
            ]),
          ),
          const SizedBox(height: 16),

          // ── Action buttons ─────────────────────────────────────
          if (!isAccepted)
            Row(children: [
              // ── Decline button ─────────────────────────────────
              Expanded(
                child: GestureDetector(
                  onTap: onDecline,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEEEE),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                          color: const Color(0xFFFFCCCC), width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        '✕  Decline',
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: const Color(0xFFCC3333),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // ── Accept button ──────────────────────────────────
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: onAccept,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.mintGreen,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.mintGreen.withOpacity(0.45),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '✓  Accept Request',
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ])
          else
            // ── Post-accept CTA ────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 13),
              decoration: BoxDecoration(
                color: AppColors.mintGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                    color: AppColors.mintGreen.withOpacity(0.3), width: 1.5),
              ),
              child: Center(
                child: Text(
                  '💬  Send a message to ${s.studentName.split(' ').first}',
                  style: AppTextStyles.chip
                      .copyWith(color: const Color(0xFF006B63), fontSize: 13),
                ),
              ),
            ),
        ]),
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String emoji, value;
  const _DetailItem({required this.emoji, required this.value});

  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
        Text(emoji, style: const TextStyle(fontSize: 12)),
        const SizedBox(width: 5),
        Text(value,
            style: AppTextStyles.bodyMuted.copyWith(fontSize: 11)),
      ]);
}
