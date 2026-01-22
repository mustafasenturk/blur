part of 'app_router.dart';

/// Route names for type-safe navigation
abstract class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';

  // Tab routes
  static const String match = '/match';
  static const String discovery = '/discovery';
  static const String friends = '/friends';
  static const String chats = '/chats';
  static const String profile = '/profile';

  // Overlay routes
  static const String editProfile = '/edit-profile';
  static const String settings = '/settings';
  static const String chatDetail = '/chat/:odaId';
}

/// Extension for easy navigation
extension GoRouterExtension on GoRouter {
  void goToLogin() => go(AppRoutes.login);
  void goToRegister() => go(AppRoutes.register);
  void goToMatch() => go(AppRoutes.match);
  void goToDiscovery() => go(AppRoutes.discovery);
  void goToChats() => go(AppRoutes.chats);
  void goToProfile() => go(AppRoutes.profile);
  void goToSettings() => go(AppRoutes.settings);
}
