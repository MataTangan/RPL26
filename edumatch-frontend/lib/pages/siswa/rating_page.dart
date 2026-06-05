import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme.dart';

/// A bottom-sheet modal for leaving a star rating + text review.
/// Usage:
///   showModalBottomSheet(
///     context: context,
///     isScrollControlled: true,
///     backgroundColor: Colors.transparent,
///     builder: (_) => SiswaRatingPage(tutorName: '...', accent: color),
///   );
class SiswaRatingPage extends StatefulWidget {
  final String tutorName;
  final Color accent;
  const SiswaRatingPage(
      {required this.tutorName, required this.accent, super.key});

  @override
  State<SiswaRatingPage> createState() => _SiswaRatingPageState();
}

class _SiswaRatingPageState extends State<SiswaRatingPage> {
  int _stars = 0;
  bool _submitted = false;
  bool _loading = false;
  final _reviewCtrl = TextEditingController();

  @override
  void dispose() {
    _reviewCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_stars == 0) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() {
      _loading = false;
      _submitted = true;
    });
  }

  String get _starLabel {
    switch (_stars) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Great';
      case 5:
        return 'Amazing! 🎉';
      default:
        return 'Tap a star to rate';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 36),
        child: _submitted ? _buildSuccess() : _buildForm(),
      ),
    );
  }

  Widget _buildForm() {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      // Handle
      Center(
        child: Container(
          width: 40,
          height: 4,
          margin: const EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),

      // Header
      Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: widget.accent,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: widget.accent.withOpacity(0.4),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Center(
            child: Text('⭐', style: TextStyle(fontSize: 32))),
      ),
      const SizedBox(height: 16),
      Text(
        'Rate your session',
        style: AppTextStyles.displayBold.copyWith(fontSize: 22),
      ),
      const SizedBox(height: 6),
      Text(
        'How was your session with ${widget.tutorName}?',
        style: AppTextStyles.bodyMuted,
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 28),

      // Star row
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (i) {
          final filled = i < _stars;
          return GestureDetector(
            onTap: () => setState(() => _stars = i + 1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.symmetric(horizontal: 6),
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: filled
                    ? AppColors.mustardYellow.withOpacity(0.2)
                    : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  filled ? '⭐' : '☆',
                  style: TextStyle(fontSize: filled ? 26 : 24),
                ),
              ),
            ),
          );
        }),
      ),
      const SizedBox(height: 12),
      AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Text(
          _starLabel,
          key: ValueKey(_stars),
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.w800,
            fontSize: 16,
            color: _stars > 0
                ? const Color(0xFF7A5C00)
                : const Color(0xFF9E9EB0),
          ),
        ),
      ),
      const SizedBox(height: 24),

      // Text field
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: widget.accent.withOpacity(0.12),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _reviewCtrl,
          maxLines: 4,
          style: GoogleFonts.nunito(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: AppColors.deepBlue),
          decoration: InputDecoration(
            hintText:
                'Share your experience… (optional)\nWhat did you like about this session?',
            hintStyle:
                AppTextStyles.bodyMuted.copyWith(fontSize: 13, height: 1.5),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ),
      const SizedBox(height: 24),

      // Submit button
      GestureDetector(
        onTap: (_stars == 0 || _loading) ? null : _submit,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 17),
          decoration: BoxDecoration(
            color: _stars > 0 ? widget.accent : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(50),
            boxShadow: _stars > 0
                ? [
                    BoxShadow(
                      color: widget.accent.withOpacity(0.4),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    )
                  ]
                : [],
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
                    _stars == 0 ? 'Select a rating first' : '🌟  Submit Review',
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      color: _stars > 0 ? Colors.white : Colors.grey.shade500,
                    ),
                  ),
          ),
        ),
      ),
    ]);
  }

  Widget _buildSuccess() {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      const SizedBox(height: 30),
      const Text('🎊', style: TextStyle(fontSize: 72)),
      const SizedBox(height: 16),
      Text('Thank you! 🙏',
          style: AppTextStyles.displayBold.copyWith(fontSize: 24)),
      const SizedBox(height: 8),
      Text(
        'Your review for ${widget.tutorName} has been submitted.',
        style: AppTextStyles.bodyMuted.copyWith(fontSize: 15),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 32),
      GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.mintGreen,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: AppColors.mintGreen.withOpacity(0.4),
                blurRadius: 16,
                offset: const Offset(0, 6),
              )
            ],
          ),
          child: Text(
            'Done',
            style: GoogleFonts.nunito(
                fontWeight: FontWeight.w900,
                fontSize: 15,
                color: Colors.white),
          ),
        ),
      ),
      const SizedBox(height: 20),
    ]);
  }
}
