import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/subscription/data/services/purchase_service.dart';
import 'routing/app_router.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize RevenueCat
  await _initializeRevenueCat();

  runApp(const ProviderScope(child: BlurApp()));
}

/// Initialize RevenueCat SDK
Future<void> _initializeRevenueCat() async {
  try {
    await PurchaseService.initialize();
    debugPrint('RevenueCat initialized');
  } catch (e) {
    debugPrint('Failed to initialize RevenueCat: $e');
    // Continue app startup even if RevenueCat fails
  }
}

class BlurApp extends ConsumerWidget {
  const BlurApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'Blur',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
