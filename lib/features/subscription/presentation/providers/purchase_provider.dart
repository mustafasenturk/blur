import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../data/services/purchase_service.dart';
import 'offerings_provider.dart';

/// State for purchase operations
@immutable
class PurchaseState {
  final bool isLoading;
  final String? error;
  final List<Package> packages;
  final int selectedPackageIndex;
  final bool isPurchasing;

  const PurchaseState({
    this.isLoading = false,
    this.error,
    this.packages = const [],
    this.selectedPackageIndex = 1, // Default to monthly (middle option)
    this.isPurchasing = false,
  });

  PurchaseState copyWith({
    bool? isLoading,
    String? error,
    List<Package>? packages,
    int? selectedPackageIndex,
    bool? isPurchasing,
  }) {
    return PurchaseState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      packages: packages ?? this.packages,
      selectedPackageIndex: selectedPackageIndex ?? this.selectedPackageIndex,
      isPurchasing: isPurchasing ?? this.isPurchasing,
    );
  }

  Package? get selectedPackage {
    if (packages.isEmpty) return null;
    if (selectedPackageIndex >= packages.length) return packages.first;
    return packages[selectedPackageIndex];
  }

  /// Get weekly package
  Package? get weeklyPackage {
    return packages
        .where((p) => p.packageType == PackageType.weekly)
        .firstOrNull;
  }

  /// Get monthly package
  Package? get monthlyPackage {
    return packages
        .where((p) => p.packageType == PackageType.monthly)
        .firstOrNull;
  }

  /// Get quarterly package
  Package? get quarterlyPackage {
    return packages
        .where((p) => p.packageType == PackageType.threeMonth)
        .firstOrNull;
  }
}

/// Notifier for Premium subscription purchase
class PremiumPurchaseNotifier extends StateNotifier<PurchaseState> {
  final Ref _ref;

  PremiumPurchaseNotifier(this._ref) : super(const PurchaseState()) {
    _init();
  }

  void _init() {
    final offeringsState = _ref.read(offeringsProvider);

    // If offerings are not initialized yet, trigger initialization
    if (!offeringsState.isInitialized && !offeringsState.isLoading) {
      Future.microtask(() {
        _ref.read(offeringsProvider.notifier).initialize();
      });
    }

    // Listen to offerings changes
    _ref.listen<OfferingsState>(offeringsProvider, (previous, next) {
      state = state.copyWith(
        isLoading: next.isLoading || !next.isInitialized,
        error: next.error,
        packages: next.availablePackages,
        selectedPackageIndex: _getRecommendedIndex(next.availablePackages),
      );
    });

    // Set initial state
    state = state.copyWith(
      isLoading: offeringsState.isLoading || !offeringsState.isInitialized,
      error: offeringsState.error,
      packages: offeringsState.availablePackages,
      selectedPackageIndex: _getRecommendedIndex(
        offeringsState.availablePackages,
      ),
    );
  }

  void selectPackage(int index) {
    state = state.copyWith(selectedPackageIndex: index);
  }

  void selectPackageByType(PackageType type) {
    final index = state.packages.indexWhere((p) => p.packageType == type);
    if (index >= 0) {
      state = state.copyWith(selectedPackageIndex: index);
    }
  }

  Future<PurchaseResult> purchase() async {
    final package = state.selectedPackage;
    if (package == null) {
      return const PurchaseResult(success: false, error: 'No package selected');
    }

    state = state.copyWith(isPurchasing: true);

    try {
      final result = await PurchaseService.purchasePackage(package);
      state = state.copyWith(isPurchasing: false);
      return result;
    } catch (e) {
      debugPrint('Purchase failed: $e');
      state = state.copyWith(isPurchasing: false);
      return PurchaseResult(success: false, error: e.toString());
    }
  }

  Future<PurchaseResult> purchaseWeekly() async {
    final package = state.weeklyPackage;
    if (package == null) {
      return const PurchaseResult(
        success: false,
        error: 'Weekly package not found',
      );
    }
    state = state.copyWith(isPurchasing: true);
    try {
      final result = await PurchaseService.purchasePackage(package);
      state = state.copyWith(isPurchasing: false);
      return result;
    } catch (e) {
      state = state.copyWith(isPurchasing: false);
      return PurchaseResult(success: false, error: e.toString());
    }
  }

  Future<PurchaseResult> purchaseMonthly() async {
    final package = state.monthlyPackage;
    if (package == null) {
      return const PurchaseResult(
        success: false,
        error: 'Monthly package not found',
      );
    }
    state = state.copyWith(isPurchasing: true);
    try {
      final result = await PurchaseService.purchasePackage(package);
      state = state.copyWith(isPurchasing: false);
      return result;
    } catch (e) {
      state = state.copyWith(isPurchasing: false);
      return PurchaseResult(success: false, error: e.toString());
    }
  }

  Future<PurchaseResult> purchaseQuarterly() async {
    final package = state.quarterlyPackage;
    if (package == null) {
      return const PurchaseResult(
        success: false,
        error: 'Quarterly package not found',
      );
    }
    state = state.copyWith(isPurchasing: true);
    try {
      final result = await PurchaseService.purchasePackage(package);
      state = state.copyWith(isPurchasing: false);
      return result;
    } catch (e) {
      state = state.copyWith(isPurchasing: false);
      return PurchaseResult(success: false, error: e.toString());
    }
  }

  int _getRecommendedIndex(List<Package> packages) {
    if (packages.isEmpty) return 0;
    // Recommend quarterly (best value) if available
    if (packages.length >= 3) return 2;
    if (packages.length >= 2) return 1;
    return 0;
  }
}

/// Provider for Premium subscription purchase
final premiumPurchaseProvider =
    StateNotifierProvider<PremiumPurchaseNotifier, PurchaseState>((ref) {
      return PremiumPurchaseNotifier(ref);
    });

/// Provider for checking if user is premium
final isPremiumProvider = FutureProvider<bool>((ref) async {
  return await PurchaseService.isPremiumSubscriber();
});

/// Provider for restoring purchases
final restorePurchasesProvider = FutureProvider.autoDispose<CustomerInfo>((
  ref,
) async {
  return await PurchaseService.restorePurchases();
});
