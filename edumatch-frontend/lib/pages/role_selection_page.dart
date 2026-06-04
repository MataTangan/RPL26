import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'siswa/auth_page.dart';
import 'tutor/auth_page.dart';

/// Full‑screen role‑selection page shown to unauthenticated users.
///
/// Two vibrant "Bento Box" cards let the user choose between
/// **Siswa** (student) and **Tutor** roles before proceeding to login.
class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFF8E7), Color(0xFFF0FFF4)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Column(
              children: [
                const SizedBox(height: 40),

                // ── Title ────────────────────────────────────────────
                Text(
                  '👋 Selamat Datang!',
                  style: GoogleFonts.nunito(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF2D3436),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Kamu mau masuk sebagai apa?',
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF636E72),
                  ),
                ),

                const SizedBox(height: 48),

                // ── Bento Cards ──────────────────────────────────────
                Expanded(
                  child: Column(
                    children: [
                      // Siswa card
                      Expanded(
                        child: _BentoRoleCard(
                          emoji: '📚',
                          title: 'Saya Siswa',
                          subtitle: 'Cari tutor terbaik buat kamu!',
                          gradientColors: const [
                            Color(0xFFF6D365), // mustard
                            Color(0xFFFDA085), // bright orange
                          ],
                          onTap: () => Navigator.push(
                            context,
                            _joyfulRoute(const SiswaAuthPage()),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Tutor card
                      Expanded(
                        child: _BentoRoleCard(
                          emoji: '🎓',
                          title: 'Saya Tutor',
                          subtitle: 'Bantu siswa meraih mimpi!',
                          gradientColors: const [
                            Color(0xFF96E6A1), // mint green
                            Color(0xFF48C6A9), // teal
                          ],
                          onTap: () => Navigator.push(
                            context,
                            _joyfulRoute(const TutorAuthPage()),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // ── Footer ───────────────────────────────────────────
                Text(
                  'EduMatch ✨',
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFB2BEC3),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Smooth slide‑up page transition that fits the Joyful UI feel.
  static Route _joyfulRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(begin: const Offset(0, 0.15), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeOutCubic));
        return SlideTransition(
          position: animation.drive(tween),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bento Box Role Card
// ─────────────────────────────────────────────────────────────────────────────

class _BentoRoleCard extends StatefulWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  const _BentoRoleCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
    required this.onTap,
  });

  @override
  State<_BentoRoleCard> createState() => _BentoRoleCardState();
}

class _BentoRoleCardState extends State<_BentoRoleCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.gradientColors,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.gradientColors.last.withOpacity(0.35),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.emoji, style: const TextStyle(fontSize: 48)),
                const SizedBox(height: 16),
                Text(
                  widget.title,
                  style: GoogleFonts.nunito(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.subtitle,
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
