import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const Center(
      child: Text("Tab 1", style: TextStyle(color: Colors.white)),
    ),
    const Center(
      child: Text("Tab 2", style: TextStyle(color: Colors.white)),
    ),
    const Center(
      child: Text("Tab 3", style: TextStyle(color: Colors.white)),
    ),
    const Center(
      child: Text("Tab 4", style: TextStyle(color: Colors.white)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.black, // Dark background
        selectedItemColor: AppColors.primary, // Selected icon color
        unselectedItemColor: Colors.white54, // Unselected icon color
        type: BottomNavigationBarType.fixed, // Fixed items (no shifting)
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: '',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }
}
