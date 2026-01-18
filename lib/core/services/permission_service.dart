import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/logger.dart';

/// Service for handling runtime permissions
class PermissionService {
  PermissionService._();
  static final PermissionService instance = PermissionService._();

  final _log = AppLogger.forClass(PermissionService);

  /// Request camera permission
  Future<bool> requestCamera() async {
    return _requestPermission(Permission.camera, 'Camera');
  }

  /// Request photo library permission
  Future<bool> requestPhotos() async {
    if (Platform.isIOS) {
      return _requestPermission(Permission.photos, 'Photos');
    } else {
      // Android 13+ uses granular permissions
      final status = await Permission.photos.status;
      if (status.isGranted) return true;
      
      // Try READ_MEDIA_IMAGES first (Android 13+)
      final result = await Permission.photos.request();
      if (result.isGranted) return true;
      
      // Fallback to READ_EXTERNAL_STORAGE for older Android
      return _requestPermission(Permission.storage, 'Storage');
    }
  }

  /// Request microphone permission
  Future<bool> requestMicrophone() async {
    return _requestPermission(Permission.microphone, 'Microphone');
  }

  /// Request location permission
  Future<bool> requestLocation() async {
    return _requestPermission(Permission.locationWhenInUse, 'Location');
  }

  /// Request notification permission (Android 13+)
  Future<bool> requestNotifications() async {
    if (Platform.isAndroid) {
      return _requestPermission(Permission.notification, 'Notifications');
    }
    // iOS handles notification permission differently (through UNUserNotificationCenter)
    return true;
  }

  /// Request contacts permission
  Future<bool> requestContacts() async {
    return _requestPermission(Permission.contacts, 'Contacts');
  }

  /// Check if camera permission is granted
  Future<bool> hasCameraPermission() => Permission.camera.isGranted;

  /// Check if photos permission is granted
  Future<bool> hasPhotosPermission() => Permission.photos.isGranted;

  /// Check if microphone permission is granted
  Future<bool> hasMicrophonePermission() => Permission.microphone.isGranted;

  /// Check if location permission is granted
  Future<bool> hasLocationPermission() => Permission.locationWhenInUse.isGranted;

  /// Check if notifications permission is granted
  Future<bool> hasNotificationPermission() => Permission.notification.isGranted;

  /// Generic permission request handler
  Future<bool> _requestPermission(Permission permission, String name) async {
    _log.i('Requesting $name permission...');

    final status = await permission.status;

    if (status.isGranted) {
      _log.s('$name permission already granted');
      return true;
    }

    if (status.isPermanentlyDenied) {
      _log.w('$name permission permanently denied, opening settings...');
      await openAppSettings();
      return false;
    }

    final result = await permission.request();

    if (result.isGranted) {
      _log.s('$name permission granted');
      return true;
    }

    _log.w('$name permission denied');
    return false;
  }

  /// Show permission explanation dialog
  Future<bool> showPermissionDialog(
    BuildContext context, {
    required String permission,
    required String explanation,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$permission Permission Required'),
        content: Text(explanation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Allow'),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
