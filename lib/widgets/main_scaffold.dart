import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_colors.dart';

/// Main scaffold with bottom navigation for the app shell
/// Uses GoRouter's StatefulShellRoute navigation shell
class MainScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainScaffold({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.buttonBackground, width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: navigationShell.currentIndex,
          onTap: (index) => _onTap(context, index),
          backgroundColor: AppColors.backgroundDark,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.white54,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/match_passive.png',
                height: 24,
                fit: BoxFit.contain,
              ),
              activeIcon: Image.asset(
                'assets/images/match_active.png',
                height: 24,
                fit: BoxFit.contain,
              ),
              label: 'Match',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/search_passive.png',
                height: 36,
                fit: BoxFit.contain,
              ),
              activeIcon: Image.asset(
                'assets/images/search_active.png',
                height: 36,
                fit: BoxFit.contain,
              ),
              label: 'Discovery',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/chat_passive.png',
                height: 36,
                fit: BoxFit.contain,
              ),
              activeIcon: Image.asset(
                'assets/images/chat_active.png',
                height: 36,
                fit: BoxFit.contain,
              ),
              label: 'Chats',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/profile_passive.png',
                height: 36,
                fit: BoxFit.contain,
              ),
              activeIcon: Image.asset(
                'assets/images/profile_active.png',
                height: 36,
                fit: BoxFit.contain,
              ),
              label: 'Profile',
            ),
          ],
        ),
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
