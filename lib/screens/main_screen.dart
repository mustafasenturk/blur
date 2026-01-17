import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

import 'dart:io';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import '../data/guilty_pleasures_data.dart';
import '../widgets/gradient_app_bar.dart';

class MainScreen extends StatefulWidget {
  final bool showRestoreSheet;

  const MainScreen({super.key, this.showRestoreSheet = false});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  // State for Match Tab Filters
  String _selectedGenderFilter = 'Everyone'; // Male, Everyone, Female
  Set<String> _selectedInterestFilters = {};

  @override
  void initState() {
    super.initState();

    if (widget.showRestoreSheet) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showRestoreBottomSheet();
      });
    }
  }

  Widget _buildMatchTab() {
    return Column(
      children: [
        // Body
        Expanded(
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Lottie Animation
              SizedBox(
                height: 320,
                child: Lottie.asset(
                  'assets/animations/mask.json',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),

              // Chat Stranger Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implement chat logic
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonBackground,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text(
                      'Chat Stranger',
                      style: TextStyle(
                        fontFamily: 'RobotoSlab',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Subtext
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  'Connect anonymously. Chat securely.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    fontSize: 14,
                    color: AppColors.secondary,
                    height: 1.4,
                  ),
                ),
              ),

              const Spacer(flex: 3),

              // Filters Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gender Filter
                    const Text(
                      "Choose a partner's gender",
                      style: TextStyle(
                        fontFamily: 'RobotoSlab',
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Row(
                        children: [
                          _buildGenderOption(
                            'Male',
                            iconPath: 'assets/images/coin.png',
                            iconLeft: true,
                            borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(8),
                            ),
                          ),
                          Container(width: 1, color: Colors.white12),
                          _buildGenderOption('Everyone'),
                          Container(width: 1, color: Colors.white12),
                          _buildGenderOption(
                            'Female',
                            iconPath: 'assets/images/coin.png',
                            iconLeft: false,
                            borderRadius: const BorderRadius.horizontal(
                              right: Radius.circular(8),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Interest Filter
                    const Text(
                      "Choose Interest",
                      style: TextStyle(
                        fontFamily: 'RobotoSlab',
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: _showInterestFilterSheet,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                _selectedInterestFilters.isEmpty
                                    ? 'Any'
                                    : _selectedInterestFilters.join(', '),
                                style: const TextStyle(
                                  fontFamily: 'RobotoSlab',
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white54,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChatsTab() {
    return ListView(
      children: [
        // TEAM BLUR Message
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.white12, width: 0.5),
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: CircleAvatar(
              radius: 28,
              backgroundColor: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/icons/logo_transparent.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            title: const Text(
              'Blur Team',
              style: TextStyle(
                fontFamily: 'RobotoSlab',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            subtitle: const Padding(
              padding: EdgeInsets.only(top: 4.0),
              child: Text(
                '🌟 Welcome to Blur! 🌟',
                style: TextStyle(
                  fontFamily: 'RobotoSlab',
                  fontSize: 14,
                  color: Colors.white70,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            trailing: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '6 hours ago',
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
            onTap: () {
              // TODO: Open Team Chat
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGenderOption(
    String label, {
    String? iconPath,
    bool iconLeft = true,
    BorderRadiusGeometry? borderRadius,
  }) {
    bool isSelected = _selectedGenderFilter == label;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedGenderFilter = label;
          });
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? AppColors.buttonBackground : Colors.transparent,
            borderRadius: borderRadius,
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, // Keep content centered
            children: [
              if (iconPath != null && iconLeft) ...[
                Image.asset(iconPath, width: 16, height: 16),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'RobotoSlab',
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? Colors.black : Colors.white70,
                ),
              ),
              if (iconPath != null && !iconLeft) ...[
                const SizedBox(width: 6),
                Image.asset(iconPath, width: 16, height: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showInterestFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: AppColors.backgroundDark,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            children: [
              // Handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Balancing spacer (approx width of Done button)
                    const SizedBox(width: 50),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Filter by Interest',
                          style: TextStyle(
                            fontFamily: 'RobotoSlab',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            // Commit changes to main screen (automatically happens via setState)
                            setState(() {});
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Done',
                            style: TextStyle(
                              fontFamily: 'RobotoSlab',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.white10, height: 1),

              // List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: guiltyPleasuresData.length,
                  itemBuilder: (context, index) {
                    final item = guiltyPleasuresData[index];
                    final isSelected = _selectedInterestFilters.contains(
                      item['title'],
                    );
                    return _buildInterestItem(
                      item['title']!,
                      item['image'],
                      isSelected,
                      setSheetState,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInterestItem(
    String title,
    String? imagePath,
    bool isSelected,
    StateSetter setSheetState,
  ) {
    return GestureDetector(
      onTap: () {
        setSheetState(() {
          if (_selectedInterestFilters.contains(title)) {
            _selectedInterestFilters.remove(title);
          } else {
            _selectedInterestFilters.add(title);
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.buttonBackground.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.buttonBackground : Colors.white10,
            width: 1.5, // Fixed width to prevent jumping
          ),
        ),
        child: Row(
          children: [
            if (imagePath != null) ...[
              Image.asset(imagePath, width: 40, height: 40),
              const SizedBox(width: 14),
            ] else
              const SizedBox(width: 54), // Offset for no image
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'RobotoSlab',
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? AppColors.buttonBackground : Colors.white,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check, color: AppColors.buttonBackground),
          ],
        ),
      ),
    );
  }

  void _showRestoreBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with Close Icon
            Stack(
              children: [
                const Center(
                  child: Text(
                    'Restore account',
                    style: TextStyle(
                      fontFamily: 'RobotoSlab',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Access your existing profile by signing in with your linked Google or Apple ID.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'RobotoSlab',
                fontSize: 15,
                color: Colors.white70,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            _buildSocialButton(
              'assets/icons/google_logo.svg',
              'Sign In with Google',
              () {},
            ),
            const SizedBox(height: 16),
            _buildSocialButton(
              'assets/icons/facebook_logo.svg',
              'Sign In with Facebook',
              () {},
            ),
            if (Platform.isIOS) ...[
              const SizedBox(height: 16),
              _buildSocialButton(
                'assets/icons/apple_logo.svg',
                'Sign In with Apple ID',
                () {},
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(String asset, String text, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonBackground, // Cream/Paper color
          foregroundColor: Colors.black, // Dark ripple/text
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4), // Shallower radius
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon - standard size
            SvgPicture.asset(asset, width: 24, height: 24),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                fontFamily: 'RobotoSlab',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Dark text
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return _buildMatchTab();
      case 1:
        return const Center(
          child: Text("Tab 2", style: TextStyle(color: Colors.white)),
        );
      case 2:
        return _buildChatsTab();
      case 3:
        return const Center(
          child: Text("Tab 4", style: TextStyle(color: Colors.white)),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  PreferredSizeWidget? _buildAppBar() {
    switch (_currentIndex) {
      case 0:
        return GradientAppBar(
          titleWidget: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/icons/logo_transparent.png',
                height: 30,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 12),
              const Text(
                'Blur: Anonymous Chat',
                style: TextStyle(
                  fontFamily: 'RobotoSlab',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          centerTitle: false,
        );
      case 1:
        return const GradientAppBar(title: 'Discovery', centerTitle: false);
      case 2:
        return const GradientAppBar(title: 'Chats', centerTitle: false);
      case 3:
        return const GradientAppBar(title: 'Profile', centerTitle: false);
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: _buildCurrentScreen(),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.buttonBackground, width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: AppColors.backgroundDark, // Dark background
          selectedItemColor: AppColors.primary, // Selected icon color
          unselectedItemColor: Colors.white54, // Unselected icon color
          type: BottomNavigationBarType.fixed, // Fixed items (no shifting)
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Image.asset(
                  'assets/images/match_passive.png',
                  height: 24,
                  fit: BoxFit.contain,
                ),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Image.asset(
                  'assets/images/match_active.png',
                  height: 24,
                  fit: BoxFit.contain,
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Image.asset(
                  'assets/images/search_passive.png',
                  height: 36,
                  fit: BoxFit.contain,
                ),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Image.asset(
                  'assets/images/search_active.png',
                  height: 36,
                  fit: BoxFit.contain,
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Image.asset(
                  'assets/images/chat_passive.png',
                  height: 36,
                  fit: BoxFit.contain,
                ),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Image.asset(
                  'assets/images/chat_active.png',
                  height: 36,
                  fit: BoxFit.contain,
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Image.asset(
                  'assets/images/profile_passive.png',
                  height: 36,
                  fit: BoxFit.contain,
                ),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Image.asset(
                  'assets/images/profile_active.png',
                  height: 36,
                  fit: BoxFit.contain,
                ),
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
