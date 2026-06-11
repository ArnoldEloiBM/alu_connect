import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../data/mock_repository.dart';

class ChatScreen extends StatefulWidget {
  final ChatThread thread;

  const ChatScreen({super.key, required this.thread});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final TextEditingController _controller;
  late final List<Message> _messages;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _messages = MockRepository.instance.messagesForThread(widget.thread.id).reversed.toList();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.insert(
        0,
        Message(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          threadId: widget.thread.id,
          sender: 'You',
          text: text,
          time: DateTime.now(),
          isMine: true,
        ),
      );
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.thread.title),
            const SizedBox(height: 4),
            Text(
              widget.thread.subtitle,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.video_call_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _messageBubble(message);
              },
            ),
          ),
          const Divider(color: AppColors.border, height: 1),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.emoji_emotions_outlined, color: AppColors.textSecondary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              style: const TextStyle(color: AppColors.textPrimary),
                              decoration: const InputDecoration(
                                hintText: 'Write a message',
                                hintStyle: TextStyle(color: AppColors.textSecondary),
                                border: InputBorder.none,
                              ),
                              textInputAction: TextInputAction.send,
                              onSubmitted: (_) => _sendMessage(),
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.attach_file, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: const BoxDecoration(
                        color: AppColors.gold,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send, color: Colors.black, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _messageBubble(Message message) {
    final isMine = message.isMine;
    return Container(
      margin: EdgeInsets.only(
        bottom: 12,
        left: isMine ? 48 : 0,
        right: isMine ? 0 : 48,
      ),
      child: Align(
        alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment:
              isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isMine ? AppColors.gold : AppColors.surfaceAlt,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isMine ? 18 : 6),
                  bottomRight: Radius.circular(isMine ? 6 : 18),
                ),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: isMine ? Colors.black : AppColors.textPrimary,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${message.sender} · ${_formatTime(message.time)}',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
