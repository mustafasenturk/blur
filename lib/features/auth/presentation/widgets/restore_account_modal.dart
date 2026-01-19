import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../theme/app_colors.dart';

class RestoreAccountModal extends StatelessWidget {
  const RestoreAccountModal({super.key});

  @override
  Widget build(BuildContext context) {
    // Only show Apple Sign In on iOS
    final bool showApple = Platform.isIOS;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.backgroundDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Stack(
            alignment: Alignment.center,
            children: [
              const SizedBox(
                width: double.infinity,
                child: Text(
                  'Restore account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.close,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            'Simply sign in with your linked social account to instantly recover your profile and settings.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'RobotoSlab',
              fontSize: 14,
              color: Colors.white70,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),

          // Google Button
          _SocialButton(
            text: 'Sign In with Google',
            iconPath: 'assets/icons/google_logo.svg',
            onTap: () {
              // TODO: Implement Google Sign In
            },
          ),
          const SizedBox(height: 16),

          // Facebook Button
          _SocialButton(
            text: 'Sign In with Facebook',
            iconPath: 'assets/icons/facebook_logo.svg',
            onTap: () {
              // TODO: Implement Facebook Sign In
            },
          ),

          // Apple Button (iOS only)
          if (showApple) ...[
            const SizedBox(height: 16),
            _SocialButton(
              text: 'Sign In with Apple',
              iconPath:
                  'assets/icons/apple_logo.svg', // Ensure this svg exists or use Icons.apple if svg fails? User provided svg path in prompt.
              // Note: Usually Apple logo is monochrome. If SVG is black, it might be invisible on dark button.
              // Usually assets/icons/apple_logo.svg is provided by user.
              onTap: () {
                // TODO: Implement Apple Sign In
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String text;
  final String iconPath;
  final VoidCallback onTap;

  const _SocialButton({
    required this.text,
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
              text,
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
