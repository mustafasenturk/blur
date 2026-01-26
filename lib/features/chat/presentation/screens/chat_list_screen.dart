import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../../theme/app_colors.dart';
import '../../../../widgets/gradient_app_bar.dart';

/// Chat list screen showing all conversations
class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: GradientAppBar(
        title: 'Chats',
        showBackButton: false,
        actions: [
          GestureDetector(
            onTap: () {
              context.push('/match/profile-visitors');
            },
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.only(
                left: 6,
                right: 12,
                top: 6,
                bottom: 6,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1), // Light cream
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(0),
                    decoration: const BoxDecoration(
                      color: AppColors.black,
                      shape: BoxShape.circle,
                    ),
                    child: Lottie.asset(
                      'assets/animations/eye.json',
                      width: 28,
                      height: 28,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    '0',
                    style: TextStyle(
                      fontFamily: 'RobotoSlab',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: GestureDetector(
                onTap: () => context.go('/match'),
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.translate(
                      offset: const Offset(0, 40),
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                        child: Lottie.asset(
                          'assets/animations/send.json',
                          width: 280,
                          height: 200,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Text(
                      'Unblur the Mystery',
                      style: TextStyle(
                        fontFamily: 'RobotoSlab',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 48.0),
                      child: Text(
                        'What are you waiting for? Start chatting\nwith strangers now to unblur their\nprofiles and connect instantly!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'RobotoSlab',
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.6),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
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
        backgroundColor: isTeam ? Colors.grey : Colors.grey[800],
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
