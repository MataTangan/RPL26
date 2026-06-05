import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/booking_session.dart';
import '../../services/mock_data.dart';
import '../../theme.dart';
import 'rating_page.dart';

class SiswaBookingHistoryPage extends StatefulWidget {
  const SiswaBookingHistoryPage({super.key});

  @override
  State<SiswaBookingHistoryPage> createState() =>
      _SiswaBookingHistoryPageState();
}

class _SiswaBookingHistoryPageState extends State<SiswaBookingHistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  List<BookingSession> get _upcoming =>
      MockData.sessions.where((s) => s.status == SessionStatus.active).toList();
  List<BookingSession> get _pending =>
      MockData.sessions.where((s) => s.status == SessionStatus.pending).toList();
  List<BookingSession> get _past =>
      MockData.sessions.where((s) => s.status == SessionStatus.past).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // ── Header ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('My Sessions 📅', style: AppTextStyles.displayBold),
              const SizedBox(height: 4),
              Text('Track upcoming, pending & completed sessions',
                  style: AppTextStyles.appBarSub),
              const SizedBox(height: 18),

              // ── Tab bar ──────────────────────────────────────
              Container(
                height: 48,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05), blurRadius: 10)
                  ],
                ),
                child: TabBar(
                  controller: _tab,
                  labelStyle: GoogleFonts.nunito(
                      fontWeight: FontWeight.w800, fontSize: 13),
                  unselectedLabelStyle: GoogleFonts.nunito(
                      fontWeight: FontWeight.w600, fontSize: 13),
                  labelColor: Colors.white,
                  unselectedLabelColor: const Color(0xFF888899),
                  indicator: BoxDecoration(
                    color: AppColors.deepBlue,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: 'Upcoming'),
                    Tab(text: 'Pending'),
                    Tab(text: 'Done'),
                  ],
                ),
              ),
            ]),
          ),

          Expanded(
            child: TabBarView(
              controller: _tab,
              children: [
                _SessionList(sessions: _upcoming, emptyMsg: 'No upcoming sessions!', emptyEmoji: '🗓️'),
                _SessionList(sessions: _pending, emptyMsg: 'No pending sessions!', emptyEmoji: '⏳'),
                _SessionList(sessions: _past, emptyMsg: 'No completed sessions yet.', emptyEmoji: '✅', showRate: true),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

// ─── Session list ─────────────────────────────────────────────────────────────

class _SessionList extends StatelessWidget {
  final List<BookingSession> sessions;
  final String emptyMsg;
  final String emptyEmoji;
  final bool showRate;
  const _SessionList({
    required this.sessions,
    required this.emptyMsg,
    required this.emptyEmoji,
    this.showRate = false,
  });

  @override
  Widget build(BuildContext context) {
    if (sessions.isEmpty) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(emptyEmoji, style: const TextStyle(fontSize: 52)),
          const SizedBox(height: 12),
          Text(emptyMsg, style: AppTextStyles.cardTitle),
        ]),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      itemCount: sessions.length,
      itemBuilder: (_, i) => _SessionCard(
        session: sessions[i],
        index: i,
        showRate: showRate,
      ),
    );
  }
}

// ─── Session card ─────────────────────────────────────────────────────────────

class _SessionCard extends StatelessWidget {
  final BookingSession session;
  final int index;
  final bool showRate;
  const _SessionCard(
      {required this.session, required this.index, required this.showRate});

  Color _statusColor(SessionStatus s) {
    switch (s) {
      case SessionStatus.active:
        return AppColors.mintGreen;
      case SessionStatus.pending:
        return AppColors.mustardYellow;
      case SessionStatus.past:
        return const Color(0xFFB0B0C0);
    }
  }

  Color _statusTextColor(SessionStatus s) {
    switch (s) {
      case SessionStatus.active:
        return const Color(0xFF006B63);
      case SessionStatus.pending:
        return const Color(0xFF7A5C00);
      case SessionStatus.past:
        return const Color(0xFF606070);
    }
  }

  String _statusEmoji(SessionStatus s) {
    switch (s) {
      case SessionStatus.active:
        return '🟢';
      case SessionStatus.pending:
        return '🟡';
      case SessionStatus.past:
        return '✅';
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent =
        AppColors.cardAccents[index % AppColors.cardAccents.length];
    final s = session;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: accent.withOpacity(0.18),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(children: [
          Row(children: [
            // Avatar
            Container(
              width: 54,
              height: 54,
              decoration:
                  BoxDecoration(color: accent, shape: BoxShape.circle),
              child: Center(
                child: Text(s.tutorAvatarEmoji,
                    style: const TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(width: 14),
            // Info
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.tutorName,
                        style:
                            AppTextStyles.cardTitle.copyWith(fontSize: 15)),
                    const SizedBox(height: 2),
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
            ),
            // Status badge
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _statusColor(s.status).withOpacity(0.18),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(_statusEmoji(s.status),
                      style: const TextStyle(fontSize: 10)),
                  const SizedBox(width: 4),
                  Text(
                    s.status.label,
                    style: AppTextStyles.chip.copyWith(
                      color: _statusTextColor(s.status),
                      fontSize: 11,
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 6),
              Text(
                'Rp ${s.ratePerHour.toStringAsFixed(0)}',
                style: AppTextStyles.priceBadge.copyWith(fontSize: 16),
              ),
            ]),
          ]),
          const SizedBox(height: 12),
          // Date/time strip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(children: [
              const Text('🗓️', style: TextStyle(fontSize: 13)),
              const SizedBox(width: 8),
              Text(s.date,
                  style: AppTextStyles.bodyMuted.copyWith(fontSize: 12)),
              const Spacer(),
              const Text('⏰', style: TextStyle(fontSize: 13)),
              const SizedBox(width: 6),
              Text(s.timeSlot,
                  style: AppTextStyles.chip.copyWith(
                      color: AppColors.deepBlue, fontSize: 12)),
            ]),
          ),

          // Rate button for completed sessions
          if (showRate) ...[
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => SiswaRatingPage(
                  tutorName: s.tutorName,
                  accent: accent,
                ),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 11),
                decoration: BoxDecoration(
                  color: AppColors.mustardYellow.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: AppColors.mustardYellow.withOpacity(0.4),
                      width: 1.5),
                ),
                child: Center(
                  child: Text(
                    '⭐  Leave a Review',
                    style: AppTextStyles.chip.copyWith(
                      color: const Color(0xFF7A5C00),
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ]),
      ),
    );
  }
}
