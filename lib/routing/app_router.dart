import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/auth/presentation/screens/register_flow/register_flow_screen.dart';
import '../features/discovery/presentation/screens/discovery_screen.dart';
import '../features/chat/presentation/screens/chat_list_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
import '../features/profile/presentation/screens/edit_profile_screen.dart';
import '../features/settings/presentation/screens/settings_screen.dart';
import '../features/match/presentation/screens/match_screen.dart';
import '../features/settings/presentation/screens/linked_accounts_screen.dart';
import '../features/settings/presentation/screens/notifications_screen.dart';
import '../features/profile/presentation/screens/preview_profile_screen.dart';
import '../features/subscription/presentation/screens/paywall_screen.dart';
import '../features/chat/presentation/screens/chat_detail_screen.dart';
import '../features/profile/presentation/screens/other_user_profile_screen.dart';
import '../features/chat/presentation/screens/call_screen.dart';
import '../features/friends/presentation/screens/friends_screen.dart';
import '../features/match/presentation/screens/profile_visitors_screen.dart';
import '../widgets/main_scaffold.dart';

part 'routes.dart';

/// Navigator keys for shell branches
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _matchNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'match');
final _discoveryNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'discovery',
);
final _friendsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'friends');
final _chatsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'chats');
final _profileNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'profile');

/// Custom page transition builder
CustomTransitionPage<T> _buildTransitionPage<T>({
  required LocalKey key,
  required Widget child,
  Duration duration = const Duration(milliseconds: 350),
  Duration reverseDuration = const Duration(milliseconds: 300),
}) {
  return CustomTransitionPage<T>(
    key: key,
    transitionDuration: duration,
    reverseTransitionDuration: reverseDuration,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.04, 0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        ),
      );
    },
  );
}

/// Modal page transition (Bottom to Top)
CustomTransitionPage<T> _buildModalTransitionPage<T>({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: key,
    transitionDuration: const Duration(milliseconds: 400),
    reverseTransitionDuration: const Duration(milliseconds: 350),
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.fastOutSlowIn,
      );
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(curvedAnimation),
        child: child,
      );
    },
  );
}

/// App router provider with StatefulShellRoute for bottom navigation
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      // Splash screen
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),

      // Login
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => _buildTransitionPage(
          key: state.pageKey,
          child: const LoginScreen(),
        ),
      ),

      // Registration flow
      GoRoute(
        path: '/register',
        pageBuilder: (context, state) => _buildTransitionPage(
          key: state.pageKey,
          child: const RegisterFlowScreen(),
        ),
      ),

      // Main app shell with bottom navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScaffold(navigationShell: navigationShell);
        },
        branches: [
          // Match Tab
          StatefulShellBranch(
            navigatorKey: _matchNavigatorKey,
            routes: [
              GoRoute(
                path: '/match',
                pageBuilder: (context, state) => _buildTransitionPage(
                  key: state.pageKey,
                  child: const MatchScreen(),
                ),
                routes: [
                  GoRoute(
                    path: 'profile-visitors',
                    parentNavigatorKey: _rootNavigatorKey, // Hide bottom bar
                    pageBuilder: (context, state) => _buildTransitionPage(
                      key: state.pageKey,
                      child: const ProfileVisitorsScreen(),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Friends Tab
          StatefulShellBranch(
            navigatorKey: _friendsNavigatorKey,
            routes: [
              GoRoute(
                path: '/friends',
                pageBuilder: (context, state) => _buildTransitionPage(
                  key: state.pageKey,
                  child: const FriendsScreen(),
                ),
              ),
            ],
          ),

          // Discovery Tab
          StatefulShellBranch(
            navigatorKey: _discoveryNavigatorKey,
            routes: [
              GoRoute(
                path: '/discovery',
                pageBuilder: (context, state) => _buildTransitionPage(
                  key: state.pageKey,
                  child: const DiscoveryScreen(),
                ),
              ),
            ],
          ),

          // Chats Tab
          StatefulShellBranch(
            navigatorKey: _chatsNavigatorKey,
            routes: [
              GoRoute(
                path: '/chats',
                pageBuilder: (context, state) => _buildTransitionPage(
                  key: state.pageKey,
                  child: const ChatListScreen(),
                ),
              ),
            ],
          ),

          // Profile Tab
          StatefulShellBranch(
            navigatorKey: _profileNavigatorKey,
            routes: [
              GoRoute(
                path: '/profile',
                pageBuilder: (context, state) => _buildTransitionPage(
                  key: state.pageKey,
                  child: const ProfileScreen(),
                ),
              ),
            ],
          ),
        ],
      ),

      // Settings (pushed on top, overlays bottom nav)
      GoRoute(
        path: '/settings',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => _buildTransitionPage(
          key: state.pageKey,
          child: const SettingsScreen(),
        ),
        routes: [
          GoRoute(
            path: 'notifications',
            pageBuilder: (context, state) => _buildTransitionPage(
              key: state.pageKey,
              child: const NotificationsScreen(),
            ),
          ),
          GoRoute(
            path: 'linked-accounts',
            pageBuilder: (context, state) => _buildTransitionPage(
              key: state.pageKey,
              child: const LinkedAccountsScreen(),
            ),
          ),
        ],
      ),

      // Edit Profile (pushed on top, overlays bottom nav)
      GoRoute(
        path: '/edit-profile',
        name: 'edit_profile',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => _buildTransitionPage(
          key: state.pageKey,
          child: const EditProfileScreen(),
        ),
      ),

      // Preview Profile (pushed on top)
      GoRoute(
        path: '/preview-profile',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => _buildTransitionPage(
          key: state.pageKey,
          child: const PreviewProfileScreen(),
        ),
      ),

      // Chat Detail (pushed on top, overlays bottom nav)
      GoRoute(
        path: '/chat/:odaId',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final odaId = state.pathParameters['odaId'] ?? '';
          return _buildTransitionPage(
            key: state.pageKey,
            child: ChatDetailScreen(odaId: odaId),
          );
        },
      ),

      // Paywall (Bottom to Top Modal)
      GoRoute(
        path: '/paywall',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => _buildModalTransitionPage(
          key: state.pageKey,
          child: const PaywallScreen(),
        ),
      ),

      // Other User Profile (pushed on top)
      GoRoute(
        path: '/user-profile',
        name: 'user_profile',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final username = state.uri.queryParameters['username'] ?? 'User';
          final userId = state.uri.queryParameters['userId'];
          return _buildTransitionPage(
            key: state.pageKey,
            child: OtherUserProfileScreen(username: username, userId: userId),
          );
        },
      ),

      // Call Screen
      GoRoute(
        path: '/call',
        name: 'call_screen',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final isIncoming = state.uri.queryParameters['isIncoming'] == 'true';
          final username = state.uri.queryParameters['username'] ?? 'User';
          final isVideo = state.uri.queryParameters['isVideo'] == 'true';
          return _buildTransitionPage(
            key: state.pageKey,
            child: CallScreen(
              isIncoming: isIncoming,
              username: username,
              isVideo: isVideo,
            ),
          );
        },
      ),
    ],

    // Error page
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text('Page not found: ${state.uri.toString()}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/match'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});
