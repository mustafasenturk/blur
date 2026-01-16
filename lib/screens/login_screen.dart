import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../theme/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
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
      backgroundColor: Colors.black,
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
            Container(color: Colors.black),

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
                        style: GoogleFonts.outfit(
                          fontSize: 48,
                          height: 1.1,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Blur effect applied to "Unblur?" text
                      ImageFiltered(
                        imageFilter: ui.ImageFilter.blur(
                          sigmaX: 8.0,
                          sigmaY: 8.0,
                        ),
                        child: Text(
                          'Unblur?',
                          style: GoogleFonts.outfit(
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
                          // Handle Google Login
                        },
                      ),
                      const SizedBox(height: 5),
                      _SocialButton(
                        assetName: 'assets/icons/facebook_logo.svg',
                        text: 'Continue with Facebook',
                        onTap: () {
                          // Handle Facebook Login
                        },
                      ),
                      if (Platform.isIOS) ...[
                        const SizedBox(height: 5),
                        _SocialButton(
                          assetName: 'assets/icons/apple_logo.svg',
                          text: 'Continue with Apple',
                          onTap: () {
                            // Handle Apple Login
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
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: GoogleFonts.inter(
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
    // Determine if we need to tint the icon (e.g. for Apple logo on dark background)
    final bool isApple = assetName.contains('apple');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 60, // Reduced height
        decoration: BoxDecoration(
          // Black Glassmorphism background
          color: Colors.black.withOpacity(0.4),
          borderRadius: BorderRadius.circular(16),
          // Subtle lighter border for definition
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            highlightColor: Colors.white.withOpacity(0.1),
            splashColor: Colors.white.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  // Icon - Increased size
                  SvgPicture.asset(
                    assetName,
                    width: 32,
                    height: 32,
                    // Tint Apple logo white, keep others original
                    colorFilter: isApple
                        ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
                        : null,
                  ),

                  // Centered Text
                  Expanded(
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: 18, // Increased font size
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),

                  // Invisible Spacer to perfectly center the text (matches icon size)
                  const SizedBox(width: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
