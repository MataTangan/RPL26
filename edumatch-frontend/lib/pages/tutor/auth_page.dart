import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../theme.dart';
import '../../providers/auth_provider.dart';
import '../../navigation/tutor_nav.dart';

class TutorAuthPage extends StatefulWidget {
  const TutorAuthPage({super.key});

  @override
  State<TutorAuthPage> createState() => _TutorAuthPageState();
}

class _TutorAuthPageState extends State<TutorAuthPage>
    with SingleTickerProviderStateMixin {
  // 0 = Login, 1 = Register Step 1 (credentials), 2 = Register Step 2 (documents)
  int _step = 0;
  bool _obscure = true;
  bool _loading = false;
  String? _uploadedDoc;

  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350));
    _fadeAnim =
        CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _goToStep(int step) {
    _animCtrl.reset();
    setState(() => _step = step);
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
    final phone = _phoneCtrl.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showErrorSnackBar('Email dan password wajib diisi.');
      return;
    }
    // Email format validation: must contain '@' and a valid domain
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(email)) {
      _showErrorSnackBar('Format email tidak valid');
      return;
    }

    // For login (step 0): just need email + password.
    // For register (steps 1-2): also need name.
    if (_step != 0 && name.isEmpty) {
      _showErrorSnackBar('Nama lengkap wajib diisi.');
      return;
    }

    setState(() => _loading = true);
    try {
      final auth = context.read<AuthProvider>();
      if (_step == 0) {
        await auth.loginTutor(email: email, password: password);
      } else {
        await auth.registerTutor(
          name: name,
          email: email,
          password: password,
          phone: phone,
        );
      }
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const TutorNav()),
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

  Future<void> _mockUpload() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() {
      _loading = false;
      _uploadedDoc = 'KTP_Tutor_Document.pdf';
    });
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
              const SizedBox(height: 36),

              // ── Logo ─────────────────────────────────────────
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.mintGreen, AppColors.skyBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.mintGreen.withOpacity(0.45),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Center(
                    child: Text('👩‍🏫', style: TextStyle(fontSize: 42))),
              ),
              const SizedBox(height: 18),
              Text('Tutor Portal', style: AppTextStyles.displayBold),
              const SizedBox(height: 6),
              Text('Share your knowledge, change lives 🌟',
                  style: AppTextStyles.appBarSub,
                  textAlign: TextAlign.center),
              const SizedBox(height: 32),

              // ── Step indicator (only for register) ───────────
              if (_step > 0) ...[
                _StepIndicator(step: _step),
                const SizedBox(height: 24),
              ],

              // ── Mode toggle (Login vs Register) ───────────────
              if (_step == 0 || _step == 1) ...[
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
                      active: _step == 0,
                      onTap: () => _goToStep(0),
                      activeColor: AppColors.deepBlue,
                    ),
                    _ToggleTab(
                      label: 'Register',
                      active: _step == 1,
                      onTap: () => _goToStep(1),
                      activeColor: AppColors.mintGreen,
                    ),
                  ]),
                ),
                const SizedBox(height: 28),
              ],

              FadeTransition(
                opacity: _fadeAnim,
                child: _buildStepContent(),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_step) {
      case 0:
        return _buildLogin();
      case 1:
        return _buildRegisterStep1();
      case 2:
        return _buildRegisterStep2();
      default:
        return _buildLogin();
    }
  }

  Widget _buildLogin() {
    return Column(children: [
      _PillField(
        controller: _emailCtrl,
        hint: 'Email address',
        icon: Icons.email_outlined,
        accent: AppColors.mintGreen,
        keyboardType: TextInputType.emailAddress,
      ),
      const SizedBox(height: 14),
      _PillField(
        controller: _passCtrl,
        hint: 'Password',
        icon: Icons.lock_outline_rounded,
        accent: AppColors.skyBlue,
        obscure: _obscure,
        suffixIcon: IconButton(
          icon: Icon(
            _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: Colors.grey.shade400,
            size: 20,
          ),
          onPressed: () => setState(() => _obscure = !_obscure),
        ),
      ),
      const SizedBox(height: 26),
      _PrimaryButton(
        label: '🚀  Login',
        color: AppColors.deepBlue,
        loading: _loading,
        onTap: _submit,
      ),
      const SizedBox(height: 14),
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
    ]);
  }

  Widget _buildRegisterStep1() {
    return Column(children: [
      _PillField(
        controller: _nameCtrl,
        hint: 'Full name',
        icon: Icons.person_outline_rounded,
        accent: AppColors.mustardYellow,
      ),
      const SizedBox(height: 14),
      _PillField(
        controller: _emailCtrl,
        hint: 'Email address',
        icon: Icons.email_outlined,
        accent: AppColors.mintGreen,
        keyboardType: TextInputType.emailAddress,
      ),
      const SizedBox(height: 14),
      _PillField(
        controller: _phoneCtrl,
        hint: 'Phone number',
        icon: Icons.phone_outlined,
        accent: AppColors.brightOrange,
        keyboardType: TextInputType.phone,
      ),
      const SizedBox(height: 14),
      _PillField(
        controller: _passCtrl,
        hint: 'Create password',
        icon: Icons.lock_outline_rounded,
        accent: AppColors.skyBlue,
        obscure: _obscure,
        suffixIcon: IconButton(
          icon: Icon(
            _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: Colors.grey.shade400,
            size: 20,
          ),
          onPressed: () => setState(() => _obscure = !_obscure),
        ),
      ),
      const SizedBox(height: 26),
      _PrimaryButton(
        label: 'Next: Upload Documents →',
        color: AppColors.mintGreen,
        loading: false,
        onTap: () => _goToStep(2),
      ),
    ]);
  }

  Widget _buildRegisterStep2() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Back button
      GestureDetector(
        onTap: () => _goToStep(1),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.arrow_back_ios_new_rounded,
              size: 14, color: AppColors.deepBlue.withOpacity(0.6)),
          const SizedBox(width: 4),
          Text('Back',
              style: AppTextStyles.bodyMuted
                  .copyWith(color: AppColors.deepBlue.withOpacity(0.6))),
        ]),
      ),
      const SizedBox(height: 20),

      Text('Upload Verification Documents',
          style: AppTextStyles.cardTitle.copyWith(fontSize: 17)),
      const SizedBox(height: 6),
      Text(
        'We need to verify your identity and teaching credentials. '
        'Accepted: KTP, teaching certificate, or degree certificate.',
        style: AppTextStyles.bodyMuted.copyWith(fontSize: 13, height: 1.5),
      ),
      const SizedBox(height: 22),

      // Upload cards
      _UploadCard(
        emoji: '🪪',
        title: 'Identity Card (KTP)',
        subtitle: 'JPG, PNG or PDF – max 5 MB',
        accent: AppColors.mustardYellow,
        uploaded: _uploadedDoc,
        loading: _loading,
        onTap: _mockUpload,
      ),
      const SizedBox(height: 14),
      _UploadCard(
        emoji: '🎓',
        title: 'Teaching Certificate',
        subtitle: 'Optional but recommended',
        accent: AppColors.mintGreen,
        uploaded: null,
        loading: false,
        onTap: () {},
      ),
      const SizedBox(height: 14),
      _UploadCard(
        emoji: '📄',
        title: 'Degree / Diploma',
        subtitle: 'Optional',
        accent: AppColors.skyBlue,
        uploaded: null,
        loading: false,
        onTap: () {},
      ),
      const SizedBox(height: 28),

      // Info chip
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.mustardYellow.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: AppColors.mustardYellow.withOpacity(0.35), width: 1.5),
        ),
        child: Row(children: [
          const Text('ℹ️', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Your documents are reviewed within 1–2 business days. '
              'You will receive an email once verified.',
              style:
                  AppTextStyles.bodyMuted.copyWith(fontSize: 12, height: 1.5),
            ),
          ),
        ]),
      ),
      const SizedBox(height: 26),

      _PrimaryButton(
        label: '✅  Submit & Register',
        color: AppColors.mintGreen,
        loading: _loading,
        onTap: _submit,
      ),
    ]);
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

class _StepIndicator extends StatelessWidget {
  final int step;
  const _StepIndicator({required this.step});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      _Dot(active: step >= 1, label: '1  Credentials', accent: AppColors.mintGreen),
      _Line(active: step >= 2),
      _Dot(active: step >= 2, label: '2  Documents', accent: AppColors.skyBlue),
    ]);
  }
}

class _Dot extends StatelessWidget {
  final bool active;
  final String label;
  final Color accent;
  const _Dot({required this.active, required this.label, required this.accent});

  @override
  Widget build(BuildContext context) => Column(children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: active ? accent : Colors.grey.shade200,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              active ? Icons.check_rounded : Icons.circle_outlined,
              size: 16,
              color: active ? Colors.white : Colors.grey.shade400,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(label,
            style: AppTextStyles.bodyMuted.copyWith(
              fontSize: 10,
              color: active ? AppColors.deepBlue : Colors.grey.shade400,
            )),
      ]);
}

class _Line extends StatelessWidget {
  final bool active;
  const _Line({required this.active});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 60,
          height: 2,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: active ? AppColors.mintGreen : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
}

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

class _PrimaryButton extends StatelessWidget {
  final String label;
  final Color color;
  final bool loading;
  final VoidCallback? onTap;
  const _PrimaryButton({
    required this.label,
    required this.color,
    required this.loading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: loading ? null : onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 17),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: loading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2.5),
                  )
                : Text(label,
                    style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        color: Colors.white)),
          ),
        ),
      );
}

class _UploadCard extends StatelessWidget {
  final String emoji, title, subtitle;
  final Color accent;
  final String? uploaded;
  final bool loading;
  final VoidCallback onTap;
  const _UploadCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.uploaded,
    required this.loading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final done = uploaded != null;
    return GestureDetector(
      onTap: done ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: done ? accent.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: done ? accent : Colors.grey.shade200,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: done
                  ? accent.withOpacity(0.15)
                  : Colors.black.withOpacity(0.04),
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
              color: accent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 22))),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title,
                  style: AppTextStyles.cardTitle.copyWith(fontSize: 14)),
              const SizedBox(height: 2),
              Text(
                done ? '✓  ${uploaded!}' : subtitle,
                style: AppTextStyles.bodyMuted.copyWith(
                  fontSize: 12,
                  color: done ? const Color(0xFF006B63) : null,
                ),
              ),
            ]),
          ),
          loading
              ? SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                      color: accent, strokeWidth: 2.5),
                )
              : done
                  ? Icon(Icons.check_circle_rounded,
                      color: AppColors.mintGreen, size: 24)
                  : Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: accent.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text('Upload',
                          style: AppTextStyles.chip
                              .copyWith(color: AppColors.deepBlue, fontSize: 12)),
                    ),
        ]),
      ),
    );
  }
}
