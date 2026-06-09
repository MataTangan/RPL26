import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

/// A multi-step payment bottom sheet that simulates a modern
/// payment gateway (like Gojek/Grab) for our offline MVP.
///
/// Returns `true` when the user completes payment successfully.
class PaymentBottomSheet extends StatefulWidget {
  final double amount;
  final Color accent;

  const PaymentBottomSheet({
    required this.amount,
    required this.accent,
    super.key,
  });

  @override
  State<PaymentBottomSheet> createState() => _PaymentBottomSheetState();
}

class _PaymentBottomSheetState extends State<PaymentBottomSheet> {
  int _currentStep = 0;
  String _selectedMethod = '';
  final _accountCtrl = TextEditingController();
  final _pinCtrl = TextEditingController();
  bool _processing = false;
  bool _success = false;

  @override
  void dispose() {
    _accountCtrl.dispose();
    _pinCtrl.dispose();
    super.dispose();
  }

  void _selectMethod(String method) {
    setState(() {
      _selectedMethod = method;
      _currentStep = 1;
    });
  }

  void _goToPin() {
    if (_accountCtrl.text.trim().isEmpty) return;
    setState(() => _currentStep = 2);
  }

  Future<void> _confirmPayment() async {
    if (_pinCtrl.text.length < 6) return;
    setState(() {
      _currentStep = 3;
      _processing = true;
    });
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    setState(() {
      _processing = false;
      _success = true;
    });
  }

  void _done() => Navigator.pop(context, true);

  void _goBack() {
    if (_currentStep > 0) {
      setState(() => _currentStep = _currentStep - 1);
    }
  }

  // ── Payment methods data ──────────────────────────────────────────────────
  static const _methods = [
    _PayMethod(name: 'QRIS', emoji: '📱', subtitle: 'Scan & Pay'),
    _PayMethod(name: 'BCA VA', emoji: '🏦', subtitle: 'Virtual Account'),
    _PayMethod(name: 'Mandiri', emoji: '🏛️', subtitle: 'Virtual Account'),
    _PayMethod(name: 'GoPay', emoji: '💚', subtitle: 'E-Wallet'),
    _PayMethod(name: 'OVO', emoji: '💜', subtitle: 'E-Wallet'),
    _PayMethod(name: 'Dana', emoji: '💙', subtitle: 'E-Wallet'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Drag handle ──────────────────────────────────────────
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          const SizedBox(height: 8),

          // ── Header ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                if (_currentStep > 0 && !_success)
                  GestureDetector(
                    onTap: _goBack,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          size: 14, color: AppColors.deepBlue),
                    ),
                  ),
                if (_currentStep > 0 && !_success) const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _headerTitle,
                    style: AppTextStyles.cardTitle.copyWith(fontSize: 18),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context, false),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.close_rounded,
                        size: 18, color: AppColors.deepBlue),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),

          // ── Step indicator ────────────────────────────────────────
          if (!_success)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: List.generate(4, (i) {
                  final active = i <= _currentStep;
                  return Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 4,
                      margin: EdgeInsets.only(right: i < 3 ? 6 : 0),
                      decoration: BoxDecoration(
                        color: active
                            ? widget.accent
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  );
                }),
              ),
            ),

          // ── Content ──────────────────────────────────────────────
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.05, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                ),
                child: _buildStep(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String get _headerTitle {
    switch (_currentStep) {
      case 0:
        return '💳  Payment Method';
      case 1:
        return '📝  Account Details';
      case 2:
        return '🔐  Enter PIN';
      case 3:
        return _success ? '🎉  Done!' : '⏳  Processing…';
      default:
        return '';
    }
  }

  Widget _buildStep() {
    switch (_currentStep) {
      case 0:
        return _buildSelectMethod();
      case 1:
        return _buildInputAccount();
      case 2:
        return _buildInputPin();
      case 3:
        return _buildProcessingSuccess();
      default:
        return const SizedBox.shrink();
    }
  }

  // ── STEP 0: Select Payment Method ──────────────────────────────────────────
  Widget _buildSelectMethod() {
    return Column(
      key: const ValueKey(0),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Total amount card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                widget.accent.withOpacity(0.15),
                widget.accent.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: widget.accent.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Column(children: [
            Text('Total Payment',
                style: AppTextStyles.bodyMuted.copyWith(fontSize: 13)),
            const SizedBox(height: 6),
            Text(
              'Rp ${widget.amount.toStringAsFixed(0)}',
              style: GoogleFonts.nunito(
                fontWeight: FontWeight.w900,
                fontSize: 32,
                color: AppColors.deepBlue,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.mintGreen.withOpacity(0.15),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Text('✨ No platform fee',
                  style: AppTextStyles.chip.copyWith(
                    color: const Color(0xFF006B63),
                    fontSize: 11,
                  )),
            ),
          ]),
        ),
        const SizedBox(height: 20),

        Text('Choose Payment Method',
            style: AppTextStyles.cardTitle.copyWith(fontSize: 15)),
        const SizedBox(height: 12),

        // Method grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.0,
          ),
          itemCount: _methods.length,
          itemBuilder: (_, i) {
            final m = _methods[i];
            return GestureDetector(
              onTap: () => _selectMethod(m.name),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(m.emoji, style: const TextStyle(fontSize: 28)),
                    const SizedBox(height: 6),
                    Text(m.name,
                        style: AppTextStyles.cardTitle.copyWith(fontSize: 12)),
                    Text(m.subtitle,
                        style: AppTextStyles.bodyMuted.copyWith(fontSize: 9)),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // ── STEP 1: Input Account / Phone ──────────────────────────────────────────
  Widget _buildInputAccount() {
    final isEWallet = _selectedMethod == 'GoPay' ||
        _selectedMethod == 'OVO' ||
        _selectedMethod == 'Dana';
    final label = isEWallet ? 'Phone Number' : 'Account Number';
    final hint = isEWallet ? '08xx xxxx xxxx' : '1234 5678 9012';
    final icon = isEWallet ? Icons.phone_android_rounded : Icons.account_balance_rounded;

    return Column(
      key: const ValueKey(1),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Method badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: widget.accent.withOpacity(0.12),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text(
              _methods.firstWhere((m) => m.name == _selectedMethod).emoji,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 8),
            Text(_selectedMethod,
                style: AppTextStyles.cardTitle.copyWith(fontSize: 14)),
          ]),
        ),
        const SizedBox(height: 20),

        Text(label, style: AppTextStyles.cardTitle.copyWith(fontSize: 15)),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: _accountCtrl,
            keyboardType:
                isEWallet ? TextInputType.phone : TextInputType.number,
            style: GoogleFonts.nunito(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: AppColors.deepBlue,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTextStyles.bodyMuted.copyWith(fontSize: 15),
              prefixIcon: Icon(icon, color: widget.accent, size: 22),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          isEWallet
              ? 'Enter the phone number linked to your $_selectedMethod account'
              : 'Enter your $_selectedMethod virtual account number',
          style: AppTextStyles.bodyMuted.copyWith(fontSize: 11),
        ),
        const SizedBox(height: 28),

        // Next button
        GestureDetector(
          onTap: _goToPin,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: widget.accent,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: widget.accent.withOpacity(0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'Next  →',
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── STEP 2: Input PIN ──────────────────────────────────────────────────────
  Widget _buildInputPin() {
    return Column(
      key: const ValueKey(2),
      children: [
        const SizedBox(height: 10),
        // Lock icon
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: widget.accent.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text('🔐', style: const TextStyle(fontSize: 32)),
          ),
        ),
        const SizedBox(height: 16),
        Text('Enter your 6-digit PIN',
            style: AppTextStyles.cardTitle.copyWith(fontSize: 16)),
        const SizedBox(height: 6),
        Text('To confirm your payment of Rp ${widget.amount.toStringAsFixed(0)}',
            style: AppTextStyles.bodyMuted.copyWith(fontSize: 12)),
        const SizedBox(height: 28),

        // PIN input
        Container(
          width: 220,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: widget.accent.withOpacity(0.12),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: TextField(
            controller: _pinCtrl,
            obscureText: true,
            maxLength: 6,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            style: GoogleFonts.nunito(
              fontWeight: FontWeight.w900,
              fontSize: 28,
              color: AppColors.deepBlue,
              letterSpacing: 12,
            ),
            decoration: InputDecoration(
              counterText: '',
              hintText: '• • • • • •',
              hintStyle: GoogleFonts.nunito(
                fontWeight: FontWeight.w400,
                fontSize: 24,
                color: Colors.grey.shade300,
                letterSpacing: 8,
              ),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Confirm button
        GestureDetector(
          onTap: _confirmPayment,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.deepBlue,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: AppColors.deepBlue.withOpacity(0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child: Text(
                '🔒  Confirm Payment',
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── STEP 3: Processing & Success ───────────────────────────────────────────
  Widget _buildProcessingSuccess() {
    if (_processing) {
      return Column(
        key: const ValueKey('processing'),
        children: [
          const SizedBox(height: 40),
          SizedBox(
            width: 56,
            height: 56,
            child: CircularProgressIndicator(
              color: widget.accent,
              strokeWidth: 4,
            ),
          ),
          const SizedBox(height: 24),
          Text('Processing Payment…',
              style: AppTextStyles.cardTitle.copyWith(fontSize: 17)),
          const SizedBox(height: 8),
          Text('Please wait while we verify your transaction',
              style: AppTextStyles.bodyMuted.copyWith(fontSize: 13)),
          const SizedBox(height: 40),
        ],
      );
    }

    return Column(
      key: const ValueKey('success'),
      children: [
        const SizedBox(height: 24),
        // Success icon
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: AppColors.mintGreen.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Text('✅', style: TextStyle(fontSize: 48)),
          ),
        ),
        const SizedBox(height: 20),
        Text('Payment Successful!',
            style: AppTextStyles.cardTitle.copyWith(fontSize: 20)),
        const SizedBox(height: 8),
        Text(
          'Rp ${widget.amount.toStringAsFixed(0)} paid via $_selectedMethod',
          style: AppTextStyles.bodyMuted.copyWith(fontSize: 13),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.mintGreen.withOpacity(0.15),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: AppColors.mintGreen.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Text('🎓  Session booked successfully!',
              style: AppTextStyles.chip.copyWith(
                color: const Color(0xFF006B63),
                fontSize: 12,
              )),
        ),
        const SizedBox(height: 32),

        // Done button
        GestureDetector(
          onTap: _done,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.mintGreen,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: AppColors.mintGreen.withOpacity(0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child: Text(
                '🎉  Done',
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _PayMethod {
  final String name, emoji, subtitle;
  const _PayMethod(
      {required this.name, required this.emoji, required this.subtitle});
}
