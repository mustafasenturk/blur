import 'package:flutter/material.dart';

abstract final class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFFFFD700); // Gold
  static const Color primaryLight = Color(0xFFFFE57F);
  static const Color primaryDark = Color(0xFFC5A900);

  // Primary Text Colors (for text on light backgrounds where yellow is hard to see)
  static const Color primaryText = Color(0xFF8B7500); // Dark gold for text
  static const Color primaryOnLight = Color(
    0xFF6B5A00,
  ); // Even darker for small text

  // Secondary Colors (Light Yellow)
  static const Color secondary = Color(0xFFFFEE58); // Lighter Yellow
  static const Color secondaryLight = Color(0xFFFFF59D);
  static const Color secondaryDark = Color(0xFFFBC02D);

  // Accent Colors
  static const Color accent = Color(0xFFFFC107);
  static const Color accentLight = Color(0xFFFFD54F);
  static const Color accentDark = Color(0xFFFFA000);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // Background Colors
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color backgroundDark = Color(0xFF222222);
  static const Color backgroundDarker = Color(0xFF1C1C1C);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color splashBackground = Color.fromARGB(255, 224, 192, 117);
  static const Color buttonBackground = Color(0xFFF2F0E9);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFF81C784);
  static const Color error = Color(0xFFF44336);
  static const Color errorLight = Color(0xFFE57373);
  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFB74D);
  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFF64B5F6);

  // Social Colors
  static const Color like = Color(0xFF4CAF50);
  static const Color superLike = Color(0xFF2196F3);
  static const Color dislike = Color(0xFFF44336);
  static const Color gold = Color(0xFFFFD700);

  // Text Colors
  static const Color textPrimaryLight = Color(0xFF212121);
  static const Color textSecondaryLight = Color(0xFF757575);

  // Overlay Colors
  static const Color overlay = Color(0x80000000);
  static const Color overlayLight = Color(0x40000000);

  // Vibe/Interest Chip Colors
  static const Color vibeOrange = Color(0xFFFFAB91);
  static const Color vibeBrown = Color(0xFFBCAAA4);
  static const Color vibeBlue = Color(0xFF90CAF9);
  static const Color vibePink = Color(0xFFF48FB1);
  static const Color vibeGreen = Color(0xFFA5D6A7);
  static const Color vibePurple = Color(0xFFCE93D8);
}
