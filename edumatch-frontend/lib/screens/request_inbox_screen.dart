import 'package:flutter/material.dart';
import '../models/booking_session.dart';
import '../services/mock_data.dart';
import '../theme.dart';

class RequestInboxScreen extends StatefulWidget {
  const RequestInboxScreen({super.key});

  @override
  State<RequestInboxScreen> createState() => _RequestInboxScreenState();
}

class _RequestInboxScreenState extends State<RequestInboxScreen> {
  late List<BookingSession> _pending;
  final Set<int> _accepted = {};

  @override
  void initState() {
    super.initState();
    _pending = MockData.sessions
        .where((s) => s.status == SessionStatus.pending)
        .toList();
  }

  void _accept(int id) => setState(() => _accepted.add(id));

  void _decline(int id) => setState(() => _pending.removeWhere((s) => s.id == id));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Request Inbox 📥', style: AppTextStyles.displayBold),
              const SizedBox(height: 4),
              Text('Review and respond to student requests', style: AppTextStyles.appBarSub),
            ]),
          ),

          Expanded(
            child: _pending.isEmpty
                ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                    const Text('🎉', style: TextStyle(fontSize: 48)),
                    const SizedBox(height: 10),
                    Text('All caught up!', style: AppTextStyles.cardTitle),
                    const SizedBox(height: 4),
                    Text('No pending requests right now.', style: AppTextStyles.bodyMuted),
                  ]))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _pending.length,
                    itemBuilder: (_, i) {
                      final s = _pending[i];
                      final accent = AppColors.cardAccents[i % AppColors.cardAccents.length];
                      final isAccepted = _accepted.contains(s.id);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [BoxShadow(color: accent.withOpacity(0.18), blurRadius: 18, offset: const Offset(0, 6))],
                          ),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            // Student info row
                            Row(children: [
                              Container(
                                width: 50, height: 50,
                                decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
                                child: Center(child: Text(s.tutorAvatarEmoji, style: const TextStyle(fontSize: 22))),
                              ),
                              const SizedBox(width: 12),
                              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(s.studentName, style: AppTextStyles.cardTitle.copyWith(fontSize: 15)),
                                Text('wants to learn  ${s.subject}', style: AppTextStyles.bodyMuted),
                              ])),
                              if (isAccepted)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppColors.mintGreen.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Text('Accepted ✓',
                                      style: AppTextStyles.chip.copyWith(color: const Color(0xFF006B63))),
                                ),
                            ]),
                            const SizedBox(height: 12),

                            // Date & time
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: accent.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(children: [
                                const Text('🗓️', style: TextStyle(fontSize: 14)),
                                const SizedBox(width: 8),
                                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text(s.date, style: AppTextStyles.chip.copyWith(color: AppColors.deepBlue, fontSize: 13)),
                                  Text(s.timeSlot, style: AppTextStyles.bodyMuted),
                                ])),
                                Text('\$${s.ratePerHour.toStringAsFixed(0)}/hr',
                                    style: AppTextStyles.priceBadge.copyWith(fontSize: 15)),
                              ]),
                            ),

                            if (!isAccepted) ...[
                              const SizedBox(height: 12),
                              // Action buttons
                              Row(children: [
                                // Decline
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => _decline(s.id),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFE8E8),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Center(
                                        child: Text('✕  Decline',
                                            style: AppTextStyles.chip.copyWith(color: const Color(0xFFCC3333), fontSize: 14)),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // Accept
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => _accept(s.id),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      decoration: BoxDecoration(
                                        color: AppColors.mintGreen,
                                        borderRadius: BorderRadius.circular(50),
                                        boxShadow: [BoxShadow(color: AppColors.mintGreen.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4))],
                                      ),
                                      child: Center(
                                        child: Text('✓  Accept',
                                            style: AppTextStyles.chip.copyWith(color: Colors.white, fontSize: 14)),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                            ],
                          ]),
                        ),
                      );
                    },
                  ),
          ),
        ]),
      ),
    );
  }
}
