import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../theme/app_colors.dart';
import '../../../../widgets/gradient_app_bar.dart';

/// Chat detail screen for individual conversations
class ChatDetailScreen extends StatefulWidget {
  final String odaId;

  const ChatDetailScreen({super.key, required this.odaId});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Mock messages for demonstration
  final List<Map<String, dynamic>> _messages = [
    {'id': '1', 'text': 'Hey there! 👋', 'isMe': false, 'time': '10:30 AM'},
    {'id': '2', 'text': 'Hi! How are you?', 'isMe': true, 'time': '10:31 AM'},
    {
      'id': '3',
      'text': "I'm doing great, thanks for asking! What about you?",
      'isMe': false,
      'time': '10:32 AM',
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'text': _messageController.text.trim(),
        'isMe': true,
        'time': 'Now',
      });
    });

    _messageController.clear();

    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: GradientAppBar(
        title: 'Anonymous Chat',
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () => _showOptionsSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),

          // Input Area
          Container(
            padding: EdgeInsets.fromLTRB(
              16,
              12,
              16,
              MediaQuery.of(context).padding.bottom + 12,
            ),
            decoration: BoxDecoration(
              color: AppColors.backgroundDark,
              border: Border(
                top: BorderSide(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    child: TextField(
                      controller: _messageController,
                      style: const TextStyle(
                        fontFamily: 'RobotoSlab',
                        color: Colors.white,
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(
                          fontFamily: 'RobotoSlab',
                          color: Colors.white.withValues(alpha: 0.4),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(
                      Icons.send_rounded,
                      color: Colors.black,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isMe = message['isMe'] as bool;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[800],
              child: const Icon(Icons.person, color: Colors.white54, size: 18),
            ),
            const SizedBox(width: 8),
          ],
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isMe
                  ? AppColors.primary
                  : Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isMe ? 16 : 4),
                bottomRight: Radius.circular(isMe ? 4 : 16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message['text'] as String,
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    fontSize: 15,
                    color: isMe ? Colors.black : Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message['time'] as String,
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    fontSize: 11,
                    color: isMe
                        ? Colors.black.withValues(alpha: 0.5)
                        : Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
          if (isMe) const SizedBox(width: 8),
        ],
      ),
    );
  }

  void _showOptionsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.backgroundDark,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12, bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.block, color: Colors.white70),
                title: const Text(
                  'Block User',
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement block
                },
              ),
              ListTile(
                leading: Icon(Icons.flag, color: Colors.red.shade400),
                title: Text(
                  'Report User',
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    color: Colors.red.shade400,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement report
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.delete_outline,
                  color: Colors.white70,
                ),
                title: const Text(
                  'Delete Chat',
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context.pop(); // Go back to chat list
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
