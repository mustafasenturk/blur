import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../theme/app_colors.dart';
import '../../../../widgets/gradient_app_bar.dart';
import '../../../../widgets/animated_gradient_button.dart';
import '../../../../core/providers/user_provider.dart';

class ProfileVisitorsScreen extends ConsumerStatefulWidget {
  const ProfileVisitorsScreen({super.key});

  @override
  ConsumerState<ProfileVisitorsScreen> createState() =>
      _ProfileVisitorsScreenState();
}

class _ProfileVisitorsScreenState extends ConsumerState<ProfileVisitorsScreen> {
  // Mock data with 5 visitors
  static const List<Map<String, dynamic>> _mockVisitors = [
    {
      'id': 'v1',
      'name': 'Elif',
      'age': '24',
      'location': 'Istanbul',
      'image': 'assets/images/female.png',
      'isBlur': true,
      'gender': 'Female',
    },
    {
      'id': 'v2',
      'name': 'Can',
      'age': '27',
      'location': 'Izmir',
      'image': 'assets/images/male.png',
      'isBlur': false,
      'gender': 'Male',
    },
    {
      'id': 'v3',
      'name': 'Zeynep',
      'age': '22',
      'location': 'Ankara',
      'image': 'assets/images/female.png',
      'isBlur': false,
      'gender': 'Female',
    },
    {
      'id': 'v4',
      'name': 'Murat',
      'age': '29',
      'location': 'Bursa',
      'image': 'assets/images/male.png',
      'isBlur': true,
      'gender': 'Male',
    },
    {
      'id': 'v5',
      'name': 'Ayşe',
      'age': '25',
      'location': 'Antalya',
      'image': 'assets/images/female.png',
      'isBlur': true,
      'gender': 'Female',
    },
    {
      'id': 'v5',
      'name': 'Ayşe',
      'age': '25',
      'location': 'Antalya',
      'image': 'assets/images/female.png',
      'isBlur': true,
      'gender': 'Female',
    },
    {
      'id': 'v5',
      'name': 'Ayşe',
      'age': '25',
      'location': 'Antalya',
      'image': 'assets/images/female.png',
      'isBlur': true,
      'gender': 'Female',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const GradientAppBar(
        title: 'Profile Visitors',
        showBackButton: true,
      ),
      body: _mockVisitors.isEmpty
          ? _buildEmptyState(context)
          : _buildVisitorsGrid(context),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Transform.translate(
              offset: const Offset(0, 0),
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                child: Lottie.asset(
                  'assets/animations/empty_visitor.json',
                  width: 250,
                  height: 180,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Who Viewed Your Profile?',
            style: TextStyle(
              fontFamily: 'RobotoSlab',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              'No one has visited your profile yet.\nStay active and chat with more people\nto get noticed!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'RobotoSlab',
                fontSize: 14,
                color: Colors.white.withOpacity(0.6),
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 120), // Push content up
        ],
      ),
    );
  }

  Widget _buildVisitorsGrid(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75, // Adjust based on card height
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _mockVisitors.length,
      itemBuilder: (context, index) {
        final visitor = _mockVisitors[index];
        return _buildVisitorCard(context, visitor);
      },
    );
  }

  Widget _buildVisitorCard(BuildContext context, Map<String, dynamic> visitor) {
    final isBlur = visitor['isBlur'] == true;

    return GestureDetector(
      onTap: () {
        if (isBlur) {
          _showPremiumModal();
        } else {
          context.pushNamed(
            'user_profile',
            queryParameters: {
              'username': visitor['name'],
              'userId': visitor['id'],
            },
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image
            ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: isBlur ? 15.0 : 0.0,
                sigmaY: isBlur ? 15.0 : 0.0,
              ),
              child: Image.asset(
                visitor['image'],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[800],
                    child: const Icon(
                      Icons.person,
                      color: Colors.white24,
                      size: 40,
                    ),
                  );
                },
              ),
            ),

            // Overlay Gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87],
                  stops: [0.6, 1.0],
                ),
              ),
            ),

            // Info
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${visitor['name']}, ',
                          style: const TextStyle(
                            fontFamily: 'RobotoSlab',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        TextSpan(
                          text: visitor['age'],
                          style: const TextStyle(
                            fontFamily: 'RobotoSlab',
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: Colors.white70,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          visitor['location'],
                          style: TextStyle(
                            fontFamily: 'RobotoSlab',
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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
                  'You need to be a premium member to see who viewed your profile.',
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
}
