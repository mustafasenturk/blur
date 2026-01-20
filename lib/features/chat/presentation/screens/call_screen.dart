import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:blur/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class CallScreen extends StatefulWidget {
  final bool isIncoming;
  final String username;
  final String? avatarPath;

  const CallScreen({
    super.key,
    required this.isIncoming,
    required this.username,
    this.avatarPath,
  });

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _dotController;
  int _dotCount = 0;

  @override
  void initState() {
    super.initState();
    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _dotController.addListener(() {
      final newDotCount = (_dotController.value * 4).floor() % 4; // 0, 1, 2, 3
      if (newDotCount != _dotCount) {
        setState(() {
          _dotCount = newDotCount;
        });
      }
    });
  }

  @override
  void dispose() {
    _dotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Blurred Background Image
          Image.asset(
            widget.avatarPath ?? 'assets/images/male_avatar.png',
            fit: BoxFit.cover,
          ),
          // Dark Overlay with Blur
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(
              color: AppColors.backgroundDark.withValues(alpha: 0.8),
            ),
          ),

          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),

                // Avatar (No Animation, Static)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage(
                      widget.avatarPath ?? 'assets/images/male_avatar.png',
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Name
                Text(
                  widget.username,
                  style: const TextStyle(
                    fontFamily: 'RobotoSlab',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 12),

                // Status Text
                Text(
                  "${widget.isIncoming ? "Incoming Call" : "Calling"}${'.' * _dotCount}",
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.7),
                    letterSpacing: 1.2,
                  ),
                ),

                const Spacer(flex: 3),

                // Action Buttons
                Padding(
                  padding: const EdgeInsets.only(bottom: 48.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (widget.isIncoming) ...[
                        // Decline Button
                        _buildCallButton(
                          icon: Icons.call_end,
                          color: Colors.red,
                          label: "Decline",
                          onTap: () => context.pop(),
                        ),

                        // Accept Button
                        _buildCallButton(
                          icon: Icons.call,
                          color: Colors.green,
                          label: "Accept",
                          onTap: () {
                            // Implement accept logic -> maybe go to active call state
                          },
                        ),
                      ] else ...[
                        // End Call Button (Outgoing)
                        _buildCallButton(
                          icon: Icons.call_end,
                          color: Colors.red,
                          label: "End",
                          onTap: () => context.pop(),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 32),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'RobotoSlab',
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
