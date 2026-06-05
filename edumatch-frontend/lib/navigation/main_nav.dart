import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/home_screen.dart';
import '../screens/bookings_screen.dart';
import '../screens/tutor_dashboard_screen.dart';
import '../screens/request_inbox_screen.dart';
import '../screens/profile_screen.dart';
import '../theme.dart';

class MainNav extends StatefulWidget {
  const MainNav({super.key});

  @override
  State<MainNav> createState() => _MainNavState();
}

class _MainNavState extends State<MainNav> {
  int _index = 0;

  static const _screens = [
    HomeScreen(),
    BookingsScreen(),
    TutorDashboardScreen(),
    RequestInboxScreen(),
    ProfileScreen(),
  ];

  static const _items = [
    _NavItem(icon: '🔍', label: 'Discover'),
    _NavItem(icon: '📅', label: 'Bookings'),
    _NavItem(icon: '📊', label: 'Dashboard'),
    _NavItem(icon: '📥', label: 'Inbox'),
    _NavItem(icon: '👤', label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: Container(
        color: AppColors.background,
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 24,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: List.generate(_items.length, (i) {
              final item = _items[i];
              final active = i == _index;
              final accent = AppColors.cardAccents[i % AppColors.cardAccents.length];
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _index = i),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    decoration: BoxDecoration(
                      color: active ? accent.withOpacity(0.18) : Colors.transparent,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(item.icon,
                            style: TextStyle(
                              fontSize: active ? 22 : 20,
                            )),
                        const SizedBox(height: 3),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: GoogleFonts.nunito(
                            fontWeight:
                                active ? FontWeight.w800 : FontWeight.w600,
                            fontSize: 10,
                            color: active ? AppColors.deepBlue : const Color(0xFFAAAAAA),
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

class _NavItem {
  final String icon, label;
  const _NavItem({required this.icon, required this.label});
}
