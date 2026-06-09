import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/tutor.dart';
import '../../services/mock_data.dart';
import '../../theme.dart';
import '../../widgets/tutor_tile.dart';
import 'tutor_detail_page.dart';

class SiswaSearchPage extends StatefulWidget {
  const SiswaSearchPage({super.key});

  @override
  State<SiswaSearchPage> createState() => _SiswaSearchPageState();
}

class _SiswaSearchPageState extends State<SiswaSearchPage> {
  final _searchCtrl = TextEditingController();
  List<Tutor> _filtered = MockData.tutors;
  String _activeChip = 'All';
  String _activePriceChip = 'All';

  static const _chips = [
    ('All', '🌈'),
    ('Math', '🔢'),
    ('Science', '🔬'),
    ('English', '📖'),
    ('Coding', '💻'),
    ('Music', '🎵'),
    ('History', '🏛️'),
  ];

  // Price ranges in IDR (ratePerHour values from mock data)
  static const _priceChips = [
    ('All', '💰', 0.0, double.infinity),
    ('< 50k', '🟢', 0.0, 50000.0),
    ('50k–100k', '🟡', 50000.0, 100000.0),
    ('> 100k', '🔴', 100000.0, double.infinity),
  ];

  void _applyFilter(String query, String chip, String priceChip) {
    final q = query.toLowerCase();
    // Find the price range for the active price chip
    final priceRange = _priceChips.firstWhere(
      (p) => p.$1 == priceChip,
      orElse: () => _priceChips.first,
    );
    setState(() {
      _activeChip = chip;
      _activePriceChip = priceChip;
      _filtered = MockData.tutors.where((t) {
        final matchesSearch = q.isEmpty ||
            t.name.toLowerCase().contains(q) ||
            t.subjects.any((s) => s.toLowerCase().contains(q)) ||
            t.city.toLowerCase().contains(q);
        final matchesChip = chip == 'All' ||
            t.subjects.any(
                (s) => s.toLowerCase().contains(chip.toLowerCase()));
        final matchesPrice =
            t.ratePerHour >= priceRange.$3 && t.ratePerHour < priceRange.$4;
        return matchesSearch && matchesChip && matchesPrice;
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // ── Header ────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Find a Tutor 🔍', style: AppTextStyles.displayBold),
                    const SizedBox(height: 4),
                    Text('${MockData.tutors.length} tutors available near you',
                        style: AppTextStyles.appBarSub),
                  ]),
                ),
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.tune_rounded,
                      color: AppColors.deepBlue, size: 20),
                ),
              ]),
              const SizedBox(height: 16),

              // ── Search bar ─────────────────────────────────────
              Container(
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchCtrl,
          onChanged: (v) => _applyFilter(v, _activeChip, _activePriceChip),
                  style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.deepBlue),
                  decoration: InputDecoration(
                    hintText: 'Search name, subject, city…',
                    hintStyle: AppTextStyles.bodyMuted,
                    prefixIcon: Icon(Icons.search_rounded,
                        color: Colors.grey.shade400, size: 22),
                    suffixIcon: _searchCtrl.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.close_rounded,
                                color: Colors.grey.shade400, size: 20),
                            onPressed: () {
                              _searchCtrl.clear();
                              _applyFilter('', _activeChip, _activePriceChip);
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 14),

          // ── Subject filter chips ───────────────────────────────────────────
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _chips.length,
              itemBuilder: (_, i) {
                final chip = _chips[i];
                final active = _activeChip == chip.$1;
                final accent =
                    AppColors.cardAccents[i % AppColors.cardAccents.length];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => _applyFilter(_searchCtrl.text, chip.$1, _activePriceChip),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: active ? accent : accent.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: active ? accent : accent.withOpacity(0.3),
                          width: 1.5,
                        ),
                        boxShadow: active
                            ? [
                                BoxShadow(
                                  color: accent.withOpacity(0.35),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                )
                              ]
                            : [],
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Text(chip.$2,
                            style: const TextStyle(fontSize: 13)),
                        const SizedBox(width: 5),
                        Text(
                          chip.$1,
                          style: AppTextStyles.chip.copyWith(
                            color: active
                                ? Colors.white
                                : AppColors.deepBlue,
                          ),
                        ),
                      ]),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // ── Price filter chips ────────────────────────────────────────────
          SizedBox(
            height: 38,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _priceChips.length,
              itemBuilder: (_, i) {
                final chip = _priceChips[i];
                final active = _activePriceChip == chip.$1;
                const priceAccents = [
                  AppColors.deepBlue,
                  AppColors.mintGreen,
                  AppColors.mustardYellow,
                  AppColors.brightOrange,
                ];
                final accent = priceAccents[i % priceAccents.length];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => _applyFilter(_searchCtrl.text, _activeChip, chip.$1),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: active ? accent : accent.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: active ? accent : accent.withOpacity(0.3),
                          width: 1.5,
                        ),
                        boxShadow: active
                            ? [
                                BoxShadow(
                                  color: accent.withOpacity(0.35),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                )
                              ]
                            : [],
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Text(chip.$2,
                            style: const TextStyle(fontSize: 12)),
                        const SizedBox(width: 4),
                        Text(
                          chip.$1,
                          style: AppTextStyles.chip.copyWith(
                            color: active ? Colors.white : AppColors.deepBlue,
                            fontSize: 11,
                          ),
                        ),
                      ]),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),

          // ── Result count label ─────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              Text(
                '${_filtered.length} result${_filtered.length == 1 ? '' : 's'}',
                style: AppTextStyles.cardTitle.copyWith(fontSize: 14),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.mustardYellow.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text('Sort: Rating ⭐',
                    style: AppTextStyles.chip
                        .copyWith(color: const Color(0xFF7A5C00), fontSize: 11)),
              ),
            ]),
          ),
          const SizedBox(height: 6),

          // ── Tutor list ─────────────────────────────────────────
          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      const Text('🔍', style: TextStyle(fontSize: 52)),
                      const SizedBox(height: 12),
                      Text('No tutors found',
                          style: AppTextStyles.cardTitle),
                      const SizedBox(height: 6),
                      Text('Try a different subject or city',
                          style: AppTextStyles.bodyMuted),
                    ]),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    itemCount: _filtered.length,
                    itemBuilder: (ctx, i) => GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SiswaTutorDetailPage(
                            tutor: _filtered[i],
                            colorIndex: i,
                          ),
                        ),
                      ),
                      // Wrap in IgnorePointer=false so TutorTile gesture doesn't conflict
                      child: AbsorbPointer(
                        child: TutorTile(tutor: _filtered[i], index: i),
                      ),
                    ),
                  ),
          ),
        ]),
      ),
    );
  }
}
