import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/tutor.dart';
import '../../theme.dart';
import 'rating_page.dart';

class SiswaTutorDetailPage extends StatefulWidget {
  final Tutor tutor;
  final int colorIndex;
  const SiswaTutorDetailPage(
      {required this.tutor, required this.colorIndex, super.key});

  @override
  State<SiswaTutorDetailPage> createState() => _SiswaTutorDetailPageState();
}

class _SiswaTutorDetailPageState extends State<SiswaTutorDetailPage> {
  String? _selectedSlot;
  bool _isBooking = false;
  bool _booked = false;

  Color get _accent =>
      AppColors.cardAccents[widget.colorIndex % AppColors.cardAccents.length];

  // Mock reviews
  static const _reviews = [
    _Review(
      name: 'Rizky M.',
      emoji: '👦',
      rating: 5,
      text: 'Amazing tutor! Explained everything so clearly.',
      date: '12 May 2026',
    ),
    _Review(
      name: 'Siti N.',
      emoji: '👧',
      rating: 5,
      text: 'Very patient and thorough. Highly recommend!',
      date: '08 May 2026',
    ),
    _Review(
      name: 'Ahmad F.',
      emoji: '🧑',
      rating: 4,
      text: 'Great session. Would book again.',
      date: '01 May 2026',
    ),
  ];

  Future<void> _book() async {
    setState(() => _isBooking = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() {
      _isBooking = false;
      _booked = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tutor = widget.tutor;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(children: [
        CustomScrollView(slivers: [
          // ── SliverAppBar hero ─────────────────────────────────
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: _accent.withOpacity(0.2),
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
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10)
                    ],
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      size: 18, color: AppColors.deepBlue),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10)
                    ],
                  ),
                  child: Icon(Icons.favorite_border_rounded,
                      size: 20, color: _accent),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _accent.withOpacity(0.3),
                      _accent.withOpacity(0.08)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 24),
                      Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          color: _accent,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: _accent.withOpacity(0.45),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            )
                          ],
                        ),
                        child: Center(
                          child: Text(tutor.avatarEmoji,
                              style: const TextStyle(fontSize: 38)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(tutor.name,
                          style: AppTextStyles.cardTitle
                              .copyWith(fontSize: 21)),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_on_rounded,
                              size: 14, color: _accent),
                          const SizedBox(width: 3),
                          Text(tutor.city, style: AppTextStyles.bodyMuted),
                          const SizedBox(width: 14),
                          const Text('⭐',
                              style: TextStyle(fontSize: 13)),
                          const SizedBox(width: 3),
                          Text(
                            '${tutor.rating} (${tutor.reviewCount} reviews)',
                            style: AppTextStyles.bodyMuted,
                          ),
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
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 140),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Stat row ───────────────────────────────
                    Row(children: [
                      _StatCard(
                        emoji: '💰',
                        label: 'Rate',
                        value: 'Rp ${tutor.ratePerHour.toStringAsFixed(0)}',
                        accent: _accent,
                      ),
                      const SizedBox(width: 10),
                      _StatCard(
                        emoji: '⭐',
                        label: 'Rating',
                        value: '${tutor.rating}',
                        accent: AppColors.mustardYellow,
                      ),
                      const SizedBox(width: 10),
                      _StatCard(
                        emoji: '💬',
                        label: 'Reviews',
                        value: '${tutor.reviewCount}',
                        accent: AppColors.mintGreen,
                      ),
                    ]),
                    const SizedBox(height: 24),

                    // ── About ──────────────────────────────────
                    _SectionLabel(label: 'About', emoji: '👤'),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Text(
                        tutor.bio,
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF444466),
                          height: 1.65,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Subjects ───────────────────────────────
                    _SectionLabel(label: 'Subjects', emoji: '📚'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: tutor.subjects.asMap().entries.map((e) {
                        final c = AppColors.chipColors[
                            e.key % AppColors.chipColors.length];
                        final tc = AppColors.chipTextColors[
                            e.key % AppColors.chipTextColors.length];
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: c,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(e.value,
                              style: AppTextStyles.chip
                                  .copyWith(color: tc, fontSize: 13)),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // ── Available Slots ────────────────────────
                    _SectionLabel(
                        label: 'Available Slots', emoji: '🗓️'),
                    const SizedBox(height: 4),
                    Text('Tap a slot to select it',
                        style: AppTextStyles.bodyMuted
                            .copyWith(fontSize: 11)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: tutor.availableSlots.map((slot) {
                        final selected = _selectedSlot == slot;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedSlot = slot),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 9),
                            decoration: BoxDecoration(
                              color: selected ? _accent : Colors.white,
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                color: selected
                                    ? _accent
                                    : Colors.grey.shade200,
                                width: 1.5,
                              ),
                              boxShadow: selected
                                  ? [
                                      BoxShadow(
                                        color: _accent.withOpacity(0.35),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      )
                                    ]
                                  : [],
                            ),
                            child: Text(
                              slot,
                              style: AppTextStyles.chip.copyWith(
                                color: selected
                                    ? Colors.white
                                    : const Color(0xFF555577),
                                fontSize: 13,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 28),

                    // ── Reviews ────────────────────────────────
                    Row(children: [
                      _SectionLabel(label: 'Reviews', emoji: '⭐'),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => SiswaRatingPage(
                            tutorName: tutor.name,
                            accent: _accent,
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _accent.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text('+ Add Review',
                              style: AppTextStyles.chip.copyWith(
                                color: AppColors.deepBlue,
                                fontSize: 12,
                              )),
                        ),
                      ),
                    ]),
                    const SizedBox(height: 10),
                    ..._reviews.map((r) => _ReviewCard(review: r)),
                  ]),
            ),
          ),
        ]),

        // ── Floating booking bar ──────────────────────────────
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
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: _booked
                ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.mintGreen,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.mintGreen.withOpacity(0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        )
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '🎉  Session Booked!',
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                : Row(children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Session Rate', style: AppTextStyles.bodyMuted),
                        Text(
                          'Rp ${tutor.ratePerHour.toStringAsFixed(0)}/hr',
                          style: AppTextStyles.priceBadge,
                        ),
                      ],
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: GestureDetector(
                        onTap: (_selectedSlot == null || _isBooking)
                            ? null
                            : _book,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding:
                              const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: _selectedSlot != null
                                ? _accent
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: _selectedSlot != null
                                ? [
                                    BoxShadow(
                                      color: _accent.withOpacity(0.4),
                                      blurRadius: 16,
                                      offset: const Offset(0, 6),
                                    )
                                  ]
                                : [],
                          ),
                          child: Center(
                            child: _isBooking
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5),
                                  )
                                : Text(
                                    _selectedSlot == null
                                        ? 'Select a Slot First'
                                        : '🎉  Book Session',
                                    style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16,
                                      color: _selectedSlot != null
                                          ? Colors.white
                                          : Colors.grey.shade500,
                                    ),
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

// ─── Sub-widgets ─────────────────────────────────────────────────────────────

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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          decoration: BoxDecoration(
            color: accent.withOpacity(0.13),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 4),
            Text(value,
                style: AppTextStyles.cardTitle.copyWith(fontSize: 13)),
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
        Text(label,
            style: AppTextStyles.cardTitle.copyWith(fontSize: 16)),
      ]);
}

class _Review {
  final String name, emoji, text, date;
  final int rating;
  const _Review(
      {required this.name,
      required this.emoji,
      required this.text,
      required this.date,
      required this.rating});
}

class _ReviewCard extends StatelessWidget {
  final _Review review;
  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3)),
            ],
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.mustardYellow.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                  child:
                      Text(review.emoji, style: const TextStyle(fontSize: 18))),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Text(review.name,
                          style: AppTextStyles.cardTitle
                              .copyWith(fontSize: 13)),
                      const Spacer(),
                      Text(
                          List.generate(
                              5,
                              (i) => i < review.rating ? '⭐' : '').join(),
                          style: const TextStyle(fontSize: 11)),
                    ]),
                    const SizedBox(height: 4),
                    Text(review.text,
                        style: AppTextStyles.bodyMuted
                            .copyWith(fontSize: 13, height: 1.5)),
                    const SizedBox(height: 4),
                    Text(review.date,
                        style:
                            AppTextStyles.bodyMuted.copyWith(fontSize: 11)),
                  ]),
            ),
          ]),
        ),
      );
}
