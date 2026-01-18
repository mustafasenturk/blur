import 'package:flutter/foundation.dart';
import 'dart:developer' as developer;

/// Simple logger utility for the app
class AppLogger {
  AppLogger._(this._tag);

  final String _tag;

  /// Create a logger for a specific class
  factory AppLogger.forClass(Type type) => AppLogger._(type.toString());

  /// Create a logger with a custom tag
  factory AppLogger.withTag(String tag) => AppLogger._(tag);

  /// Log debug message (only in debug mode)
  void d(String message) {
    if (kDebugMode) {
      developer.log('💬 $message', name: _tag);
    }
  }

  /// Log info message
  void i(String message) {
    if (kDebugMode) {
      developer.log('ℹ️ $message', name: _tag);
    }
  }

  /// Log warning message
  void w(String message) {
    if (kDebugMode) {
      developer.log('⚠️ $message', name: _tag);
    }
  }

  /// Log error message
  void e(String message, [Object? error, StackTrace? stackTrace]) {
    developer.log(
      '❌ $message',
      name: _tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log success message
  void s(String message) {
    if (kDebugMode) {
      developer.log('✅ $message', name: _tag);
    }
  }
}

/// Global logger instance for quick logging
final logger = AppLogger.withTag('Blur');
