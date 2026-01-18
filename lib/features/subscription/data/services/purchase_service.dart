import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// Service for handling RevenueCat purchases
class PurchaseService {
  static bool _isInitialized = false;

  /// RevenueCat API Keys - Replace with your actual keys
  static const String _androidApiKey = 'YOUR_ANDROID_REVENUECAT_API_KEY';
  static const String _iosApiKey = 'YOUR_IOS_REVENUECAT_API_KEY';

  /// Get the appropriate API key for the current platform
  static String get _apiKey {
    if (Platform.isAndroid) return _androidApiKey;
    if (Platform.isIOS) return _iosApiKey;
    throw UnsupportedError('Unsupported platform');
  }

  /// Initialize RevenueCat SDK
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Set log level based on build mode
      await Purchases.setLogLevel(kDebugMode ? LogLevel.debug : LogLevel.info);

      // Configure RevenueCat
      final configuration = PurchasesConfiguration(_apiKey);
      await Purchases.configure(configuration);

      _isInitialized = true;
      debugPrint('RevenueCat initialized successfully');

      // Collect device identifiers for attribution
      await collectDeviceIdentifiers();
    } catch (e) {
      debugPrint('Failed to initialize RevenueCat: $e');
      rethrow;
    }
  }

  /// Collect device identifiers for attribution tracking
  static Future<void> collectDeviceIdentifiers() async {
    try {
      await Purchases.collectDeviceIdentifiers();
      debugPrint('Device identifiers collected for attribution');
    } catch (e) {
      debugPrint('Failed to collect device identifiers: $e');
    }
  }

  /// Login user to RevenueCat
  static Future<void> login(String userId) async {
    try {
      await Purchases.logIn(userId);
      debugPrint('User logged in to RevenueCat: $userId');
      await collectDeviceIdentifiers();
    } catch (e) {
      debugPrint('Failed to login to RevenueCat: $e');
    }
  }

  /// Logout user from RevenueCat
  static Future<void> logout() async {
    try {
      await Purchases.logOut();
      debugPrint('User logged out from RevenueCat');
    } catch (e) {
      debugPrint('Failed to logout from RevenueCat: $e');
    }
  }

  /// Set user email
  static Future<void> setEmail(String email) async {
    try {
      await Purchases.setEmail(email);
    } catch (e) {
      debugPrint('Failed to set user email: $e');
    }
  }

  /// Add a listener for CustomerInfo changes
  static void addCustomerInfoListener(void Function(CustomerInfo) listener) {
    Purchases.addCustomerInfoUpdateListener(listener);
  }

  /// Remove a CustomerInfo listener
  static void removeCustomerInfoListener(void Function(CustomerInfo) listener) {
    Purchases.removeCustomerInfoUpdateListener(listener);
  }

  /// Check if user is premium subscriber
  static Future<bool> isPremiumSubscriber() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      // Check for 'premium' entitlement
      return customerInfo.entitlements.active.containsKey('premium');
    } catch (e) {
      debugPrint('Failed to check premium status: $e');
      return false;
    }
  }

  /// Get offerings from RevenueCat
  static Future<Offerings> getOfferings() async {
    try {
      final offerings = await Purchases.getOfferings();
      debugPrint('Offerings fetched: ${offerings.all.keys.toList()}');
      return offerings;
    } catch (e) {
      debugPrint('Failed to get offerings: $e');
      rethrow;
    }
  }

  /// Get a specific offering by identifier
  static Future<Offering?> getOffering(String identifier) async {
    try {
      final offerings = await Purchases.getOfferings();
      return offerings.getOffering(identifier);
    } catch (e) {
      debugPrint('Failed to get offering $identifier: $e');
      return null;
    }
  }

  /// Purchase a package
  static Future<PurchaseResult> purchasePackage(Package package) async {
    try {
      debugPrint('Purchasing package: ${package.identifier}');
      final customerInfo = await Purchases.purchasePackage(package);

      debugPrint('Purchase successful: ${package.identifier}');
      return PurchaseResult(success: true, customerInfo: customerInfo);
    } on PlatformException catch (e) {
      debugPrint('Purchase cancelled or failed: $e');
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      return PurchaseResult(
        success: false,
        error: e.message ?? e.toString(),
        isCancelled: errorCode == PurchasesErrorCode.purchaseCancelledError,
      );
    } catch (e) {
      debugPrint('Purchase error: $e');
      return PurchaseResult(success: false, error: e.toString());
    }
  }

  /// Get customer info
  static Future<CustomerInfo> getCustomerInfo() async {
    try {
      return await Purchases.getCustomerInfo();
    } catch (e) {
      debugPrint('Failed to get customer info: $e');
      rethrow;
    }
  }

  /// Check if user has active entitlement
  static Future<bool> hasEntitlement(String entitlementId) async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      return customerInfo.entitlements.active.containsKey(entitlementId);
    } catch (e) {
      debugPrint('Failed to check entitlement: $e');
      return false;
    }
  }

  /// Restore purchases
  static Future<CustomerInfo> restorePurchases() async {
    try {
      debugPrint('Restoring purchases...');
      final customerInfo = await Purchases.restorePurchases();
      debugPrint('Purchases restored successfully');
      return customerInfo;
    } catch (e) {
      debugPrint('Failed to restore purchases: $e');
      rethrow;
    }
  }
}

/// Result of a purchase operation
@immutable
class PurchaseResult {
  final bool success;
  final CustomerInfo? customerInfo;
  final String? error;
  final bool isCancelled;

  const PurchaseResult({
    required this.success,
    this.customerInfo,
    this.error,
    this.isCancelled = false,
  });
}
