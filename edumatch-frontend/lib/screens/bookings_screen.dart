import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/booking_session.dart';
import '../services/mock_data.dart';
import '../theme.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  List<BookingSession> get _upcoming =>
      MockData.sessions.where((s) => s.status == SessionStatus.active).toList();

  List<BookingSession> get _past =>
      MockData.sessions.where((s) => s.status == SessionStatus.past).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('My Bookings 📅', style: AppTextStyles.displayBold),
              const SizedBox(height: 4),
              Text('Track your upcoming & past sessions',
                  style: AppTextStyles.appBarSub),
              const SizedBox(height: 16),
              // Custom tab bar
              Container(
                height: 46,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10)
                  ],
                ),
                child: TabBar(
                  controller: _tab,
                  labelStyle: GoogleFonts.nunito(
                      fontWeight: FontWeight.w800, fontSize: 14),
                  unselectedLabelStyle: GoogleFonts.nunito(
                      fontWeight: FontWeight.w600, fontSize: 14),
                  labelColor: Colors.white,
                  unselectedLabelColor: const Color(0xFF888899),
                  indicator: BoxDecoration(
                    color: AppColors.deepBlue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: 'Upcoming'),
                    Tab(text: 'Completed'),
                  ],
                ),
              ),
            ]),
          ),

          Expanded(
            child: TabBarView(
              controller: _tab,
              children: [
                _SessionList(
                    sessions: _upcoming, emptyMsg: 'No upcoming sessions!'),
                _SessionList(
                    sessions: _past, emptyMsg: 'No completed sessions yet.'),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class _SessionList extends StatelessWidget {
  final List<BookingSession> sessions;
  final String emptyMsg;
  const _SessionList({required this.sessions, required this.emptyMsg});

  @override
  Widget build(BuildContext context) {
    if (sessions.isEmpty) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('📭', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 10),
          Text(emptyMsg, style: AppTextStyles.cardTitle),
        ]),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      itemCount: sessions.length,
      itemBuilder: (_, i) {
        final s = sessions[i];
        final accent = AppColors.cardAccents[i % AppColors.cardAccents.length];
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                    color: accent.withValues(alpha: 0.18),
                    blurRadius: 18,
                    offset: const Offset(0, 6))
              ],
            ),
            child: Row(children: [
              Container(
                width: 52,
                height: 52,
                decoration:
                    BoxDecoration(color: accent, shape: BoxShape.circle),
                child: Center(
                    child: Text(s.tutorAvatarEmoji,
                        style: const TextStyle(fontSize: 24))),
              ),
              const SizedBox(width: 14),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(s.tutorName,
                        style: AppTextStyles.cardTitle.copyWith(fontSize: 15)),
                    const SizedBox(height: 2),
                    Text(s.subject, style: AppTextStyles.bodyMuted),
                    const SizedBox(height: 4),
                    Row(children: [
                      const Text('🗓️', style: TextStyle(fontSize: 12)),
                      const SizedBox(width: 4),
                      Text('${s.date}  •  ${s.timeSlot}',
                          style: AppTextStyles.bodyMuted),
                    ]),
                  ])),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(s.status.label,
                      style: AppTextStyles.chip
                          .copyWith(color: AppColors.deepBlue)),
                ),
                const SizedBox(height: 6),
                Text('Rp ${s.ratePerHour.toStringAsFixed(0)}',
                    style: AppTextStyles.priceBadge.copyWith(fontSize: 16)),
              ]),
            ]),
          ),
        );
      },
    );
  }
}
