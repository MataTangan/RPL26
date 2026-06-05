import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../theme.dart';
import '../../providers/auth_provider.dart';
import '../../navigation/siswa_nav.dart';

class SiswaAuthPage extends StatefulWidget {
  const SiswaAuthPage({super.key});

  @override
  State<SiswaAuthPage> createState() => _SiswaAuthPageState();
}

class _SiswaAuthPageState extends State<SiswaAuthPage>
    with SingleTickerProviderStateMixin {
  bool _isLogin = true;
  bool _obscure = true;
  bool _loading = false;

  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();

  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  void _toggle(bool toLogin) {
    _animCtrl.reset();
    setState(() => _isLogin = toLogin);
    _animCtrl.forward();
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        backgroundColor: const Color(0xFFFF6B6B),
        content: Row(
          children: [
            const Text('⚠️', style: TextStyle(fontSize: 16)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  Future<void> _submit() async {
    final email = _emailCtrl.text.trim();
    final password = _passCtrl.text;
    final name = _nameCtrl.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showErrorSnackBar('Email dan password wajib diisi.');
      return;
    }
    if (!_isLogin && name.isEmpty) {
      _showErrorSnackBar('Nama lengkap wajib diisi.');
      return;
    }

    setState(() => _loading = true);
    try {
      final auth = context.read<AuthProvider>();
      if (_isLogin) {
        await auth.loginSiswa(email: email, password: password);
      } else {
        await auth.registerSiswa(name: name, email: email, password: password);
      }
      if (!mounted) return;
      // Navigate to the main Siswa app, replacing the auth flow
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const SiswaNav()),
        (route) => false,
      );
    } on AuthException catch (e) {
      if (!mounted) return;
      _showErrorSnackBar(e.message);
    } catch (_) {
      if (!mounted) return;
      _showErrorSnackBar('Tidak dapat terhubung ke server. Periksa koneksi Anda.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // ── Logo blob ──────────────────────────────────────
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.mustardYellow, AppColors.brightOrange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.mustardYellow.withOpacity(0.45),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text('🎓', style: TextStyle(fontSize: 42)),
                ),
              ),
              const SizedBox(height: 20),
              Text('EduMatch', style: AppTextStyles.displayBold),
              const SizedBox(height: 6),
              Text('Find the perfect tutor for you ✨',
                  style: AppTextStyles.appBarSub,
                  textAlign: TextAlign.center),
              const SizedBox(height: 36),

              // ── Toggle pill ────────────────────────────────────
              Container(
                height: 50,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(children: [
                  _ToggleTab(
                    label: 'Login',
                    active: _isLogin,
                    onTap: () => _toggle(true),
                    activeColor: AppColors.deepBlue,
                  ),
                  _ToggleTab(
                    label: 'Register',
                    active: !_isLogin,
                    onTap: () => _toggle(false),
                    activeColor: AppColors.mintGreen,
                  ),
                ]),
              ),
              const SizedBox(height: 32),

              // ── Form fields ────────────────────────────────────
              FadeTransition(
                opacity: _fadeAnim,
                child: Column(children: [
                  if (!_isLogin) ...[
                    _PillField(
                      controller: _nameCtrl,
                      hint: 'Your full name',
                      icon: Icons.person_outline_rounded,
                      accent: AppColors.mustardYellow,
                    ),
                    const SizedBox(height: 14),
                  ],
                  _PillField(
                    controller: _emailCtrl,
                    hint: 'Email address',
                    icon: Icons.email_outlined,
                    accent: AppColors.skyBlue,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 14),
                  _PillField(
                    controller: _passCtrl,
                    hint: 'Password',
                    icon: Icons.lock_outline_rounded,
                    accent: AppColors.pastelPurple,
                    obscure: _obscure,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.grey.shade400,
                        size: 20,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── Submit button ──────────────────────────────
                  GestureDetector(
                    onTap: _loading ? null : _submit,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 17),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: _isLogin
                              ? [AppColors.deepBlue, const Color(0xFF3949AB)]
                              : [AppColors.mintGreen, const Color(0xFF26A69A)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: (_isLogin
                                    ? AppColors.deepBlue
                                    : AppColors.mintGreen)
                                .withOpacity(0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Center(
                        child: _loading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2.5),
                              )
                            : Text(
                                _isLogin ? '🚀  Login' : '🌟  Create Account',
                                style: GoogleFonts.nunito(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),

                  if (_isLogin) ...[
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Forgot password?',
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: AppColors.deepBlue.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ],
                ]),
              ),

              const SizedBox(height: 32),

              // ── Divider ────────────────────────────────────────
              Row(children: [
                Expanded(child: Divider(color: Colors.grey.shade200)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('or continue with',
                      style: AppTextStyles.bodyMuted.copyWith(fontSize: 12)),
                ),
                Expanded(child: Divider(color: Colors.grey.shade200)),
              ]),
              const SizedBox(height: 20),

              // ── Social row ─────────────────────────────────────
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                _SocialBtn(emoji: '🔍', label: 'Google'),
                const SizedBox(width: 14),
                _SocialBtn(emoji: '📘', label: 'Facebook'),
              ]),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Sub-widgets ─────────────────────────────────────────────────────────────

class _ToggleTab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  final Color activeColor;
  const _ToggleTab(
      {required this.label,
      required this.active,
      required this.onTap,
      required this.activeColor});

  @override
  Widget build(BuildContext context) => Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: active ? activeColor : Colors.transparent,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: Text(
                label,
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  color: active ? Colors.white : const Color(0xFF888899),
                ),
              ),
            ),
          ),
        ),
      );
}

class _PillField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final Color accent;
  final bool obscure;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  const _PillField({
    required this.controller,
    required this.hint,
    required this.icon,
    required this.accent,
    this.obscure = false,
    this.suffixIcon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: accent.withOpacity(0.15),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          style: GoogleFonts.nunito(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: AppColors.deepBlue),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodyMuted,
            prefixIcon: Container(
              margin: const EdgeInsets.all(10),
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: accent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: accent, size: 18),
            ),
            suffixIcon: suffixIcon,
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
          ),
        ),
      );
}

class _SocialBtn extends StatelessWidget {
  final String emoji, label;
  const _SocialBtn({required this.emoji, required this.label});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(label,
                style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppColors.deepBlue)),
          ]),
        ),
      );
}
