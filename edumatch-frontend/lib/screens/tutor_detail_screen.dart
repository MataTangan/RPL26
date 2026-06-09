import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/tutor.dart';
import '../theme.dart';
import 'booking_confirmation_screen.dart';

class TutorDetailScreen extends StatefulWidget {
  final Tutor tutor;
  final int colorIndex;
  const TutorDetailScreen(
      {required this.tutor, required this.colorIndex, super.key});

  @override
  State<TutorDetailScreen> createState() => _TutorDetailScreenState();
}

class _TutorDetailScreenState extends State<TutorDetailScreen> {
  String? _selectedSlot;
  Color get _accent =>
      AppColors.cardAccents[widget.colorIndex % AppColors.cardAccents.length];

  @override
  Widget build(BuildContext context) {
    final tutor = widget.tutor;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(children: [
        CustomScrollView(slivers: [
          SliverAppBar(
            expandedHeight: 230,
            pinned: true,
            backgroundColor: _accent.withValues(alpha: 0.2),
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 10)
                    ],
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      size: 18, color: AppColors.deepBlue),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _accent.withValues(alpha: 0.3),
                      _accent.withValues(alpha: 0.08)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          color: _accent,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color: _accent.withValues(alpha: 0.4),
                                blurRadius: 18,
                                offset: const Offset(0, 8))
                          ],
                        ),
                        child: Center(
                            child: Text(tutor.avatarEmoji,
                                style: const TextStyle(fontSize: 38))),
                      ),
                      const SizedBox(height: 10),
                      Text(tutor.name,
                          style:
                              AppTextStyles.cardTitle.copyWith(fontSize: 21)),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_on_rounded,
                              size: 13, color: _accent),
                          const SizedBox(width: 3),
                          Text(tutor.city, style: AppTextStyles.bodyMuted),
                          const SizedBox(width: 12),
                          const Text('⭐', style: TextStyle(fontSize: 13)),
                          const SizedBox(width: 3),
                          Text('${tutor.rating} (${tutor.reviewCount} reviews)',
                              style: AppTextStyles.bodyMuted),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 130),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stat cards
                    Row(children: [
                      _StatCard(
                          emoji: '💰',
                          label: 'Rate',
                          value: 'Rp ${tutor.ratePerHour.toStringAsFixed(0)}/hr',
                          accent: _accent),
                      const SizedBox(width: 10),
                      _StatCard(
                          emoji: '⭐',
                          label: 'Rating',
                          value: '${tutor.rating}',
                          accent: AppColors.mustardYellow),
                      const SizedBox(width: 10),
                      _StatCard(
                          emoji: '💬',
                          label: 'Reviews',
                          value: '${tutor.reviewCount}',
                          accent: AppColors.mintGreen),
                    ]),
                    const SizedBox(height: 22),

                    // About
                    const _SectionLabel(label: 'About', emoji: '👤'),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 12,
                              offset: const Offset(0, 4))
                        ],
                      ),
                      child: Text(tutor.bio,
                          style: GoogleFonts.nunito(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF444466),
                              height: 1.6)),
                    ),
                    const SizedBox(height: 22),

                    // Subjects
                    const _SectionLabel(label: 'Subjects', emoji: '📚'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: tutor.subjects.asMap().entries.map((e) {
                        final c = AppColors
                            .chipColors[e.key % AppColors.chipColors.length];
                        final tc = AppColors.chipTextColors[
                            e.key % AppColors.chipTextColors.length];
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                              color: c,
                              borderRadius: BorderRadius.circular(50)),
                          child: Text(e.value,
                              style: AppTextStyles.chip
                                  .copyWith(color: tc, fontSize: 13)),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 22),

                    // Schedule
                    const _SectionLabel(label: 'Available Slots', emoji: '🗓️'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: tutor.availableSlots.map((slot) {
                        final selected = _selectedSlot == slot;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedSlot = slot),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 9),
                            decoration: BoxDecoration(
                              color: selected ? _accent : Colors.white,
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                  color:
                                      selected ? _accent : Colors.grey.shade200,
                                  width: 1.5),
                              boxShadow: selected
                                  ? [
                                      BoxShadow(
                                          color:
                                              _accent.withValues(alpha: 0.35),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4))
                                    ]
                                  : [],
                            ),
                            child: Text(slot,
                                style: AppTextStyles.chip.copyWith(
                                    color: selected
                                        ? Colors.white
                                        : const Color(0xFF555577),
                                    fontSize: 13)),
                          ),
                        );
                      }).toList(),
                    ),
                  ]),
            ),
          ),
        ]),

        // Floating action bar
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(28)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, -4))
              ],
            ),
            child: Row(children: [
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Session Rate', style: AppTextStyles.bodyMuted),
                    Text('Rp ${tutor.ratePerHour.toStringAsFixed(0)}/hr',
                        style: AppTextStyles.priceBadge),
                  ]),
              const SizedBox(width: 18),
              Expanded(
                child: GestureDetector(
                  onTap: _selectedSlot == null
                      ? null
                      : () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => BookingConfirmationScreen(
                                  tutor: tutor,
                                  slot: _selectedSlot!,
                                  accentIndex: widget.colorIndex))),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: _selectedSlot != null
                          ? _accent
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: _selectedSlot != null
                          ? [
                              BoxShadow(
                                  color: _accent.withValues(alpha: 0.4),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6))
                            ]
                          : [],
                    ),
                    child: Center(
                      child: Text(
                        _selectedSlot == null
                            ? 'Select a Slot First'
                            : '🎉  Book Session',
                        style: GoogleFonts.nunito(
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                            color: _selectedSlot != null
                                ? Colors.white
                                : Colors.grey.shade500),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String emoji, label, value;
  final Color accent;
  const _StatCard(
      {required this.emoji,
      required this.label,
      required this.value,
      required this.accent});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
          decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(18)),
          child: Column(children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 4),
            Text(value, style: AppTextStyles.cardTitle.copyWith(fontSize: 14)),
            Text(label, style: AppTextStyles.bodyMuted),
          ]),
        ),
      );
}

class _SectionLabel extends StatelessWidget {
  final String label, emoji;
  const _SectionLabel({required this.label, required this.emoji});

  @override
  Widget build(BuildContext context) => Row(children: [
        Text(emoji, style: const TextStyle(fontSize: 17)),
        const SizedBox(width: 7),
        Text(label, style: AppTextStyles.cardTitle.copyWith(fontSize: 16)),
      ]);
}
