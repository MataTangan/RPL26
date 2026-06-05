import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../pages/tutor/dashboard_page.dart';
import '../pages/tutor/schedule_page.dart';
import '../pages/tutor/requests_page.dart';
import '../pages/tutor/income_page.dart';
import '../pages/tutor/chat_page.dart';
import '../pages/tutor/profile_setup_page.dart';
import '../theme.dart';

class _NavItem {
  final String icon, label;
  const _NavItem({required this.icon, required this.label});
}

class TutorNav extends StatefulWidget {
  const TutorNav({super.key});

  @override
  State<TutorNav> createState() => _TutorNavState();
}

class _TutorNavState extends State<TutorNav> {
  int _index = 0;

  static const _items = [
    _NavItem(icon: '📊', label: 'Dashboard'),
    _NavItem(icon: '🗓️', label: 'Schedule'),
    _NavItem(icon: '📥', label: 'Requests'),
    _NavItem(icon: '💰', label: 'Income'),
    _NavItem(icon: '💬', label: 'Chat'),
    _NavItem(icon: '👤', label: 'Profile'),
  ];

  static const _screens = [
    TutorDashboardPage(),
    TutorSchedulePage(),
    TutorRequestsPage(),
    TutorIncomePage(),
    TutorChatPage(),
    TutorProfileSetupPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: Container(
        color: AppColors.background,
        padding: const EdgeInsets.fromLTRB(12, 6, 12, 20),
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
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
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
                        vertical: 7, horizontal: 2),
                    decoration: BoxDecoration(
                      color: active
                          ? accent.withOpacity(0.18)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(item.icon,
                            style:
                                TextStyle(fontSize: active ? 21 : 19)),
                        const SizedBox(height: 2),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: GoogleFonts.nunito(
                            fontWeight: active
                                ? FontWeight.w800
                                : FontWeight.w600,
                            fontSize: 9,
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
