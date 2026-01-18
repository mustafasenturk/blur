import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../data/services/purchase_service.dart';

/// Offering identifiers from RevenueCat
/// These should match the offering IDs in your RevenueCat dashboard
abstract class OfferingIds {
  static const String premium = 'premium';
}

/// Package identifiers for subscriptions
/// These should match the package IDs in your RevenueCat dashboard
abstract class PackageIds {
  static const String weekly = r'$rc_weekly';
  static const String monthly = r'$rc_monthly';
  static const String quarterly = r'$rc_three_month';
}

/// State that holds all cached offerings
@immutable
class OfferingsState {
  final bool isLoading;
  final bool isInitialized;
  final String? error;
  final Offerings? offerings;

  const OfferingsState({
    this.isLoading = false,
    this.isInitialized = false,
    this.error,
    this.offerings,
  });

  OfferingsState copyWith({
    bool? isLoading,
    bool? isInitialized,
    String? error,
    Offerings? offerings,
  }) {
    return OfferingsState(
      isLoading: isLoading ?? this.isLoading,
      isInitialized: isInitialized ?? this.isInitialized,
      error: error,
      offerings: offerings ?? this.offerings,
    );
  }

  /// Get a specific offering by identifier
  Offering? getOffering(String identifier) {
    return offerings?.getOffering(identifier);
  }

  /// Get premium offering
  Offering? get premium => getOffering(OfferingIds.premium);

  /// Get available packages (weekly, monthly, quarterly)
  List<Package> get availablePackages => premium?.availablePackages ?? [];

  /// Get weekly package
  Package? get weeklyPackage {
    return availablePackages
        .where(
          (p) =>
              p.packageType == PackageType.weekly ||
              p.identifier == PackageIds.weekly,
        )
        .firstOrNull;
  }

  /// Get monthly package
  Package? get monthlyPackage {
    return availablePackages
        .where(
          (p) =>
              p.packageType == PackageType.monthly ||
              p.identifier == PackageIds.monthly,
        )
        .firstOrNull;
  }

  /// Get quarterly package
  Package? get quarterlyPackage {
    return availablePackages
        .where(
          (p) =>
              p.packageType == PackageType.threeMonth ||
              p.identifier == PackageIds.quarterly,
        )
        .firstOrNull;
  }
}

/// Central provider for all RevenueCat offerings
class OfferingsNotifier extends StateNotifier<OfferingsState> {
  OfferingsNotifier() : super(const OfferingsState());

  /// Initialize and fetch all offerings
  Future<void> initialize() async {
    if (state.isInitialized || state.isLoading) return;

    state = state.copyWith(isLoading: true);

    try {
      final offerings = await PurchaseService.getOfferings();

      debugPrint('Offerings initialized successfully');
      debugPrint('Available offerings: ${offerings.all.keys.toList()}');

      // Debug: Log each offering and its packages
      for (final entry in offerings.all.entries) {
        final offering = entry.value;
        debugPrint(
          'Offering "${entry.key}": ${offering.availablePackages.length} packages',
        );
        for (final pkg in offering.availablePackages) {
          debugPrint(
            '  - Package: ${pkg.identifier}, ${pkg.storeProduct.priceString}',
          );
        }
      }

      state = state.copyWith(
        isLoading: false,
        isInitialized: true,
        offerings: offerings,
        error: null,
      );
    } catch (e) {
      debugPrint('Failed to initialize offerings: $e');
      state = state.copyWith(
        isLoading: false,
        isInitialized: false,
        error: e.toString(),
      );
    }
  }

  /// Refresh offerings (for pull-to-refresh or retry)
  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final offerings = await PurchaseService.getOfferings();

      debugPrint('Offerings refreshed successfully');

      state = state.copyWith(
        isLoading: false,
        isInitialized: true,
        offerings: offerings,
      );
    } catch (e) {
      debugPrint('Failed to refresh offerings: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

/// Provider for offerings state
final offeringsProvider =
    StateNotifierProvider<OfferingsNotifier, OfferingsState>((ref) {
      return OfferingsNotifier();
    });

/// Provider for premium packages list (weekly, monthly, quarterly)
final premiumPackagesProvider = Provider<List<Package>>((ref) {
  final state = ref.watch(offeringsProvider);
  return state.availablePackages;
});

/// Provider for weekly package
final weeklyPackageProvider = Provider<Package?>((ref) {
  final state = ref.watch(offeringsProvider);
  return state.weeklyPackage;
});

/// Provider for monthly package
final monthlyPackageProvider = Provider<Package?>((ref) {
  final state = ref.watch(offeringsProvider);
  return state.monthlyPackage;
});

/// Provider for quarterly package
final quarterlyPackageProvider = Provider<Package?>((ref) {
  final state = ref.watch(offeringsProvider);
  return state.quarterlyPackage;
});
