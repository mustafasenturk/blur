import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blur/core/utils/ui_utils.dart';
import 'package:blur/core/providers/user_provider.dart';
import 'package:blur/theme/app_colors.dart';
import 'package:blur/widgets/gradient_app_bar.dart';
import 'package:blur/widgets/animated_gradient_button.dart';

class FriendsScreen extends ConsumerStatefulWidget {
  const FriendsScreen({super.key});

  @override
  ConsumerState<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends ConsumerState<FriendsScreen> {
  // Mock Data for Friend Requests
  // Mock Data for Friend Requests
  final List<Map<String, dynamic>> _friendRequests = [
    {
      'id': '101',
      'name': 'Ayşe Demir',
      'age': '24',
      'gender': 'Female',
      'image': 'assets/images/female_avatar.png',
      'location': 'Istanbul',
      'isBlurred': false,
    },
    {
      'id': '102',
      'name': 'Mehmet Yılmaz',
      'age': '29',
      'gender': 'Male',
      'image': 'assets/images/male_avatar.png',
      'location': 'Izmir',
      'isBlurred': true,
    },
    {
      'id': '103',
      'name': 'Selin Kaya',
      'age': '22',
      'gender': 'Female',
      'image': 'assets/images/female_avatar.png',
      'location': 'Ankara',
      'isBlurred': false,
    },
    {
      'id': '104',
      'name': 'Gizem Can',
      'age': '26',
      'gender': 'Female',
      'image': 'assets/images/female_avatar.png',
      'location': 'Bursa',
      'isBlurred': true,
    },
  ];

  // Mock Data for My Friends
  final List<Map<String, dynamic>> _myFriends = [
    {
      'id': '201',
      'name': 'Burak Can',
      'age': '27',
      'gender': 'Male',
      'image': 'assets/images/male_avatar.png',
      'location': 'Antalya',
    },
    {
      'id': '202',
      'name': 'Elif Yıldız',
      'age': '25',
      'gender': 'Female',
      'image': 'assets/images/female_avatar.png',
      'location': 'Istanbul',
    },
    {
      'id': '203',
      'name': 'Cem Dağ',
      'age': '30',
      'gender': 'Male',
      'image': 'assets/images/male_avatar.png',
      'location': 'Bursa',
    },
    {
      'id': '204',
      'name': 'Zeynep Su',
      'age': '23',
      'gender': 'Female',
      'image': 'assets/images/female_avatar.png',
      'location': 'Izmir',
    },
    {
      'id': '205',
      'name': 'Murat Kara',
      'age': '28',
      'gender': 'Male',
      'image': 'assets/images/male_avatar.png',
      'location': 'Ankara',
    },
  ];

  void _acceptRequest(int index) {
    setState(() {
      final user = _friendRequests[index];
      _friendRequests.removeAt(index);
      _myFriends.insert(0, user); // Add to top of friends list
    });
    showTopToast(context, 'Friend request accepted!', icon: Icons.check_circle);
  }

  void _rejectRequest(int index) {
    setState(() {
      _friendRequests.removeAt(index);
    });
    showTopToast(
      context,
      'Friend request rejected',
      icon: Icons.close,
      backgroundColor: Colors.grey,
    );
  }

  void _removeFriend(int index) {
    _showConfirmationDialog(
      title: 'Remove Friend',
      content:
          'Are you sure you want to remove ${_myFriends[index]['name']} from your friends?',
      confirmText: 'Remove',
      confirmColor: Colors.red,
      onConfirm: () {
        setState(() {
          _myFriends.removeAt(index);
        });
        showTopToast(
          context,
          'Friend removed',
          icon: Icons.person_remove,
          backgroundColor: Colors.red,
        );
      },
    );
  }

  void _showConfirmationDialog({
    required String title,
    required String content,
    required String confirmText,
    required Color confirmColor,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundDark,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'RobotoSlab',
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          content,
          style: const TextStyle(
            color: Colors.white70,
            fontFamily: 'RobotoSlab',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70, fontFamily: 'RobotoSlab'),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              onConfirm();
            },
            child: Text(
              confirmText,
              style: TextStyle(
                color: confirmColor,
                fontWeight: FontWeight.bold,
                fontFamily: 'RobotoSlab',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPremiumModal() {
    final isMale = ref.read(userProvider).isMale;
    final imagePath = isMale
        ? 'assets/images/premium_needed_man.png'
        : 'assets/images/premium_needed_woman.png';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.backgroundDark,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Close Button
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, color: Colors.white54),
                  ),
                ),
                const SizedBox(height: 8),

                // Premium Image
                Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: Image.asset(imagePath, fit: BoxFit.contain),
                ),
                const SizedBox(height: 24),

                // Title
                const Text(
                  'Premium Required',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 12),

                // Description
                const Text(
                  'You need to be a premium member to view and accept friend requests.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    fontSize: 14,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),

                // Unblur Button
                AnimatedGradientButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.push('/paywall');
                  },
                  borderRadius: BorderRadius.circular(12),
                  height: 56,
                  child: const Text(
                    'UNBLUR',
                    style: TextStyle(
                      fontFamily: 'RobotoSlab',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToProfile(Map<String, dynamic> user) {
    // If it's a blurred request, show premium modal instead
    if (user['isBlurred'] == true) {
      _showPremiumModal();
      return;
    }

    context.pushNamed(
      'user_profile',
      queryParameters: {'username': user['name'], 'userId': user['id']},
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: GradientAppBar(
          title: 'Friends',
          centerTitle: false,
          showBackButton: false,
          bottom: const TabBar(
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(width: 3.0, color: AppColors.primary),
              insets: EdgeInsets.symmetric(horizontal: 16.0),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            labelStyle: TextStyle(
              fontFamily: 'RobotoSlab',
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            tabs: [
              Tab(text: "Friend Requests"),
              Tab(text: "My Friends"),
            ],
          ),
        ),
        body: TabBarView(children: [_buildRequestsTab(), _buildFriendsTab()]),
      ),
    );
  }

  Widget _buildRequestsTab() {
    if (_friendRequests.isEmpty) {
      return _buildEmptyState('No pending friend requests');
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _friendRequests.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final user = _friendRequests[index];
        final isBlurred = user['isBlurred'] == true;

        return _buildUserCard(
          user: user,
          actions: [
            _buildActionButton(
              icon: Icons.close,
              iconColor: Colors.red.shade400, // Reject color
              onTap: () =>
                  isBlurred ? _showPremiumModal() : _rejectRequest(index),
            ),
            const SizedBox(width: 12),
            _buildActionButton(
              icon: Icons.check,
              iconColor: Colors.green.shade400, // Accept color
              onTap: () =>
                  isBlurred ? _showPremiumModal() : _acceptRequest(index),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFriendsTab() {
    if (_myFriends.isEmpty) {
      return _buildEmptyState('You haven\'t added any friends yet');
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _myFriends.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final user = _myFriends[index];
        return _buildUserCard(
          user: user,
          actions: [
            _buildActionButton(
              icon: Icons.person_remove_outlined,
              // No iconColor needed, defaults to grey which matches base
              onTap: () => _removeFriend(index),
            ),
          ],
        );
      },
    );
  }

  Widget _buildUserCard({
    required Map<String, dynamic> user,
    required List<Widget> actions,
  }) {
    final isBlurred = user['isBlurred'] == true;

    return GestureDetector(
      onTap: () => _navigateToProfile(user),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            // Avatar
            Stack(
              children: [
                ImageFiltered(
                  imageFilter: ImageFilter.blur(
                    sigmaX: isBlurred ? 8.0 : 0.0,
                    sigmaY: isBlurred ? 8.0 : 0.0,
                  ),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        user['image']!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[800],
                          child: const Icon(
                            Icons.person,
                            color: Colors.white54,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            // Info
            Expanded(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(
                  sigmaX: isBlurred ? 5.0 : 0.0,
                  sigmaY: isBlurred ? 5.0 : 0.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${user['name']}, ${user['age']}',
                      style: const TextStyle(
                        fontFamily: 'RobotoSlab',
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user['gender'] ?? 'Unknown',
                      style: const TextStyle(
                        fontFamily: 'RobotoSlab',
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Actions
            ...actions,
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    // Default style (greyish)
    final baseColor = Colors.grey.shade400;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: baseColor.withValues(alpha: 0.1),
          shape: BoxShape.circle,
          border: Border.all(color: baseColor.withValues(alpha: 0.5)),
        ),
        child: Icon(icon, color: iconColor ?? baseColor, size: 20),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: GestureDetector(
        onTap: () => context.go('/match'),
        behavior: HitTestBehavior.opaque,
        child: Transform.translate(
          offset: const Offset(0, -40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
                child: Lottie.asset(
                  'assets/animations/friends.json',
                  width: 280,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
              const Text(
                'Make New Connections',
                style: TextStyle(
                  fontFamily: 'RobotoSlab',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48.0),
                child: Text(
                  'You haven\'t added any friends yet.\nStart talking to strangers now to make friend\nrequests and expand your circle!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.6),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
