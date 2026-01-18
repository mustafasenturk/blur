import 'package:flutter/material.dart';

/// Extension methods for BuildContext
extension ContextExtensions on BuildContext {
  /// Get theme
  ThemeData get theme => Theme.of(this);

  /// Get color scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Get text theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Get media query
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Get screen size
  Size get screenSize => MediaQuery.sizeOf(this);

  /// Get screen width
  double get screenWidth => screenSize.width;

  /// Get screen height
  double get screenHeight => screenSize.height;

  /// Get device padding (safe area)
  EdgeInsets get padding => MediaQuery.paddingOf(this);

  /// Get view insets (keyboard, etc.)
  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);

  /// Get view padding
  EdgeInsets get viewPadding => MediaQuery.viewPaddingOf(this);

  /// Check if keyboard is visible
  bool get isKeyboardVisible => viewInsets.bottom > 0;

  /// Get bottom padding including keyboard
  double get bottomOffset => viewInsets.bottom > 0 ? viewInsets.bottom : padding.bottom;

  /// Pop navigator
  void pop<T>([T? result]) => Navigator.of(this).pop(result);

  /// Check if can pop
  bool get canPop => Navigator.of(this).canPop();

  /// Pop until first
  void popUntilFirst() => Navigator.of(this).popUntil((route) => route.isFirst);

  /// Show snackbar
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : null,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Show error snackbar
  void showErrorSnackBar(String message) => showSnackBar(message, isError: true);

  /// Show success snackbar
  void showSuccessSnackBar(String message) => showSnackBar(message);

  /// Unfocus current focus
  void unfocus() => FocusScope.of(this).unfocus();
}
