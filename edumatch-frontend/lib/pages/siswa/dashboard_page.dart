import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

/// Placeholder Siswa dashboard — shown after a successful student login.
///
/// Uses the mustard / orange Joyful UI palette with Bento Box cards.
class SiswaDashboardPage extends StatelessWidget {
  const SiswaDashboardPage({super.key});

  // ── Palette ────────────────────────────────────────────────────────────
  static const _mustard = Color(0xFFF6D365);
  static const _orange = Color(0xFFFDA085);
  static const _dark = Color(0xFF2D3436);
  static const _grey = Color(0xFF636E72);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF8E7), Color(0xFFFFFDF5)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // ── Header ───────────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Halo, Siswa! 👋',
                            style: GoogleFonts.nunito(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: _dark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Siap belajar hari ini?',
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: _grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Logout button
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () =>
                            context.read<AuthProvider>().logout(),
                        tooltip: 'Keluar',
                        icon: const Icon(
                          Icons.logout_rounded,
                          color: Color(0xFFE17055),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // ── Bento grid ───────────────────────────────────────
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.0,
                    children: [
                      _BentoCard(
                        emoji: '🔍',
                        title: 'Cari Tutor',
                        gradient: const [_mustard, _orange],
                      ),
                      _BentoCard(
                        emoji: '📅',
                        title: 'Jadwal Saya',
                        gradient: const [Color(0xFFA29BFE), Color(0xFF6C5CE7)],
                      ),
                      _BentoCard(
                        emoji: '💬',
                        title: 'Pesan',
                        gradient: const [Color(0xFF96E6A1), Color(0xFF48C6A9)],
                      ),
                      _BentoCard(
                        emoji: '⭐',
                        title: 'Nilai & Review',
                        gradient: const [Color(0xFFFDCB6E), Color(0xFFE17055)],
                      ),
                    ],
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

// ─────────────────────────────────────────────────────────────────────────────
// Shared Bento Card widget
// ─────────────────────────────────────────────────────────────────────────────

class _BentoCard extends StatelessWidget {
  final String emoji;
  final String title;
  final List<Color> gradient;

  const _BentoCard({
    required this.emoji,
    required this.title,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
        boxShadow: [
          BoxShadow(
            color: gradient.last.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 36)),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
