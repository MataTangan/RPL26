import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme.dart';

// ─── Mock message model ───────────────────────────────────────────────────────
class TutorChatMessage {
  final String text;
  final bool isMe; // true = tutor (me), false = student
  final String time;
  const TutorChatMessage(
      {required this.text, required this.isMe, required this.time});
}

// ─── Mock student conversations ───────────────────────────────────────────────
final mockTutorConversations = [
  TutorConversation(
    studentName: 'Rizky Maulana',
    studentEmoji: '👦',
    lastMsg: 'Siap! Saya tunggu konfirmasinya ya, Bu.',
    time: '09:18',
    unread: 1,
    accent: AppColors.mustardYellow,
    messages: const [
      TutorChatMessage(
          text: 'Halo Bu Aisha! Boleh tanya soal Kalkulus diferensial?',
          isMe: false,
          time: '09:10'),
      TutorChatMessage(
          text: 'Tentu Rizky! Bagian mana yang masih bingung?',
          isMe: true,
          time: '09:11'),
      TutorChatMessage(
          text: 'Turunan fungsi komposit, Bu. Sering keliru tanda.',
          isMe: false,
          time: '09:12'),
      TutorChatMessage(
          text: 'Oke, kita latihan Chain Rule ya di sesi Senin.',
          isMe: true,
          time: '09:14'),
      TutorChatMessage(
          text: 'Siap! Saya tunggu konfirmasinya ya, Bu.',
          isMe: false,
          time: '09:18'),
    ],
  ),
  TutorConversation(
    studentName: 'Siti Nurhaliza',
    studentEmoji: '👧',
    lastMsg: 'Terima kasih banyak Bu! 🙏',
    time: '08:45',
    unread: 0,
    accent: AppColors.mintGreen,
    messages: const [
      TutorChatMessage(
          text: 'Selamat pagi Bu! Jadwal IELTS Writing jadi hari apa?',
          isMe: false,
          time: '08:30'),
      TutorChatMessage(
          text: 'Jumat jam 09:00 ya Siti. Sudah saya konfirmasi.',
          isMe: true,
          time: '08:40'),
      TutorChatMessage(
          text: 'Terima kasih Bu!',
          isMe: false,
          time: '08:45'),
    ],
  ),
];

// ─── Data classes ─────────────────────────────────────────────────────────────

class TutorConversation {
  final String studentName, studentEmoji, lastMsg, time;
  final int unread;
  final Color accent;
  final List<TutorChatMessage> messages;
  const TutorConversation({
    required this.studentName,
    required this.studentEmoji,
    required this.lastMsg,
    required this.time,
    required this.unread,
    required this.accent,
    required this.messages,
  });
}

// ─── Main Chat List Page ──────────────────────────────────────────────────────

class TutorChatPage extends StatelessWidget {
  const TutorChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // ── Header ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
            child: Row(children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Messages 💬', style: AppTextStyles.displayBold),
                  const SizedBox(height: 4),
                  Text('Chat with your students',
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
                child: const Icon(Icons.edit_outlined,
                    color: AppColors.deepBlue, size: 20),
              ),
            ]),
          ),

          // ── Search bar ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.deepBlue),
                decoration: InputDecoration(
                  hintText: 'Search conversations…',
                  hintStyle: AppTextStyles.bodyMuted,
                  prefixIcon: Icon(Icons.search_rounded,
                      color: Colors.grey.shade400, size: 20),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 13),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // ── Conversation list ───────────────────────────────────
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: mockTutorConversations.length,
              itemBuilder: (_, i) {
                final conv = mockTutorConversations[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            TutorChatDetailPage(conversation: conv),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: conv.accent.withOpacity(0.15),
                            blurRadius: 14,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(children: [
                        Stack(children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: conv.accent,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(conv.studentEmoji,
                                  style: const TextStyle(fontSize: 22)),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: AppColors.mintGreen,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white, width: 2),
                              ),
                            ),
                          ),
                        ]),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(conv.studentName,
                                    style: AppTextStyles.cardTitle
                                        .copyWith(fontSize: 15)),
                                const SizedBox(height: 3),
                                Text(
                                  conv.lastMsg,
                                  style: AppTextStyles.bodyMuted
                                      .copyWith(fontSize: 12),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ]),
                        ),
                        const SizedBox(width: 10),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(conv.time,
                                  style: AppTextStyles.bodyMuted
                                      .copyWith(fontSize: 11)),
                              const SizedBox(height: 6),
                              if (conv.unread > 0)
                                Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    color: conv.accent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${conv.unread}',
                                      style: GoogleFonts.nunito(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 11,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                            ]),
                      ]),
                    ),
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

// ─── Chat detail page ─────────────────────────────────────────────────────────

class TutorChatDetailPage extends StatefulWidget {
  final TutorConversation conversation;
  const TutorChatDetailPage({super.key, required this.conversation});

  @override
  State<TutorChatDetailPage> createState() => _TutorChatDetailPageState();
}

class _TutorChatDetailPageState extends State<TutorChatDetailPage>
    with SingleTickerProviderStateMixin {
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  late List<TutorChatMessage> _messages;
  bool _typing = false;

  late AnimationController _dotCtrl;

  @override
  void initState() {
    super.initState();
    _messages = List.from(widget.conversation.messages);
    _dotCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    _dotCtrl.dispose();
    super.dispose();
  }

  void _send() {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;
    final now = DateTime.now();
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    setState(() {
      _messages.add(TutorChatMessage(text: text, isMe: true, time: timeStr));
      _msgCtrl.clear();
      _typing = true;
    });
    _scroll();

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() {
        _typing = false;
        _messages.add(const TutorChatMessage(
            text: 'Terima kasih! Saya akan segera membalas lebih lengkap ya.',
            isMe: false,
            time: ''));
      });
      _scroll();
    });
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
  Widget build(BuildContext context) {
    final conv = widget.conversation;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(children: [
          // ── AppBar ─────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2)),
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
                  color: conv.accent,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: conv.accent.withOpacity(0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(conv.studentEmoji,
                      style: const TextStyle(fontSize: 20)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(conv.studentName,
                          style:
                              AppTextStyles.cardTitle.copyWith(fontSize: 15)),
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
                        Text('Student  ·  Online',
                            style: AppTextStyles.bodyMuted
                                .copyWith(fontSize: 11)),
                      ]),
                    ]),
              ),
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: conv.accent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.videocam_outlined,
                    color: conv.accent, size: 20),
              ),
            ]),
          ),

          // ── Messages ────────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _messages.length + (_typing ? 1 : 0),
              itemBuilder: (_, i) {
                if (i == _messages.length && _typing) {
                  return _TypingBubble(
                    accent: conv.accent,
                    dotCtrl: _dotCtrl,
                  );
                }
                return _Bubble(
                  message: _messages[i],
                  accent: conv.accent,
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
                    offset: const Offset(0, -4)),
              ],
            ),
            child: Row(children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(24),
                    border:
                        Border.all(color: Colors.grey.shade200, width: 1.5),
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
                    color: conv.accent,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: conv.accent.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4)),
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
  final TutorChatMessage message;
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
                  child: Text('👦', style: TextStyle(fontSize: 14))),
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
                    maxWidth:
                        MediaQuery.of(context).size.width * 0.68,
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
                      color:
                          isMe ? Colors.white : AppColors.deepBlue,
                      height: 1.4,
                    ),
                  ),
                ),
                if (message.time.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(message.time,
                      style:
                          AppTextStyles.bodyMuted.copyWith(fontSize: 10)),
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

class _TypingBubble extends StatelessWidget {
  final Color accent;
  final AnimationController dotCtrl;
  const _TypingBubble({required this.accent, required this.dotCtrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: accent.withOpacity(0.25),
            shape: BoxShape.circle,
          ),
          child: const Center(
              child: Text('👦', style: TextStyle(fontSize: 14))),
        ),
        const SizedBox(width: 8),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
            animation: dotCtrl,
            builder: (_, __) => Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                final delay = i * 0.15;
                final val = ((dotCtrl.value + delay) % 1.0);
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
