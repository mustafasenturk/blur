import 'package:flutter/material.dart';
import 'package:blur/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:blur/widgets/animated_gradient_button.dart';

void showTopToast(
  BuildContext context,
  String message, {
  Color? backgroundColor,
  IconData? icon,
}) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, -50 * (1 - value)),
              child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: backgroundColor ?? AppColors.buttonBackground,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: Colors.black, size: 24),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'RobotoSlab',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);

  Future.delayed(const Duration(seconds: 3), () {
    if (overlayEntry.mounted) {
      overlayEntry.remove();
    }
  });
}

void showPremiumRequiredDialog(
  BuildContext context, {
  required bool isMale,
  String? message,
}) {
  final imagePath = isMale
      ? 'assets/images/premium_needed_man.png'
      : 'assets/images/premium_needed_woman.png';

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.backgroundDark,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Close Button
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: Colors.white54),
                ),
              ),
              const SizedBox(height: 8),

              // Premium Image
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                child: Image.asset(imagePath, fit: BoxFit.contain),
              ),
              const SizedBox(height: 24),

              // Title
              const Text(
                'Premium Required',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'RobotoSlab',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 12),

              // Description
              Text(
                message ??
                    'You need to be a premium member to perform this action. Upgrade now to unlock all features.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'RobotoSlab',
                  fontSize: 14,
                  color: Colors.white70,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // Unblur/Upgrade Button (Reusing styling but generic text if needed, or 'UNBLUR')
              // The user liked the "gorselli ve butonlu" style.
              // I will not import AnimatedGradientButton here to avoid circular dep if it's not simple,
              // but I should try to match the look. The user requested "FriendsScreen" style exactly.
              // So I should import AnimatedGradientButton.
              AnimatedGradientButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.push('/paywall');
                },
                borderRadius: BorderRadius.circular(12),
                height: 56,
                child: const Text(
                  'UNBLUR',
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
