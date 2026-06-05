import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/tutor.dart';
import '../services/mock_data.dart';
import '../theme.dart';
import '../widgets/tutor_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  List<Tutor> _filtered = MockData.tutors;

  void _onSearch(String query) {
    final q = query.toLowerCase();
    setState(() {
      _filtered = MockData.tutors
          .where((t) =>
              t.name.toLowerCase().contains(q) ||
              t.subjects.any((s) => s.toLowerCase().contains(q)) ||
              t.city.toLowerCase().contains(q))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── AppBar ──────────────────────────────────────
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.deepBlue,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🎓',
                            style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 6),
                        Text(
                          'EduMatch',
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
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
                    child: const Icon(Icons.notifications_none_rounded,
                        color: AppColors.deepBlue, size: 22),
                  ),
                ],
              ),
            ),

            // ── Header ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Find Your\nPerfect Tutor ✨',
                      style: AppTextStyles.displayBold),
                  const SizedBox(height: 4),
                  Text('Browse top-rated educators near you',
                      style: AppTextStyles.appBarSub),
                  const SizedBox(height: 14),
                  // Search bar
                  Container(
                    height: 50,
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
                      controller: _searchController,
                      onChanged: _onSearch,
                      style: AppTextStyles.bodyMuted
                          .copyWith(color: AppColors.deepBlue),
                      decoration: InputDecoration(
                        hintText: 'Search tutors, subjects, city…',
                        hintStyle: AppTextStyles.bodyMuted,
                        prefixIcon: Icon(Icons.search_rounded,
                            color: Colors.grey.shade400, size: 22),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Subject filter chips ─────────────────────────
            SizedBox(
              height: 38,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  'All',
                  'Math',
                  'Science',
                  'English',
                  'Coding',
                  'Music',
                  'History',
                ].asMap().entries.map((e) {
                  final i = e.key;
                  final label = e.value;
                  final color = AppColors.cardAccents[
                      i % AppColors.cardAccents.length];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        if (label == 'All') {
                          _searchController.clear();
                          _onSearch('');
                        } else {
                          _searchController.text = label;
                          _onSearch(label);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                              color: color.withOpacity(0.5), width: 1.5),
                        ),
                        child: Text(label,
                            style: AppTextStyles.chip
                                .copyWith(color: AppColors.deepBlue)),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 8),

            // ── Tutor list ───────────────────────────────────
            Expanded(
              child: _filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🔍',
                              style: TextStyle(fontSize: 48)),
                          const SizedBox(height: 10),
                          Text('No tutors found',
                              style: AppTextStyles.cardTitle),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      itemCount: _filtered.length,
                      itemBuilder: (ctx, i) =>
                          TutorTile(tutor: _filtered[i], index: i),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
