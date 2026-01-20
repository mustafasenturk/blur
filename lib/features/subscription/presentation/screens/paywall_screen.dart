import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

import '../../../../theme/app_colors.dart';

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _videoController;
  late AnimationController _animationController;
  late Animation<double> _blurAnimation;
  late Animation<double> _logoOpacityAnimation;
  bool _isVideoInitialized = false;
  bool _showCloseButton = false;
  int _selectedPackageIndex = 0; // Default to Weekly (Best Seller)

  @override
  void initState() {
    super.initState();
    _initializeVideo();

    // Animation Controller for 11 seconds (duration of video)
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 11),
    );

    // Blur from 0 to 10 over the course of the video
    // Starting slightly later to let the user see the clear video first
    _blurAnimation = Tween<double>(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
      ),
    );

    // Logo fades in slowly and smoothly
    // Starts appearing around 20% mark, fully visible by 60%
    _logoOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.6, curve: Curves.easeIn),
      ),
    );

    _animationController.forward();

    // Show close button after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showCloseButton = true;
        });
      }
    });
  }

  Future<void> _initializeVideo() async {
    _videoController = VideoPlayerController.asset('assets/videos/premium.mp4');
    try {
      await _videoController.initialize();
      _videoController.setLooping(true);
      _videoController.play();
      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Error initializing video: $e');
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Using AppColors.backgroundDark as requested
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          // 1. Video Background with Blur Effect
          if (_isVideoInitialized)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height * 0.55,
              child: AnimatedBuilder(
                animation: _blurAnimation,
                builder: (context, child) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      FittedBox(
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          width: _videoController.value.size.width,
                          height: _videoController.value.size.height,
                          child: VideoPlayer(_videoController),
                        ),
                      ),
                      // Apply Blur using BackdropFilter
                      if (_blurAnimation.value > 0)
                        BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: _blurAnimation.value,
                            sigmaY: _blurAnimation.value,
                          ),
                          child: Container(
                            color: Colors.black.withOpacity(
                              (_blurAnimation.value / 20).clamp(0.0, 0.5),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),

          // 2. Gradient Overlay (AppColors.backgroundDark)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.55,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.backgroundDark,
                    AppColors.backgroundDark.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),

          // 3. Logo Overlay (Animated Opacity via Controller)
          Positioned(
            top: MediaQuery.of(context).padding.top + 25,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _logoOpacityAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _logoOpacityAnimation.value,
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/icons/icon.icon/Assets/logo_transparent.png',
                        height: 60, // Smaller logo
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ImageFiltered(
                            imageFilter: ImageFilter.blur(
                              sigmaX: 1.5,
                              sigmaY: 1.5,
                            ),
                            child: const Text(
                              'Unblur',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Your Desires',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // 4. Main Layout (Content + Button)
          Positioned.fill(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Reduced height to make first package overlap video properly
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.22,
                        ),
                        // Subscription Packages
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            children: [
                              _buildSubscriptionOption(
                                index: 0,
                                title: 'Weekly',
                                priceAmount: '\$4.99',
                                pricePeriod: '/ week',
                                tag: 'BESTSELLER',
                                isTagDark: true,
                              ),
                              const SizedBox(height: 12),
                              _buildSubscriptionOption(
                                index: 1,
                                title: 'Monthly',
                                priceAmount: '\$9.99',
                                pricePeriod: '/ month',
                                discount: '50% OFF',
                                tag: null,
                              ),
                              const SizedBox(height: 12),
                              _buildSubscriptionOption(
                                index: 2,
                                title: '3 Months',
                                priceAmount: '\$19.99',
                                pricePeriod: '/ 3 months',
                                discount: '67% OFF',
                                tag: 'CHEAPEST',
                                isTagDark: false,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Features List
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFeatureItem(
                                imagePath: 'assets/images/desire_matching.png',
                                title: 'Desire Matching',
                                subtitle:
                                    'Connect with matches who share your specific desires.',
                              ),
                              _buildFeatureItem(
                                imagePath: 'assets/images/search_priority.png',
                                title: 'Search Priority',
                                subtitle:
                                    'Be seen first and find your match faster than everyone else.',
                              ),
                              _buildFeatureItem(
                                imagePath: 'assets/images/filter_by_gender.png',
                                title: 'Filter by Gender',
                                subtitle:
                                    'Control exactly who you see by filtering your matches.',
                              ),
                              _buildFeatureItem(
                                imagePath: 'assets/images/private_calls.png',
                                title: 'Private Calls',
                                subtitle:
                                    'Take the connection deeper with secure voice calls.',
                              ),
                              // Add some bottom padding to scrolling content if needed so last item isn't flush
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Button Area
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.backgroundDark,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.backgroundDark,
                        blurRadius: 40,
                        offset: Offset(0, -40),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 0,
                        bottom: 16,
                        left: 16,
                        right: 16,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () {
                                // Handle purchase logic
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.buttonBackground,
                                foregroundColor: Colors.black,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child: Text(
                                _getButtonText(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: TextButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                            ),
                            child: const Text(
                              'No, thanks',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // Removd SizedBox(height: 4)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Open Privacy Policy
                                },
                                child: Text(
                                  'Privacy Policy',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                    fontSize: 10,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              Text(
                                '  &  ',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 10,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Open Terms of Service
                                },
                                child: Text(
                                  'Terms of Service',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                    fontSize: 10,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 5. Delayed Close Button
          Positioned(
            top: MediaQuery.of(context).padding.top,
            right: 16,
            child: AnimatedOpacity(
              opacity: _showCloseButton ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.close,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getButtonText() {
    switch (_selectedPackageIndex) {
      case 0:
        return 'UNBLUR WEEKLY \$4.99';
      case 1:
        return 'UNBLUR MONTHLY \$9.99';
      case 2:
        return 'UNBLUR 3 MONTHS \$19.99';
      default:
        return 'CONTINUE';
    }
  }

  Widget _buildSubscriptionOption({
    required int index,
    required String title,
    required String priceAmount,
    required String pricePeriod,
    String? tag,
    String? discount,
    bool isTagDark = true,
  }) {
    final isSelected = _selectedPackageIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPackageIndex = index;
        });
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.black.withOpacity(0.6)
                  : Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(4), // Radius 4
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: priceAmount,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: ' $pricePeriod',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      discount ?? ' ',
                      style: TextStyle(
                        color: discount != null
                            ? AppColors.primary
                            : Colors.transparent,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (tag != null)
            Positioned(
              top: -9,
              right: 12, // Margin right 12
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: isTagDark
                      ? AppColors.buttonBackground
                      : AppColors.primary,
                  borderRadius: BorderRadius.circular(4), // Radius 4
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    color: isTagDark ? Colors.black : Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    required String imagePath,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            width: 42,
            height: 42,
            color: AppColors.primary,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
