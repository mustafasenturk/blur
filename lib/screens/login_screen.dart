import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../theme/app_colors.dart';
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

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.inAppWebView)) {
      throw Exception('Could not launch $url');
    }
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
                  // Logo removed as requested

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

                  // Social Login Buttons
                  Column(
                    children: [
                      _SocialButton(
                        assetName: 'assets/icons/google_logo.svg',
                        text: 'Continue with Google',
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegistrationScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 5),
                      _SocialButton(
                        assetName: 'assets/icons/facebook_logo.svg',
                        text: 'Continue with Facebook',
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegistrationScreen(),
                            ),
                          );
                        },
                      ),
                      if (Platform.isIOS) ...[
                        const SizedBox(height: 5),
                        _SocialButton(
                          assetName: 'assets/icons/apple_logo.svg',
                          text: 'Continue with Apple',
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const RegistrationScreen(),
                              ),
                            );
                          },
                        ),
                      ],
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
                          'You have to be at least 18.',
                          style: TextStyle(
                            fontFamily: 'RobotoSlab',
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              fontFamily: 'RobotoSlab',
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.7),
                            ),
                            children: [
                              const TextSpan(
                                text: 'By using app you agree with our \n',
                              ),
                              TextSpan(
                                text: 'Terms & Conditions',
                                style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: AppColors.secondary,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () =>
                                      _launchUrl('https://example.com/terms'),
                              ),
                              const TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: AppColors.secondary,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () =>
                                      _launchUrl('https://example.com/privacy'),
                              ),
                            ],
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

class _SocialButton extends StatelessWidget {
  final String assetName;
  final String text;
  final VoidCallback onTap;

  const _SocialButton({
    required this.assetName,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          // Paper/Cream background color to match the 'cutout' aesthetic
          color: AppColors.buttonBackground,
          borderRadius: BorderRadius.circular(
            4,
          ), // Shallower radius for a 'cut' look
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(4),
            overlayColor: MaterialStateProperty.all(
              Colors.black.withOpacity(0.1),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  // Icon - Tinted Black
                  SvgPicture.asset(assetName, width: 24, height: 24),

                  // Centered Text
                  Expanded(
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'RobotoSlab',
                        fontSize: 16,
                        fontWeight:
                            FontWeight.w600, // Slightly lighter than bold
                        color: Colors.black,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),

                  // Invisible Spacer to perfectly center the text
                  const SizedBox(width: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
