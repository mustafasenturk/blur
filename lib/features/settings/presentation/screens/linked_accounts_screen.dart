import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../widgets/gradient_app_bar.dart';

import '../../../../theme/app_colors.dart';

class LinkedAccountsScreen extends StatelessWidget {
  const LinkedAccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Only show Apple on iOS, otherwise show Facebook
    final bool isIOS = Platform.isIOS;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const GradientAppBar(
        title: 'Link Your Account',
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.link,
                  color: Colors.white.withOpacity(0.7),
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Linked accounts',
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Link your Blur account to your Google or ${isIOS ? "Apple" : "Facebook"} account to secure your profile and restore access if you change devices.',
              style: TextStyle(
                fontFamily: 'RobotoSlab',
                fontSize: 14,
                color: Colors.white.withOpacity(0.7),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            _buildProviderRow(
              context,
              'Google',
              'assets/icons/google_logo.svg',
              onTap: () {},
            ),
            const SizedBox(height: 16),
            if (isIOS)
              _buildProviderRow(
                context,
                'Apple ID',
                'assets/icons/apple_logo.svg',
                onTap: () {},
              )
            else
              _buildProviderRow(
                context,
                'Facebook',
                'assets/icons/facebook_logo.svg',
                onTap: () {},
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProviderRow(
    BuildContext context,
    String name,
    String iconPath, {
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.buttonBackground,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(iconPath, width: 24, height: 24),
            const SizedBox(width: 12),
            Text(
              'Link $name',
              style: const TextStyle(
                fontFamily: 'RobotoSlab',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
