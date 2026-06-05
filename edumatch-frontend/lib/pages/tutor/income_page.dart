import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/booking_session.dart';
import '../../services/mock_data.dart';
import '../../theme.dart';

class TutorIncomePage extends StatelessWidget {
  const TutorIncomePage({super.key});

  static const _monthlyData = [
    _MonthIncome(month: 'Jan', amount: 7800),
    _MonthIncome(month: 'Feb', amount: 9200),
    _MonthIncome(month: 'Mar', amount: 6500),
    _MonthIncome(month: 'Apr', amount: 11400),
    _MonthIncome(month: 'May', amount: 10300),
    _MonthIncome(month: 'Jun', amount: 12350),
  ];

  double get _maxAmount =>
      _monthlyData.fold(0, (m, e) => e.amount > m ? e.amount : m);

  double get _totalThisYear =>
      _monthlyData.fold(0, (s, e) => s + e.amount);

  @override
  Widget build(BuildContext context) {
    final past = MockData.sessions
        .where((s) => s.status == SessionStatus.past)
        .toList();
    final active = MockData.sessions
        .where((s) => s.status == SessionStatus.active)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            // ── Header ────────────────────────────────────────────
            Text('Income 💰', style: AppTextStyles.displayBold),
            const SizedBox(height: 4),
            Text('Your teaching earnings at a glance',
                style: AppTextStyles.appBarSub),
            const SizedBox(height: 22),

            // ── Hero totals card ──────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.mintGreen, Color(0xFF26A69A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.mintGreen.withOpacity(0.4),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text('📊  Year to Date',
                      style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.9))),
                ),
                const SizedBox(height: 12),
                Text(
                  'Rp ${_totalThisYear.toStringAsFixed(0)}',
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w900,
                    fontSize: 32,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 14),
                Row(children: [
                  _HeroStat(
                      label: 'This Month',
                      value: 'Rp 12,350',
                      icon: '📅'),
                  const SizedBox(width: 20),
                  _HeroStat(
                      label: 'Sessions',
                      value: '${past.length + active.length}',
                      icon: '📚'),
                  const SizedBox(width: 20),
                  _HeroStat(label: 'Avg/Session', value: 'Rp 85', icon: '⭐'),
                ]),
              ]),
            ),
            const SizedBox(height: 22),

            // ── Bar chart ─────────────────────────────────────────
            Text('Monthly Earnings 📈',
                style: AppTextStyles.cardTitle.copyWith(fontSize: 16)),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(children: [
                SizedBox(
                  height: 140,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: _monthlyData.asMap().entries.map((e) {
                      final idx = e.key;
                      final d = e.value;
                      final ratio = d.amount / _maxAmount;
                      final isLast = idx == _monthlyData.length - 1;
                      final accent = AppColors.cardAccents[
                          idx % AppColors.cardAccents.length];
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Value label (only last bar)
                              if (isLast)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    '${(d.amount / 1000).toStringAsFixed(1)}K',
                                    style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 9,
                                      color: accent,
                                    ),
                                  ),
                                ),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 600),
                                curve: Curves.easeOut,
                                height: 120 * ratio,
                                decoration: BoxDecoration(
                                  color: isLast ? accent : accent.withOpacity(0.35),
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(8)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: _monthlyData
                      .map((d) => Expanded(
                            child: Center(
                              child: Text(d.month,
                                  style: AppTextStyles.bodyMuted
                                      .copyWith(fontSize: 11)),
                            ),
                          ))
                      .toList(),
                ),
              ]),
            ),
            const SizedBox(height: 22),

            // ── Quick stats ───────────────────────────────────────
            Row(children: [
              _StatCard(
                emoji: '✅',
                label: 'Completed',
                value: '${past.length}',
                accent: AppColors.mintGreen,
              ),
              const SizedBox(width: 12),
              _StatCard(
                emoji: '📅',
                label: 'Upcoming',
                value: '${active.length}',
                accent: AppColors.skyBlue,
              ),
              const SizedBox(width: 12),
              _StatCard(
                emoji: '⭐',
                label: 'Rating',
                value: '4.9',
                accent: AppColors.mustardYellow,
              ),
            ]),
            const SizedBox(height: 22),

            // ── Session history ───────────────────────────────────
            Text('Session History 📋',
                style: AppTextStyles.cardTitle.copyWith(fontSize: 16)),
            const SizedBox(height: 12),

            if (past.isEmpty)
              Container(
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
                child: const Center(
                    child: Text('📚', style: TextStyle(fontSize: 36))),
              )
            else
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05), blurRadius: 12)
                  ],
                ),
                child: Column(
                  children: past.asMap().entries.map((e) {
                    final s = e.value;
                    final isLast = e.key == past.length - 1;
                    final accent = AppColors.cardAccents[
                        e.key % AppColors.cardAccents.length];
                    return Column(children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        child: Row(children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                                color: accent, shape: BoxShape.circle),
                            child: Center(
                              child: Text(s.tutorAvatarEmoji,
                                  style: const TextStyle(fontSize: 20)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(s.studentName,
                                      style: AppTextStyles.cardTitle
                                          .copyWith(fontSize: 14)),
                                  Text(s.subject,
                                      style: AppTextStyles.bodyMuted
                                          .copyWith(fontSize: 12)),
                                  Text('${s.date}  •  ${s.timeSlot}',
                                      style: AppTextStyles.bodyMuted
                                          .copyWith(fontSize: 11)),
                                ]),
                          ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Rp ${s.ratePerHour.toStringAsFixed(0)}',
                                  style: AppTextStyles.priceBadge
                                      .copyWith(fontSize: 16),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD0F5F3),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Text('✓ Paid',
                                      style: AppTextStyles.chip.copyWith(
                                          color: const Color(0xFF006B63),
                                          fontSize: 10)),
                                ),
                              ]),
                        ]),
                      ),
                      if (!isLast)
                        Divider(
                            height: 1,
                            color: Colors.grey.shade100,
                            indent: 72),
                    ]);
                  }).toList(),
                ),
              ),
            const SizedBox(height: 22),

            // ── Payout button ─────────────────────────────────────
            GestureDetector(
              onTap: () {},
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 17),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.mustardYellow, AppColors.brightOrange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.mustardYellow.withOpacity(0.45),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '🏦  Request Payout',
                    style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

// ─── Sub-widgets & data ───────────────────────────────────────────────────────

class _MonthIncome {
  final String month;
  final double amount;
  const _MonthIncome({required this.month, required this.amount});
}

class _HeroStat extends StatelessWidget {
  final String label, value, icon;
  const _HeroStat(
      {required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 2),
          Text(value,
              style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  color: Colors.white)),
          Text(label,
              style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                  color: Colors.white.withOpacity(0.75))),
        ],
      );
}

class _StatCard extends StatelessWidget {
  final String emoji, label, value;
  final Color accent;
  const _StatCard(
      {required this.emoji,
      required this.label,
      required this.value,
      required this.accent});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: accent.withOpacity(0.2),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 4),
            Text(value,
                style: AppTextStyles.cardTitle.copyWith(fontSize: 18)),
            Text(label, style: AppTextStyles.bodyMuted.copyWith(fontSize: 10)),
          ]),
        ),
      );
}
