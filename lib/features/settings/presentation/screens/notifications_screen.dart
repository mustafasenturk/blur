import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../../../widgets/gradient_app_bar.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _chatMessages = true;
  bool _appUpdates = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const GradientAppBar(title: 'Notifications', centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSwitchTile(
              'Chat messages',
              _chatMessages,
              (val) => setState(() => _chatMessages = val),
            ),
            const SizedBox(height: 16),
            _buildSwitchTile(
              'App updates',
              _appUpdates,
              (val) => setState(() => _appUpdates = val),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'RobotoSlab',
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        activeThumbColor: AppColors.primary,
        inactiveThumbColor: Colors.white,
        inactiveTrackColor: AppColors.backgroundDark,
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
