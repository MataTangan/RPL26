import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../pages/siswa/search_page.dart';
import '../pages/siswa/booking_history_page.dart';
import '../pages/siswa/chat_page.dart';
import '../screens/profile_screen.dart';
import '../services/mock_data.dart';
import '../theme.dart';


// ─── Chat contacts list ───────────────────────────────────────────────────────
class _SiswaChatContactsPage extends StatelessWidget {
  const _SiswaChatContactsPage();

  static const _accentEmojis = ['🌟', '📚', '🎓', '🔬', '🎵', '💻'];

  @override
  Widget build(BuildContext context) {
    final tutors = MockData.tutors;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Messages 💬', style: AppTextStyles.displayBold),
                const SizedBox(height: 4),
                Text('Chat with your tutors', style: AppTextStyles.appBarSub),
              ]),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: tutors.length,
                itemBuilder: (ctx, i) {
                  final tutor = tutors[i];
                  final accent =
                      AppColors.cardAccents[i % AppColors.cardAccents.length];
                  final emoji = _accentEmojis[i % _accentEmojis.length];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        ctx,
                        MaterialPageRoute(
                          builder: (_) => SiswaChatPage(
                            tutorName: tutor.name,
                            tutorEmoji: tutor.avatarEmoji.isNotEmpty
                                ? tutor.avatarEmoji
                                : emoji,
                            accent: accent,
                          ),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: accent.withValues(alpha: 0.15),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: accent,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                tutor.avatarEmoji.isNotEmpty
                                    ? tutor.avatarEmoji
                                    : emoji,
                                style: const TextStyle(fontSize: 22),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(tutor.name,
                                    style: AppTextStyles.cardTitle
                                        .copyWith(fontSize: 15)),
                                const SizedBox(height: 3),
                                Text(
                                  tutor.subjects.join(' · '),
                                  style:
                                      AppTextStyles.bodyMuted.copyWith(fontSize: 12),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.chevron_right_rounded,
                              color: Colors.grey.shade400),
                        ]),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
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

  Widget _screen(int i) {
    switch (i) {
      case 0:
        return const SiswaSearchPage();
      case 1:
        return const SiswaBookingHistoryPage();
      case 2:
        return const _SiswaChatContactsPage();
      case 3:
        return const ProfileScreen();
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
                color: Colors.black.withValues(alpha: 0.09),
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
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    decoration: BoxDecoration(
                      color: active
                          ? accent.withValues(alpha: 0.18)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(item.icon,
                            style: TextStyle(fontSize: active ? 22 : 20)),
                        const SizedBox(height: 3),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: GoogleFonts.nunito(
                            fontWeight:
                                active ? FontWeight.w800 : FontWeight.w600,
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
