import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/tutor.dart';
import '../theme.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final Tutor tutor;
  final String slot;
  final int accentIndex;
  const BookingConfirmationScreen(
      {required this.tutor, required this.slot, required this.accentIndex, super.key});

  @override
  State<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState
    extends State<BookingConfirmationScreen> {
  bool _confirmed = false;
  bool _loading = false;

  Color get _accent =>
      AppColors.cardAccents[widget.accentIndex % AppColors.cardAccents.length];

  Future<void> _confirm() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _loading = false;
      _confirmed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: _confirmed ? _buildSuccess() : _buildForm(),
      ),
    );
  }

  Widget _buildForm() {
    final tutor = widget.tutor;
    final total = tutor.ratePerHour;
    return Column(children: [
      // Header
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 10)]),
              child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: AppColors.deepBlue),
            ),
          ),
          const SizedBox(width: 14),
          Text('Confirm Booking', style: AppTextStyles.cardTitle.copyWith(fontSize: 19)),
        ]),
      ),

      Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 6),

            // Tutor summary card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: _accent.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 8))],
              ),
              child: Row(children: [
                Container(
                  width: 60, height: 60,
                  decoration: BoxDecoration(color: _accent, shape: BoxShape.circle),
                  child: Center(child: Text(tutor.avatarEmoji, style: const TextStyle(fontSize: 28))),
                ),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(tutor.name, style: AppTextStyles.cardTitle),
                  const SizedBox(height: 2),
                  Text(tutor.subjects.first, style: AppTextStyles.bodyMuted),
                  Text(tutor.city, style: AppTextStyles.bodyMuted),
                ])),
              ]),
            ),
            const SizedBox(height: 18),

            // Session info card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: _accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(children: [
                _InfoRow(icon: '🗓️', label: 'Date & Time', value: widget.slot),
                const SizedBox(height: 12),
                _InfoRow(icon: '⏱️', label: 'Duration', value: '1 Hour'),
                const SizedBox(height: 12),
                _InfoRow(icon: '📚', label: 'Subject', value: tutor.subjects.first),
              ]),
            ),
            const SizedBox(height: 18),

            // Payment breakdown
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12)],
              ),
              child: Column(children: [
                Row(children: [
                  Text('💳  Payment Summary', style: AppTextStyles.cardTitle.copyWith(fontSize: 15)),
                ]),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
                _PayRow(label: 'Session (1 hr)', value: '\$${tutor.ratePerHour.toStringAsFixed(0)}'),
                const SizedBox(height: 8),
                _PayRow(label: 'Platform fee', value: '\$0'),
                const SizedBox(height: 8),
                const Divider(height: 1),
                const SizedBox(height: 8),
                _PayRow(
                  label: 'Total',
                  value: '\$${total.toStringAsFixed(0)}',
                  isBold: true,
                ),
              ]),
            ),
            const SizedBox(height: 30),
          ]),
        ),
      ),

      // Confirm button
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: GestureDetector(
          onTap: _loading ? null : _confirm,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              color: _accent,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: _accent.withOpacity(0.4), blurRadius: 18, offset: const Offset(0, 6))],
            ),
            child: Center(
              child: _loading
                  ? const SizedBox(
                      width: 22, height: 22,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                  : Text('🎉  Confirm & Pay \$${total.toStringAsFixed(0)}',
                      style: GoogleFonts.nunito(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.white)),
            ),
          ),
        ),
      ),
    ]);
  }

  Widget _buildSuccess() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('🎊', style: TextStyle(fontSize: 72)),
          const SizedBox(height: 20),
          Text('Booking Confirmed!', style: AppTextStyles.displayBold.copyWith(fontSize: 26)),
          const SizedBox(height: 10),
          Text('Your session with ${widget.tutor.name} is set for ${widget.slot}.',
              style: AppTextStyles.bodyMuted.copyWith(fontSize: 15),
              textAlign: TextAlign.center),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: () => Navigator.popUntil(context, (r) => r.isFirst),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.mintGreen,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [BoxShadow(color: AppColors.mintGreen.withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 6))],
              ),
              child: Text('Back to Home',
                  style: GoogleFonts.nunito(fontWeight: FontWeight.w900, fontSize: 15, color: Colors.white)),
            ),
          ),
        ]),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String icon, label, value;
  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Row(children: [
        Text(icon, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 10),
        Text(label, style: AppTextStyles.bodyMuted),
        const Spacer(),
        Text(value, style: AppTextStyles.chip.copyWith(color: AppColors.deepBlue, fontSize: 13)),
      ]);
}

class _PayRow extends StatelessWidget {
  final String label, value;
  final bool isBold;
  const _PayRow({required this.label, required this.value, this.isBold = false});

  @override
  Widget build(BuildContext context) => Row(children: [
        Text(label,
            style: isBold
                ? AppTextStyles.cardTitle.copyWith(fontSize: 15)
                : AppTextStyles.bodyMuted),
        const Spacer(),
        Text(value,
            style: isBold
                ? AppTextStyles.priceBadge.copyWith(fontSize: 17)
                : AppTextStyles.chip.copyWith(color: AppColors.deepBlue, fontSize: 13)),
      ]);
}
