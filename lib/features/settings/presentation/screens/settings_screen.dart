import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../theme/app_colors.dart';
import '../../../../widgets/gradient_app_bar.dart';

/// Settings screen
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Use a map for language codes and display names
  // Key: Code (for simple internal tracking), Value: Display Name (Native)
  final Map<String, String> _languages = {
    'en': 'English',
    'tr': 'Türkçe',
    'es': 'Español',
    'pt': 'Português',
    'ru': 'Русский',
    'fr': 'Français',
    'ar': 'العربية',
    'he': 'עברית',
    'vi': 'Tiếng Việt',
    'id': 'Bahasa Indonesia',
    'ja': '日本語',
    'de': 'Deutsch',
    'zh': '中文',
    'th': 'ไทย',
    'ms': 'Bahasa Melayu',
    'pl': 'Polski',
    'it': 'Italiano',
    'ko': '한국어',
    'hi': 'हिन्दी',
  };

  String _selectedLanguageCode = 'en';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const GradientAppBar(title: 'Settings', centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSection('Account', [
              _buildSettingsTile(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                onTap: () => context.push('/settings/notifications'),
              ),
              _buildSettingsTile(
                icon: Icons.link,
                title: 'Link Your Account',
                onTap: () => context.push('/settings/linked-accounts'),
              ),
            ]),
            _buildSection('App', [
              _buildSettingsTile(
                icon: Icons.language,
                title: 'Language',
                subtitle: _languages[_selectedLanguageCode],
                onTap: _showLanguageSheet,
              ),
              _buildSettingsTile(
                icon: Icons.restore,
                title: 'Restore Purchases',
                onTap: () {},
              ),
            ]),
            _buildSection('Legal', [
              _buildSettingsTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                onTap: () {},
              ),
              _buildSettingsTile(
                icon: Icons.description_outlined,
                title: 'Terms of Service',
                onTap: () {},
              ),
            ]),

            const SizedBox(height: 24),

            // Branding Section
            Image.asset(
              'assets/icons/logo_transparent.png',
              height: 40,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.broken_image,
                  color: Colors.white24,
                  size: 40,
                );
              },
            ),
            const SizedBox(height: 16),
            ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
              child: const Text(
                'Blur',
                style: TextStyle(
                  fontFamily: 'RobotoSlab',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Version
            Text(
              'Version 1.0.0',
              style: TextStyle(
                fontFamily: 'RobotoSlab',
                fontSize: 12,
                color: Colors.white.withOpacity(0.4),
              ),
            ),

            const SizedBox(height: 28),

            // Log Out Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: InkWell(
                onTap: () => _showLogoutDialog(context),
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.buttonBackground,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Log Out',
                    style: TextStyle(
                      fontFamily: 'RobotoSlab',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color:
                          Colors.black, // Contrast for light buttonBackground
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Delete Account Text
            GestureDetector(
              onTap: () => _showDeleteAccountDialog(context),
              child: Text(
                'Delete Account',
                style: TextStyle(
                  fontFamily: 'RobotoSlab',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color:
                      Colors.grey.shade400, // Subtle text as requested? Or red?
                  // "delete account sadece text olacak". Usually delete is red.
                  // I'll make it grey or dark red. Let's stick to grey unless it looks wrong, but danger actions usually red.
                  // But user said "sadece text olacak", emphasizing simplicity.
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: 'RobotoSlab',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.secondary,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'RobotoSlab',
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                fontFamily: 'RobotoSlab',
                fontSize: 14,
                color: Colors.white.withOpacity(0.5),
              ),
            )
          : null,
      trailing: Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.3)),
      onTap: onTap,
    );
  }

  void _showLanguageSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height:
            MediaQuery.of(context).size.height *
            0.7, // Taller for many languages
        decoration: const BoxDecoration(
          color: AppColors.backgroundDark,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Language',
                    style: TextStyle(
                      fontFamily: 'RobotoSlab',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: AppColors.primary),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _languages.length,
                itemBuilder: (context, index) {
                  final code = _languages.keys.elementAt(index);
                  final name = _languages.values.elementAt(index);
                  final isSelected = code == _selectedLanguageCode;

                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedLanguageCode = code;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected
                            ? Border.all(
                                color: AppColors.primary.withOpacity(0.5),
                              )
                            : null,
                      ),
                      child: Row(
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              fontFamily: 'RobotoSlab',
                              fontSize: 16,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: isSelected ? Colors.white : Colors.white70,
                            ),
                          ),
                          const Spacer(),
                          if (isSelected)
                            const Icon(Icons.check, color: AppColors.primary),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Log Out',
          style: TextStyle(fontFamily: 'RobotoSlab', color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to log out?',
          style: TextStyle(fontFamily: 'RobotoSlab', color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(fontFamily: 'RobotoSlab', color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/login');
            },
            child: Text(
              'Log Out',
              style: TextStyle(
                fontFamily: 'RobotoSlab',
                color: Colors.red.shade400,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Account',
          style: TextStyle(fontFamily: 'RobotoSlab', color: Colors.white),
        ),
        content: const Text(
          'All your data will be permanently deleted in 7 days if you do not log in again.',
          style: TextStyle(fontFamily: 'RobotoSlab', color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(fontFamily: 'RobotoSlab', color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/login');
            },
            child: Text(
              'Delete',
              style: TextStyle(
                fontFamily: 'RobotoSlab',
                color: Colors.red.shade400,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
