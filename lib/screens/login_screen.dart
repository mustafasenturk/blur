import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:video_player/video_player.dart';

import '../theme/app_colors.dart';
import 'main_screen.dart';
import 'registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  late AnimationController _blurController;
  late Animation<double> _blurAnimation;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    _blurController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // Slow unblur over 5 seconds
    );
    _blurAnimation = Tween<double>(
      begin: 8.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _blurController, curve: Curves.easeOut));

    // Start delay then forward
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _blurController.forward();
    });
  }

  Future<void> _initializeVideo() async {
    _controller = VideoPlayerController.asset('assets/videos/intro.mp4')
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
          _controller.play();
          _controller.setLooping(true);
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    _blurController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Set status bar to light (white icons) since video is dark
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Video Background
          if (_isInitialized)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            )
          else
            Container(color: Theme.of(context).scaffoldBackgroundColor),

          // Overlay Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.transparent,
                  Colors.black.withOpacity(0.8),
                ],
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Header Logo & Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),

                  // Spacer to push Text to center
                  const Spacer(flex: 4),

                  // Centered Text
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Ready to',
                        style: TextStyle(
                          fontFamily: 'RobotoSlab',
                          fontSize: 48,
                          height: 1.1,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Animated Blur effect applied to "Unblur?" text
                      AnimatedBuilder(
                        animation: _blurAnimation,
                        builder: (context, child) {
                          return ImageFiltered(
                            imageFilter: ui.ImageFilter.blur(
                              sigmaX: _blurAnimation.value,
                              sigmaY: _blurAnimation.value,
                            ),
                            child: child,
                          );
                        },
                        child: Text(
                          'Unblur?',
                          style: TextStyle(
                            fontFamily: 'RobotoSlab',
                            fontSize: 80,
                            height: 1.1,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(flex: 3),
                  const SizedBox(height: 48),

                  // Buttons
                  Column(
                    children: [
                      // "Already have an account" Button (Top)
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const MainScreen(showRestoreSheet: true),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors
                                .transparent, // "duz background" (scaffold background implied)
                            side: const BorderSide(
                              color: AppColors.buttonBackground,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: const Text(
                            'Already have an account? Log in',
                            style: TextStyle(
                              fontFamily: 'RobotoSlab',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors
                                  .buttonBackground, // Matching the border usually looks best, but white works too.
                              // User didn't specify text color, but "buttonBackground" is likely a light color (cream),
                              // so using it for text ensures visibility on dark background.
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // "Continue" Button (Bottom)
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const RegistrationScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors
                                .buttonBackground, // Requested background
                            foregroundColor: Colors
                                .black, // Presumably dark text for light background
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: const Text(
                            'Continue',
                            style: TextStyle(
                              fontFamily: 'RobotoSlab',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Footer Text
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                    ), // Increased margin
                    child: Column(
                      children: [
                        Text(
                          'Talk to strangers. Connect anonymously.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'RobotoSlab',
                            fontSize: 14,
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
