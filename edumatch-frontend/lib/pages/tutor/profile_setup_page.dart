import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme.dart';

class TutorProfileSetupPage extends StatefulWidget {
  const TutorProfileSetupPage({super.key});

  @override
  State<TutorProfileSetupPage> createState() => _TutorProfileSetupPageState();
}

class _TutorProfileSetupPageState extends State<TutorProfileSetupPage> {
  final _bioCtrl = TextEditingController();
  final _rateCtrl = TextEditingController(text: '75');
  final _cityCtrl = TextEditingController(text: 'Jakarta');
  bool _saving = false;
  bool _saved = false;

  // Subject palette – each entry: (label, chipColorIndex)
  static const _allSubjects = [
    'Mathematics',
    'Physics',
    'Chemistry',
    'Biology',
    'English',
    'Indonesian',
    'History',
    'Programming',
    'Python',
    'Web Dev',
    'Music Theory',
    'Guitar',
    'Piano',
    'Calculus',
    'Statistics',
    'Economics',
    'Literature',
    'IELTS Prep',
  ];

  final Set<String> _selected = {'Mathematics', 'Physics'};

  Future<void> _save() async {
    setState(() => _saving = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() {
      _saving = false;
      _saved = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _saved = false);
  }

  @override
  void dispose() {
    _bioCtrl.dispose();
    _rateCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(children: [
          // ── Header ────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
            child: Row(children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Profile Setup ✏️', style: AppTextStyles.displayBold),
                  const SizedBox(height: 4),
                  Text('Tell students who you are',
                      style: AppTextStyles.appBarSub),
                ]),
              ),
              // Completion badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.mintGreen.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                      color: AppColors.mintGreen.withOpacity(0.4), width: 1.5),
                ),
                child: Text(
                  '${_selected.length} subject${_selected.length == 1 ? '' : 's'}',
                  style: AppTextStyles.chip
                      .copyWith(color: const Color(0xFF006B63), fontSize: 12),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 4),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                // ── Avatar section ─────────────────────────────
                _BentoCard(
                  accent: AppColors.mustardYellow,
                  child: Row(children: [
                    GestureDetector(
                      onTap: () {},
                      child: Stack(children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: AppColors.mustardYellow,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.mustardYellow.withOpacity(0.4),
                                blurRadius: 14,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text('👩‍🏫', style: TextStyle(fontSize: 32)),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: AppColors.deepBlue,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(Icons.edit_rounded,
                                size: 12, color: Colors.white),
                          ),
                        ),
                      ]),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Profile Photo', style: AppTextStyles.cardTitle.copyWith(fontSize: 15)),
                        const SizedBox(height: 4),
                        Text('Tap to change your avatar',
                            style: AppTextStyles.bodyMuted.copyWith(fontSize: 12)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.mustardYellow.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text('✦  Verified Tutor',
                              style: AppTextStyles.chip
                                  .copyWith(color: const Color(0xFF7A5C00))),
                        ),
                      ]),
                    ),
                  ]),
                ),
                const SizedBox(height: 14),

                // ── Basic info ─────────────────────────────────
                _BentoCard(
                  accent: AppColors.skyBlue,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _CardLabel(label: 'Location', emoji: '📍'),
                    const SizedBox(height: 10),
                    _InlineField(
                      controller: _cityCtrl,
                      hint: 'Your city',
                      accent: AppColors.skyBlue,
                    ),
                  ]),
                ),
                const SizedBox(height: 14),

                // ── Hourly rate ────────────────────────────────
                _BentoCard(
                  accent: AppColors.brightOrange,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _CardLabel(label: 'Hourly Rate', emoji: '💰'),
                    const SizedBox(height: 12),
                    Row(children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.brightOrange.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text('Rp',
                            style: AppTextStyles.priceBadge
                                .copyWith(color: AppColors.brightOrange)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _InlineField(
                          controller: _rateCtrl,
                          hint: '75',
                          accent: AppColors.brightOrange,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.brightOrange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text('/hr',
                            style: AppTextStyles.bodyMuted.copyWith(fontSize: 14)),
                      ),
                    ]),
                    const SizedBox(height: 10),
                    // Rate slider
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: AppColors.brightOrange,
                        inactiveTrackColor: AppColors.brightOrange.withOpacity(0.2),
                        thumbColor: AppColors.brightOrange,
                        overlayColor: AppColors.brightOrange.withOpacity(0.15),
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                        trackHeight: 4,
                      ),
                      child: Slider(
                        value: double.tryParse(_rateCtrl.text) ?? 75,
                        min: 30,
                        max: 250,
                        onChanged: (v) =>
                            setState(() => _rateCtrl.text = v.toStringAsFixed(0)),
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height: 14),

                // ── Subjects ───────────────────────────────────
                _BentoCard(
                  accent: AppColors.pastelPurple,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _CardLabel(label: 'Teaching Subjects', emoji: '📚'),
                    const SizedBox(height: 4),
                    Text('Tap to select / deselect',
                        style: AppTextStyles.bodyMuted.copyWith(fontSize: 11)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _allSubjects.asMap().entries.map((e) {
                        final subject = e.value;
                        final idx = e.key;
                        final sel = _selected.contains(subject);
                        final chipColor =
                            AppColors.chipColors[idx % AppColors.chipColors.length];
                        final chipText =
                            AppColors.chipTextColors[idx % AppColors.chipTextColors.length];
                        return GestureDetector(
                          onTap: () => setState(() {
                            sel ? _selected.remove(subject) : _selected.add(subject);
                          }),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(
                              color: sel ? AppColors.deepBlue : chipColor,
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: sel
                                  ? [
                                      BoxShadow(
                                        color: AppColors.deepBlue.withOpacity(0.25),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      )
                                    ]
                                  : [],
                            ),
                            child: Row(mainAxisSize: MainAxisSize.min, children: [
                              if (sel) ...[
                                const Icon(Icons.check_rounded,
                                    size: 12, color: Colors.white),
                                const SizedBox(width: 4),
                              ],
                              Text(
                                subject,
                                style: AppTextStyles.chip.copyWith(
                                  color: sel ? Colors.white : chipText,
                                  fontSize: 12,
                                ),
                              ),
                            ]),
                          ),
                        );
                      }).toList(),
                    ),
                  ]),
                ),
                const SizedBox(height: 14),

                // ── Bio ────────────────────────────────────────
                _BentoCard(
                  accent: AppColors.mintGreen,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _CardLabel(label: 'Bio / Introduction', emoji: '👤'),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: TextField(
                        controller: _bioCtrl,
                        maxLines: 5,
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppColors.deepBlue,
                          height: 1.6,
                        ),
                        decoration: InputDecoration(
                          hintText:
                              'Tell students about your teaching style, experience, and what makes you unique…',
                          hintStyle: AppTextStyles.bodyMuted
                              .copyWith(fontSize: 13, height: 1.5),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('${_bioCtrl.text.length} / 500 characters',
                        style: AppTextStyles.bodyMuted.copyWith(fontSize: 11)),
                  ]),
                ),
              ]),
            ),
          ),
        ]),
      ),

      // ── Floating save button ──────────────────────────────────
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: GestureDetector(
          onTap: (_saving || _saved) ? null : _save,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 17),
            decoration: BoxDecoration(
              color: _saved ? AppColors.mintGreen : AppColors.deepBlue,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: (_saved ? AppColors.mintGreen : AppColors.deepBlue)
                      .withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: _saving
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2.5),
                    )
                  : Text(
                      _saved ? '✅  Profile Saved!' : '💾  Save Profile',
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Shared sub-widgets ───────────────────────────────────────────────────────

class _BentoCard extends StatelessWidget {
  final Widget child;
  final Color accent;
  const _BentoCard({required this.child, required this.accent});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: accent.withOpacity(0.18),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: child,
      );
}

class _CardLabel extends StatelessWidget {
  final String label, emoji;
  const _CardLabel({required this.label, required this.emoji});

  @override
  Widget build(BuildContext context) => Row(children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 7),
        Text(label, style: AppTextStyles.cardTitle.copyWith(fontSize: 15)),
      ]);
}

class _InlineField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final Color accent;
  final TextInputType? keyboardType;
  const _InlineField({
    required this.controller,
    required this.hint,
    required this.accent,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(14),
        ),
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.nunito(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: AppColors.deepBlue),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodyMuted,
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      );
}
