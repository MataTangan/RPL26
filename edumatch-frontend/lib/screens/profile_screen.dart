import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/mock_data.dart';
import '../models/booking_session.dart';
import '../theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final upcoming =
        MockData.sessions.where((s) => s.status == SessionStatus.active).length;
    final completed =
        MockData.sessions.where((s) => s.status == SessionStatus.past).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            // Avatar + name
            Center(
                child: Column(children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.pastelPurple, AppColors.skyBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.pastelPurple.withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8))
                  ],
                ),
                child: const Center(
                    child: Text('👤', style: TextStyle(fontSize: 44))),
              ),
              const SizedBox(height: 14),
              Text('Rizky Maulana',
                  style: AppTextStyles.displayBold.copyWith(fontSize: 22)),
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.deepBlue,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text('Student  🎓',
                    style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: Colors.white)),
              ),
            ])),
            const SizedBox(height: 24),

            // Stats row
            Row(children: [
              _ProfileStat(emoji: '📅', value: '$upcoming', label: 'Upcoming'),
              const SizedBox(width: 10),
              _ProfileStat(emoji: '✅', value: '$completed', label: 'Completed'),
              const SizedBox(width: 10),
              _ProfileStat(
                  emoji: '🎓',
                  value: '${MockData.tutors.length}',
                  label: 'Tutors'),
            ]),
            const SizedBox(height: 24),

            // Settings section
            Align(
                alignment: Alignment.centerLeft,
                child: Text('⚙️  Settings',
                    style: AppTextStyles.cardTitle.copyWith(fontSize: 16))),
            const SizedBox(height: 10),

            ...[
              ('👤', 'Edit Profile', AppColors.mustardYellow),
              ('🔔', 'Notifications', AppColors.mintGreen),
              ('🔒', 'Privacy & Security', AppColors.pastelPurple),
              ('💳', 'Payment Methods', AppColors.skyBlue),
              ('❓', 'Help & Support', AppColors.brightOrange),
              ('🚪', 'Logout', const Color(0xFFFF8888)),
            ].map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10)
                      ],
                    ),
                    child: Row(children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: item.$3.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                            child: Text(item.$1,
                                style: const TextStyle(fontSize: 18))),
                      ),
                      const SizedBox(width: 14),
                      Text(item.$2,
                          style:
                              AppTextStyles.cardTitle.copyWith(fontSize: 15)),
                      const Spacer(),
                      Icon(Icons.chevron_right_rounded,
                          color: Colors.grey.shade400),
                    ]),
                  ),
                ),
              );
            }),
          ]),
        ),
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String emoji, value, label;
  const _ProfileStat(
      {required this.emoji, required this.value, required this.label});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)
            ],
          ),
          child: Column(children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 4),
            Text(value, style: AppTextStyles.cardTitle.copyWith(fontSize: 20)),
            Text(label, style: AppTextStyles.bodyMuted),
          ]),
        ),
      );
}
