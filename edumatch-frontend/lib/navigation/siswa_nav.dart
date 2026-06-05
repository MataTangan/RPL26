import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../pages/siswa/search_page.dart';
import '../pages/siswa/booking_history_page.dart';
import '../pages/siswa/chat_page.dart';
import '../theme.dart';

// ─── Stub profile page for Siswa ─────────────────────────────────────────────
class _SiswaProfilePage extends StatelessWidget {
  const _SiswaProfilePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              // Avatar
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.mustardYellow, AppColors.brightOrange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.mustardYellow.withOpacity(0.45),
                      blurRadius: 22,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Center(
                    child: Text('👨‍🎓', style: TextStyle(fontSize: 46))),
              ),
              const SizedBox(height: 14),
              Text('Rizky Maulana',
                  style: AppTextStyles.displayBold.copyWith(fontSize: 22)),
              const SizedBox(height: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
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
              const SizedBox(height: 28),
              // Stat row
              Row(children: [
                _Stat(emoji: '📅', value: '2', label: 'Upcoming'),
                const SizedBox(width: 10),
                _Stat(emoji: '✅', value: '2', label: 'Completed'),
                const SizedBox(width: 10),
                _Stat(emoji: '🎓', value: '6', label: 'Tutors'),
              ]),
              const SizedBox(height: 28),
              // Settings
              Align(
                alignment: Alignment.centerLeft,
                child: Text('⚙️  Settings',
                    style: AppTextStyles.cardTitle.copyWith(fontSize: 16)),
              ),
              const SizedBox(height: 12),
              ...[
                ('👤', 'Edit Profile', AppColors.mustardYellow),
                ('🔔', 'Notifications', AppColors.mintGreen),
                ('🔒', 'Privacy & Security', AppColors.pastelPurple),
                ('💳', 'Payment Methods', AppColors.skyBlue),
                ('❓', 'Help & Support', AppColors.brightOrange),
                ('🚪', 'Logout', const Color(0xFFFF8888)),
              ].map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10)
                        ],
                      ),
                      child: Row(children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: item.$3.withOpacity(0.15),
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
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String emoji, value, label;
  const _Stat(
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
                  color: Colors.black.withOpacity(0.05), blurRadius: 10)
            ],
          ),
          child: Column(children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 4),
            Text(value,
                style: AppTextStyles.cardTitle.copyWith(fontSize: 20)),
            Text(label, style: AppTextStyles.bodyMuted),
          ]),
        ),
      );
}

// ─── Nav items ────────────────────────────────────────────────────────────────
class _NavItem {
  final String icon, label;
  const _NavItem({required this.icon, required this.label});
}

// ─── SiswaNav ─────────────────────────────────────────────────────────────────
class SiswaNav extends StatefulWidget {
  const SiswaNav({super.key});

  @override
  State<SiswaNav> createState() => _SiswaNavState();
}

class _SiswaNavState extends State<SiswaNav> {
  int _index = 0;

  static const _items = [
    _NavItem(icon: '🔍', label: 'Cari Tutor'),
    _NavItem(icon: '📅', label: 'Sesi'),
    _NavItem(icon: '💬', label: 'Chat'),
    _NavItem(icon: '👤', label: 'Profil'),
  ];

  // Chat page requires a specific tutor context.
  // For the nav-level chat, we open a default chat with the first tutor.
  Widget _chatPage() => const SiswaChatPage(
        tutorName: 'Aisha Rahma',
        tutorEmoji: '🌟',
        accent: AppColors.mintGreen,
      );

  Widget _screen(int i) {
    switch (i) {
      case 0:
        return const SiswaSearchPage();
      case 1:
        return const SiswaBookingHistoryPage();
      case 2:
        return _chatPage();
      case 3:
        return const _SiswaProfilePage();
      default:
        return const SiswaSearchPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // Use a stack so the body fills behind the floating nav
      body: IndexedStack(
        index: _index,
        children: List.generate(4, _screen),
      ),
      bottomNavigationBar: Container(
        color: AppColors.background,
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.09),
                blurRadius: 28,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: List.generate(_items.length, (i) {
              final item = _items[i];
              final active = i == _index;
              final accent =
                  AppColors.cardAccents[i % AppColors.cardAccents.length];
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _index = i),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    padding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 4),
                    decoration: BoxDecoration(
                      color: active
                          ? accent.withOpacity(0.18)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(item.icon,
                            style:
                                TextStyle(fontSize: active ? 22 : 20)),
                        const SizedBox(height: 3),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: GoogleFonts.nunito(
                            fontWeight: active
                                ? FontWeight.w800
                                : FontWeight.w600,
                            fontSize: 10,
                            color: active
                                ? AppColors.deepBlue
                                : const Color(0xFFAAAAAA),
                          ),
                          child: Text(item.label),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
