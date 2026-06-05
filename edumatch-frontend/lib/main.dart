import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'navigation/siswa_nav.dart';
import 'navigation/tutor_nav.dart';
import 'pages/siswa/auth_page.dart';
import 'pages/tutor/auth_page.dart';
import 'providers/auth_provider.dart';
import 'theme.dart';

void main() => runApp(
      ChangeNotifierProvider(
        create: (_) => AuthProvider(),
        child: const EduMatchApp(),
      ),
    );

class EduMatchApp extends StatelessWidget {
  const EduMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduMatch',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const RoleSelectionScreen(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Role Selection Screen
// ─────────────────────────────────────────────────────────────────────────────

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _goSiswa(BuildContext context) {
    // Show auth first, then navigate to SiswaNav on pop
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const _SiswaEntryFlow()),
    );
  }

  void _goTutor(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const _TutorEntryFlow()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fade,
          child: SlideTransition(
            position: _slide,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // ── Logo ─────────────────────────────────────────
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.mustardYellow,
                          AppColors.brightOrange
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.mustardYellow.withOpacity(0.5),
                          blurRadius: 30,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text('🎓', style: TextStyle(fontSize: 48)),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text('EduMatch', style: AppTextStyles.displayBold.copyWith(fontSize: 32)),
                  const SizedBox(height: 8),
                  Text(
                    'Connect. Learn. Grow. ✨',
                    style: AppTextStyles.appBarSub.copyWith(fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(flex: 2),

                  // ── Role prompt ───────────────────────────────────
                  Text(
                    'I am a…',
                    style: AppTextStyles.cardTitle.copyWith(fontSize: 17),
                  ),
                  const SizedBox(height: 20),

                  // ── Siswa card ────────────────────────────────────
                  _RoleCard(
                    emoji: '👨‍🎓',
                    title: 'Siswa',
                    subtitle: 'Find & book the perfect tutor for me',
                    gradient: const [
                      AppColors.mustardYellow,
                      AppColors.brightOrange
                    ],
                    shadow: AppColors.mustardYellow,
                    onTap: () => _goSiswa(context),
                  ),
                  const SizedBox(height: 16),

                  // ── Tutor card ────────────────────────────────────
                  _RoleCard(
                    emoji: '👩‍🏫',
                    title: 'Tutor',
                    subtitle: 'Teach students & manage my sessions',
                    gradient: const [
                      AppColors.mintGreen,
                      AppColors.skyBlue
                    ],
                    shadow: AppColors.mintGreen,
                    onTap: () => _goTutor(context),
                  ),
                  const Spacer(flex: 2),

                  // ── Footer ────────────────────────────────────────
                  Text(
                    'EduMatch v1.0  ·  All rights reserved 2026',
                    style: AppTextStyles.bodyMuted.copyWith(fontSize: 11),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Role card ────────────────────────────────────────────────────────────────

class _RoleCard extends StatefulWidget {
  final String emoji, title, subtitle;
  final List<Color> gradient;
  final Color shadow;
  final VoidCallback onTap;
  const _RoleCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.shadow,
    required this.onTap,
  });

  @override
  State<_RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<_RoleCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                widget.gradient[0].withOpacity(0.15),
                widget.gradient[1].withOpacity(0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
                color: widget.gradient[0].withOpacity(0.35), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: widget.shadow.withOpacity(0.18),
                blurRadius: 22,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: widget.shadow.withOpacity(0.4),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: Text(widget.emoji, style: const TextStyle(fontSize: 32)),
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title,
                      style: AppTextStyles.cardTitle.copyWith(fontSize: 19)),
                  const SizedBox(height: 4),
                  Text(widget.subtitle, style: AppTextStyles.bodyMuted),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                size: 16, color: widget.gradient[0]),
          ]),
        ),
      ),
    );
  }
}

// ─── Siswa entry flow ─────────────────────────────────────────────────────────
// Shows auth page, then replaces stack with SiswaNav on back/success.

class _SiswaEntryFlow extends StatelessWidget {
  const _SiswaEntryFlow();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(children: [
        const SiswaAuthPage(),
        // Floating "Skip / Continue as Guest" bar at the bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            color: AppColors.background,
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
            child: GestureDetector(
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const SiswaNav()),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 12),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Skip → Enter as Guest',
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: const Color(0xFF888899),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

// ─── Tutor entry flow ─────────────────────────────────────────────────────────
// Shows tutor auth page, then routes to TutorNav.

class _TutorEntryFlow extends StatelessWidget {
  const _TutorEntryFlow();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(children: [
        const TutorAuthPage(),
        // Floating skip bar
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            color: AppColors.background,
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
            child: GestureDetector(
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const TutorNav()),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 12),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Skip → Enter as Tutor Guest',
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: const Color(0xFF888899),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
