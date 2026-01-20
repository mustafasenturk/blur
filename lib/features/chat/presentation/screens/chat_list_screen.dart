import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../theme/app_colors.dart';
import '../../../../widgets/gradient_app_bar.dart';

/// Chat list screen showing all conversations
class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const GradientAppBar(title: 'Chats', showBackButton: false),
      body: SafeArea(
        top: false,
        child: ListView(
          children: [
            // TEAM BLUR Message
            _buildChatTile(
              context: context,
              odaId: 'blur-team',
              avatar: 'assets/icons/logo_transparent.png',
              name: 'Blur Team',
              lastMessage: '🌟 Welcome to Blur! 🌟',
              time: '6 hours ago',
              isTeam: true,
            ),

            // Empty state or more chats
            Padding(
              padding: const EdgeInsets.all(48.0),
              child: Column(
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 64,
                    color: Colors.white.withOpacity(0.2),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No conversations yet',
                    style: TextStyle(
                      fontFamily: 'RobotoSlab',
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start chatting with strangers\nto see your conversations here',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'RobotoSlab',
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatTile({
    required BuildContext context,
    required String odaId,
    required String avatar,
    required String name,
    required String lastMessage,
    required String time,
    bool isTeam = false,
  }) {
    return ListTile(
      onTap: () => context.push('/chat/$odaId'),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        radius: 28,
        backgroundColor: isTeam ? AppColors.buttonBackground : Colors.grey[800],
        child: isTeam
            ? Image.asset(avatar, width: 42, height: 42)
            : const Icon(Icons.person, color: Colors.white54),
      ),
      title: Text(
        name,
        style: TextStyle(
          fontFamily: 'RobotoSlab',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isTeam ? AppColors.primary : Colors.white,
        ),
      ),
      subtitle: Text(
        lastMessage,
        style: TextStyle(
          fontFamily: 'RobotoSlab',
          fontSize: 14,
          color: Colors.white.withOpacity(0.6),
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        time,
        style: TextStyle(
          fontFamily: 'RobotoSlab',
          fontSize: 12,
          color: Colors.white.withOpacity(0.4),
        ),
      ),
    );
  }
}
