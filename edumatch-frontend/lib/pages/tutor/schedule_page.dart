import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme.dart';

// ─── Data model ───────────────────────────────────────────────────────────────

// ─── Page ─────────────────────────────────────────────────────────────────────

class TutorSchedulePage extends StatefulWidget {
  const TutorSchedulePage({super.key});

  @override
  State<TutorSchedulePage> createState() => _TutorSchedulePageState();
}

class _TutorSchedulePageState extends State<TutorSchedulePage> {
  int _selectedDay = 0; // index into _days

  static const _days = [
    ('Mon', 'Monday'),
    ('Tue', 'Tuesday'),
    ('Wed', 'Wednesday'),
    ('Thu', 'Thursday'),
    ('Fri', 'Friday'),
    ('Sat', 'Saturday'),
    ('Sun', 'Sunday'),
  ];

  // Time slots per day (shared for simplicity in mock)
  static const _times = [
    '07:00 – 08:00',
    '08:00 – 09:00',
    '09:00 – 10:00',
    '10:00 – 11:00',
    '11:00 – 12:00',
    '13:00 – 14:00',
    '14:00 – 15:00',
    '15:00 – 16:00',
    '16:00 – 17:00',
    '18:00 – 19:00',
    '19:00 – 20:00',
    '20:00 – 21:00',
  ];

  // For each day, track which time indices are enabled
  final Map<int, Set<int>> _enabled = {
    0: {2, 3, 9}, // Monday: 09-11, 19-20
    1: {2, 5}, // Tuesday
    2: {4, 10}, // Wednesday
    3: {6, 7}, // Thursday
    4: {1, 8}, // Friday
    5: {0, 1, 2}, // Saturday
    6: {}, // Sunday
  };

  bool _saving = false;

  Future<void> _save() async {
    setState(() => _saving = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() => _saving = false);
  }

  void _toggleSlot(int timeIdx) {
    setState(() {
      final set = _enabled[_selectedDay]!;
      set.contains(timeIdx) ? set.remove(timeIdx) : set.add(timeIdx);
    });
  }

  int get _totalAvailable =>
      _enabled.values.fold(0, (sum, s) => sum + s.length);

  @override
  Widget build(BuildContext context) {
    final accentDay =
        AppColors.cardAccents[_selectedDay % AppColors.cardAccents.length];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // ── Header ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('My Schedule 🗓️',
                                  style: AppTextStyles.displayBold),
                              const SizedBox(height: 4),
                              Text('Tap slots to toggle availability',
                                  style: AppTextStyles.appBarSub),
                            ]),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.mintGreen.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                                color: AppColors.mintGreen.withOpacity(0.4),
                                width: 1.5),
                          ),
                          child: Text('$_totalAvailable slots open',
                              style: AppTextStyles.chip.copyWith(
                                  color: const Color(0xFF006B63),
                                  fontSize: 11)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ── Weekly day picker ──────────────────────────────
                    SizedBox(
                      height: 78,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _days.length,
                        itemBuilder: (_, i) {
                          final active = i == _selectedDay;
                          final accent = AppColors
                              .cardAccents[i % AppColors.cardAccents.length];
                          final slotCount = _enabled[i]!.length;
                          return Padding(
                            padding: EdgeInsets.only(
                                right: i < _days.length - 1 ? 8 : 0),
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedDay = i),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 58,
                                decoration: BoxDecoration(
                                  color: active ? accent : Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: [
                                    BoxShadow(
                                      color: active
                                          ? accent.withOpacity(0.35)
                                          : Colors.black.withOpacity(0.05),
                                      blurRadius: active ? 14 : 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _days[i].$1,
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 13,
                                        color: active
                                            ? Colors.white
                                            : AppColors.deepBlue,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: active
                                            ? Colors.white.withOpacity(0.25)
                                            : (slotCount > 0
                                                ? accent.withOpacity(0.18)
                                                : Colors.grey.shade100),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '$slotCount',
                                          style: GoogleFonts.nunito(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 11,
                                            color: active
                                                ? Colors.white
                                                : (slotCount > 0
                                                    ? accent
                                                    : Colors.grey.shade400),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 14),

                    // ── Day label ──────────────────────────────────────
                    Row(children: [
                      Text(
                        '${_days[_selectedDay].$2}  •',
                        style: AppTextStyles.cardTitle.copyWith(fontSize: 16),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${_enabled[_selectedDay]!.length} slots open',
                        style: AppTextStyles.bodyMuted,
                      ),
                    ]),
                  ]),
            ),
            const SizedBox(height: 10),

            // ── Time slots grid ───────────────────────────────────
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 2.4,
              ),
              itemCount: _times.length,
              itemBuilder: (_, i) {
                final enabled = _enabled[_selectedDay]!.contains(i);
                return GestureDetector(
                  onTap: () => _toggleSlot(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    decoration: BoxDecoration(
                      color: enabled ? accentDay : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: enabled ? accentDay : Colors.grey.shade200,
                        width: 1.5,
                      ),
                      boxShadow: enabled
                          ? [
                              BoxShadow(
                                color: accentDay.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ]
                          : [],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _times[i].split(' – ').first,
                            style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w800,
                              fontSize: 11,
                              color:
                                  enabled ? Colors.white : AppColors.deepBlue,
                            ),
                          ),
                          Text(
                            enabled ? '✓ Open' : 'Closed',
                            style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w600,
                              fontSize: 9,
                              color: enabled
                                  ? Colors.white.withOpacity(0.8)
                                  : Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            // ── Save Availability button (inline) ──────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: _saving ? null : _save,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: accentDay,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: accentDay.withOpacity(0.45),
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
                                color: Colors.white, strokeWidth: 2.5))
                        : Text(
                            '💾  Save Availability',
                            style: GoogleFonts.nunito(
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                                color: Colors.white),
                          ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 120),
          ]),
        ),
      ),
    );
  }
}
