import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/tutor.dart';
import '../models/booking_session.dart';
import '../services/mock_data.dart';
import '../navigation/siswa_nav.dart';
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

  void _showPaymentSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _buildPaymentSheet(ctx),
    );
  }

  Widget _buildPaymentSheet(BuildContext ctx) {
    final tutor = widget.tutor;
    final total = tutor.ratePerHour;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('💳', style: TextStyle(fontSize: 28)),
                const SizedBox(width: 12),
                Text('Payment Gateway', style: AppTextStyles.displayBold.copyWith(fontSize: 22)),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(ctx),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
                    child: const Icon(Icons.close_rounded, size: 20, color: Colors.grey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: _accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _accent.withOpacity(0.3), width: 1.5),
              ),
              child: Column(
                children: [
                  Text('Total Amount', style: AppTextStyles.bodyMuted),
                  const SizedBox(height: 4),
                  Text('Rp ${total.toStringAsFixed(0)}', style: AppTextStyles.displayBold.copyWith(color: _accent, fontSize: 32)),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Virtual Account', style: AppTextStyles.bodyMuted),
                      Text('88392 001 9283', style: AppTextStyles.cardTitle.copyWith(letterSpacing: 1.2)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: () {
                Navigator.pop(ctx);
                _processPayment();
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: _accent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: _accent.withOpacity(0.4), blurRadius: 18, offset: const Offset(0, 6))],
                ),
                child: Center(
                  child: Text('Confirm Payment',
                      style: GoogleFonts.nunito(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _processPayment() async {
    setState(() => _loading = true);
    
    await Future.delayed(const Duration(seconds: 2));
    
    final parts = widget.slot.split('  '); 
    final dateStr = parts.length > 1 ? '${parts[0]}, 26 May 2026' : 'Mon, 26 May 2026';
    final timeStr = parts.length > 1 ? parts[1] : widget.slot;
    
    final newSession = BookingSession(
      id: MockData.nextId(),
      tutorId: widget.tutor.id,
      tutorName: widget.tutor.name,
      studentName: 'Rizky Maulana',
      subject: widget.tutor.subjects.first,
      date: dateStr,
      timeSlot: timeStr,
      ratePerHour: widget.tutor.ratePerHour,
      status: SessionStatus.active,
      tutorAvatarEmoji: widget.tutor.avatarEmoji,
    );
    
    MockData.addBooking(newSession);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Text('✨', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 12),
              Expanded(child: Text('Payment successful! Session booked.', style: GoogleFonts.nunito(fontWeight: FontWeight.w700, fontSize: 15))),
            ],
          ),
          backgroundColor: AppColors.mintGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.all(16),
          elevation: 10,
        ),
      );
      
      setState(() {
        _loading = false;
        _confirmed = true;
      });
    }
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
                _PayRow(label: 'Session (1 hr)', value: 'Rp ${tutor.ratePerHour.toStringAsFixed(0)}'),
                const SizedBox(height: 8),
                _PayRow(label: 'Platform fee', value: 'Rp 0'),
                const SizedBox(height: 8),
                const Divider(height: 1),
                const SizedBox(height: 8),
                _PayRow(
                  label: 'Total',
                  value: 'Rp ${total.toStringAsFixed(0)}',
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
          onTap: _loading ? null : _showPaymentSheet,
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
                  : Text('🎉  Proceed to Payment',
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
            onTap: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const SiswaNav()),
                (r) => false),
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
