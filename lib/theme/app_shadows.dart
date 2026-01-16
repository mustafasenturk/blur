import 'package:flutter/material.dart';

/// Centralized shadow definitions for consistent elevation across the app.
abstract final class AppShadows {
  /// Standard card shadow - used for containers, cards, and sections
  /// Previously duplicated across edit_profile_screen, profile_screen,
  /// settings_screen, chat_detail_screen
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x0D000000), // 5% opacity black
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
  ];

  /// Elevated shadow - for floating elements like FABs, dialogs
  static const List<BoxShadow> elevated = [
    BoxShadow(
      color: Color(0x1A000000), // 10% opacity black
      blurRadius: 20,
      offset: Offset(0, 8),
    ),
  ];

  /// Subtle shadow - for slight elevation on hover states
  static const List<BoxShadow> subtle = [
    BoxShadow(
      color: Color(0x08000000), // 3% opacity black
      blurRadius: 6,
      offset: Offset(0, 2),
    ),
  ];

  /// Match dialog shadow with primary color glow
  static List<BoxShadow> matchGlow(Color primaryColor) => [
    BoxShadow(
      color: primaryColor.withValues(alpha: 0.2),
      blurRadius: 30,
      offset: const Offset(0, 10),
    ),
  ];

  /// Bottom navigation shadow
  static const List<BoxShadow> bottomNav = [
    BoxShadow(
      color: Color(0x14000000), // 8% opacity black
      blurRadius: 16,
      offset: Offset(0, -4),
    ),
  ];

  /// Input field focus shadow
  static List<BoxShadow> inputFocus(Color focusColor) => [
    BoxShadow(
      color: focusColor.withValues(alpha: 0.15),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
}
