import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

import '../../theme/app_colors.dart';

/// Main scaffold with bottom navigation for the app shell
/// Uses GoRouter's StatefulShellRoute navigation shell
/// Implements AnimatedBottomNavigationBar
class MainScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainScaffold({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    // Define the icon assets for each tab
    final iconAssets = [
      (
        passive: 'assets/images/match_passive.png',
        active: 'assets/images/match_active.png',
      ),
      (
        passive: 'assets/images/profile_passive.png',
        active: 'assets/images/profile_active.png',
      ), // Friends
      (
        passive: 'assets/images/search_passive.png',
        active: 'assets/images/search_active.png',
      ),
      (
        passive: 'assets/images/chat_passive.png',
        active: 'assets/images/chat_active.png',
      ),
      (
        passive: 'assets/images/profile_passive.png',
        active: 'assets/images/profile_active.png',
      ), // Profile
    ];

    return Scaffold(
      extendBody: true, // Allow body to extend behind the navigation bar
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: navigationShell,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Discovery (search) which is the middle item in logic
          // But based on the requested order: Match, Friends, Search, Chat, Profile
          navigationShell.goBranch(2, initialLocation: true);
        },
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        child: Image.asset(
          iconAssets[2].active, // Search icon
          height: 32,
          fit: BoxFit.contain,
          // color: Colors.black, // Dark icon on bright button
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: 4, // 4 items excluding the center one
        tabBuilder: (int index, bool isActive) {
          // Map index to strict order skipping the center (Search/Discovery)
          // 0: Match -> index 0
          // 1: Friends -> index 1
          // Search/Discovery is center (FAB), skipped here
          // 2: Chat -> index 3
          // 3: Profile -> index 4

          final actualIndex = index >= 2 ? index + 1 : index;
          final asset = navigationShell.currentIndex == actualIndex
              ? iconAssets[actualIndex].active
              : iconAssets[actualIndex].passive;

          final height = actualIndex == 0 ? 24.0 : 28.0;

          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                asset,
                height: height,
                fit: BoxFit.contain,
                color: null,
              ),
            ],
          );
        },
        activeIndex: navigationShell.currentIndex == 2
            ? -1
            : (navigationShell.currentIndex > 2
                  ? navigationShell.currentIndex - 1
                  : navigationShell.currentIndex),
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        backgroundColor: AppColors.backgroundDarker,
        onTap: (index) {
          // Remap tap index to shell branch index
          // 0 -> Match (0)
          // 1 -> Friends (1)
          // GAP (Center FAB) -> Discovery (2)
          // 2 -> Chat (3)
          // 3 -> Profile (4)
          final branchIndex = index >= 2 ? index + 1 : index;
          _onTap(context, branchIndex);
        },
        // Styling matches request
        splashColor: AppColors.primary.withOpacity(0.2),
        splashSpeedInMilliseconds: 300,
        height: 60,
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
