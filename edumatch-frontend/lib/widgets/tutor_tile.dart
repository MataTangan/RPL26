import 'package:flutter/material.dart';
import '../models/tutor.dart';
import '../screens/tutor_detail_screen.dart';
import '../theme.dart';

class TutorTile extends StatelessWidget {
  final Tutor tutor;
  final int index;
  const TutorTile({required this.tutor, required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    final accentColor =
        AppColors.cardAccents[index % AppColors.cardAccents.length];

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                TutorDetailScreen(tutor: tutor, colorIndex: index),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: accentColor.withOpacity(0.25),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AccentBanner(accentColor: accentColor, tutor: tutor),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SubjectChips(subjects: tutor.subjects, baseIndex: index),
                      const SizedBox(height: 14),
                      Row(children: [
                        Icon(Icons.location_on_rounded, size: 14, color: accentColor),
                        const SizedBox(width: 4),
                        Text(tutor.city, style: AppTextStyles.bodyMuted),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: accentColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            Text(
                              '\$${tutor.ratePerHour.toStringAsFixed(0)}',
                              style: AppTextStyles.priceBadge.copyWith(
                                fontSize: 16,
                                color: Color.fromARGB(
                                  255,
                                  (accentColor.red - 30).clamp(0, 255),
                                  (accentColor.green - 30).clamp(0, 255),
                                  (accentColor.blue - 30).clamp(0, 255),
                                ),
                              ),
                            ),
                            Text(' /hr', style: AppTextStyles.bodyMuted),
                          ]),
                        ),
                      ]),
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

class _AccentBanner extends StatelessWidget {
  final Color accentColor;
  final Tutor tutor;
  const _AccentBanner({required this.accentColor, required this.tutor});

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [accentColor.withOpacity(0.18), accentColor.withOpacity(0.06)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(children: [
        Container(
          width: 52, height: 52,
          decoration: BoxDecoration(color: accentColor, shape: BoxShape.circle),
          child: Center(
            child: Text(
              tutor.avatarEmoji.isEmpty ? _initials(tutor.name) : tutor.avatarEmoji,
              style: const TextStyle(fontSize: 22),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(tutor.name, style: AppTextStyles.cardTitle),
          const SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text('✦  Tutor',
                style: AppTextStyles.chip.copyWith(color: AppColors.deepBlue.withOpacity(0.75))),
          ),
        ])),
        Column(children: [
          const Text('⭐', style: TextStyle(fontSize: 18)),
          Text('${tutor.rating}', style: AppTextStyles.chip.copyWith(color: AppColors.deepBlue, fontSize: 11)),
        ]),
      ]),
    );
  }
}

class _SubjectChips extends StatelessWidget {
  final List<String> subjects;
  final int baseIndex;
  const _SubjectChips({required this.subjects, required this.baseIndex});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(subjects.length, (i) {
        final colorIdx = (baseIndex + i) % AppColors.chipColors.length;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.chipColors[colorIdx],
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(subjects[i],
              style: AppTextStyles.chip.copyWith(color: AppColors.chipTextColors[colorIdx])),
        );
      }),
    );
  }
}
