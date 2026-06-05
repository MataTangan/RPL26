import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme.dart';

// ─── Mock message model ───────────────────────────────────────────────────────
class _ChatMessage {
  final String text;
  final bool isMe;
  final String time;
  const _ChatMessage(
      {required this.text, required this.isMe, required this.time});
}

// ─── Mock conversation ────────────────────────────────────────────────────────
final _mockMessages = [
  const _ChatMessage(
      text: 'Halo! Saya tertarik untuk belajar Matematika. Apakah masih ada slot kosong?',
      isMe: true,
      time: '09:12'),
  const _ChatMessage(
      text: 'Halo Rizky! Tentu, masih ada. Senin pagi jam 09:00–10:00 tersedia. 😊',
      isMe: false,
      time: '09:14'),
  const _ChatMessage(
      text: 'Bagus sekali! Saya ingin fokus ke Kalkulus dulu. Apakah bisa?',
      isMe: true,
      time: '09:15'),
  const _ChatMessage(
      text: 'Bisa banget! Kalkulus adalah salah satu keahlian utama saya. Kita mulai dari dasar ya.',
      isMe: false,
      time: '09:16'),
  const _ChatMessage(
      text: 'Siap! Saya tunggu konfirmasi booking-nya ya, Bu.',
      isMe: true,
      time: '09:18'),
  const _ChatMessage(
      text: 'Sudah saya konfirmasi. Sampai jumpa Senin! 🎉',
      isMe: false,
      time: '09:19'),
];

// ─── Page ─────────────────────────────────────────────────────────────────────
class SiswaChatPage extends StatefulWidget {
  final String tutorName;
  final String tutorEmoji;
  final Color accent;
  const SiswaChatPage({
    required this.tutorName,
    required this.tutorEmoji,
    required this.accent,
    super.key,
  });

  @override
  State<SiswaChatPage> createState() => _SiswaChatPageState();
}

class _SiswaChatPageState extends State<SiswaChatPage> {
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  final List<_ChatMessage> _messages = List.from(_mockMessages);
  bool _typing = false;

  void _send() {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_ChatMessage(
        text: text,
        isMe: true,
        time: _nowTime(),
      ));
      _msgCtrl.clear();
      _typing = true;
    });
    _scroll();

    // Simulate tutor reply
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() {
        _typing = false;
        _messages.add(const _ChatMessage(
          text: 'Terima kasih pesannya! Saya akan segera membalas. 😊',
          isMe: false,
          time: '',
        ));
      });
      _scroll();
    });
  }

  String _nowTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  void _scroll() {
    Future.delayed(const Duration(milliseconds: 80), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(children: [
          // ── AppBar ──────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      size: 16, color: AppColors.deepBlue),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: widget.accent,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: widget.accent.withOpacity(0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(widget.tutorEmoji,
                      style: const TextStyle(fontSize: 20)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.tutorName,
                          style: AppTextStyles.cardTitle
                              .copyWith(fontSize: 15)),
                      Row(children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.mintGreen,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text('Online',
                            style:
                                AppTextStyles.bodyMuted.copyWith(fontSize: 11)),
                      ]),
                    ]),
              ),
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: widget.accent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.videocam_outlined,
                    color: widget.accent, size: 20),
              ),
            ]),
          ),

          // ── Messages ────────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _messages.length + (_typing ? 1 : 0),
              itemBuilder: (_, i) {
                if (i == _messages.length && _typing) {
                  return _TypingBubble(accent: widget.accent);
                }
                return _Bubble(
                  message: _messages[i],
                  accent: widget.accent,
                );
              },
            ),
          ),

          // ── Input bar ───────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 14,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                        color: Colors.grey.shade200, width: 1.5),
                  ),
                  child: TextField(
                    controller: _msgCtrl,
                    minLines: 1,
                    maxLines: 4,
                    style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppColors.deepBlue),
                    decoration: InputDecoration(
                      hintText: 'Type a message…',
                      hintStyle: AppTextStyles.bodyMuted,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.emoji_emotions_outlined,
                            color: Color(0xFFB0B0C0), size: 20),
                        onPressed: () {},
                      ),
                    ),
                    onSubmitted: (_) => _send(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: _send,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: widget.accent,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: widget.accent.withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.send_rounded,
                      color: Colors.white, size: 20),
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}

// ─── Chat bubble ─────────────────────────────────────────────────────────────

class _Bubble extends StatelessWidget {
  final _ChatMessage message;
  final Color accent;
  const _Bubble({required this.message, required this.accent});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: accent.withOpacity(0.25),
                shape: BoxShape.circle,
              ),
              child: const Center(
                  child: Text('🌟', style: TextStyle(fontSize: 14))),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 11),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.68,
                  ),
                  decoration: BoxDecoration(
                    color: isMe ? accent : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(isMe ? 20 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isMe
                            ? accent.withOpacity(0.25)
                            : Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: isMe ? Colors.white : AppColors.deepBlue,
                      height: 1.4,
                    ),
                  ),
                ),
                if (message.time.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    message.time,
                    style: AppTextStyles.bodyMuted.copyWith(fontSize: 10),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Typing indicator ─────────────────────────────────────────────────────────

class _TypingBubble extends StatefulWidget {
  final Color accent;
  const _TypingBubble({required this.accent});

  @override
  State<_TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<_TypingBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: widget.accent.withOpacity(0.25),
            shape: BoxShape.circle,
          ),
          child: const Center(
              child: Text('🌟', style: TextStyle(fontSize: 14))),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(4),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) => Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                final delay = i * 0.15;
                final val = ((_ctrl.value + delay) % 1.0);
                final size = 6.0 + (val > 0.5 ? (1 - val) : val) * 4;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ]),
    );
  }
}
