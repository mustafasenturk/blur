import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import '../theme/app_colors.dart';

class GuiltyPleasureCard extends StatefulWidget {
  final String title;
  final String description;
  final String imagePath;
  final bool showLottie;
  final ValueChanged<bool> onSelected;
  final bool startUnblurred;

  const GuiltyPleasureCard({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
    this.showLottie = false,
    required this.onSelected,
    this.startUnblurred = false,
  });

  @override
  State<GuiltyPleasureCard> createState() => _GuiltyPleasureCardState();
}

class _GuiltyPleasureCardState extends State<GuiltyPleasureCard>
    with AutomaticKeepAliveClientMixin {
  late double _blurSigma;

  @override
  void initState() {
    super.initState();
    _blurSigma = widget.startUnblurred ? 0.0 : 20.0;

    if (widget.showLottie) {
      _showLottie = true;
      // Hide Lottie after 4 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showLottie = false;
          });
        }
      });
    }
  }

  void _handleTap() {
    // If started unblurred (read-only mode essentially), maybe we disable tap?
    // User said "preview" so likely read only. But let's keep interactions minimal if unblurred.
    // If startUnblurred is true, we might want to prevent re-blurring.
    if (widget.startUnblurred) return;

    setState(() {
      if (_blurSigma == 0.0) {
        // If fully unblurred, reset back to blurred (deselect)
        _blurSigma = 20.0;
        widget.onSelected(false);
        HapticFeedback.selectionClick();
      } else {
        // Otherwise, reduce blur
        _blurSigma = (_blurSigma - 5.0).clamp(0.0, 20.0);
        if (_blurSigma == 0.0) {
          widget.onSelected(true);
          HapticFeedback.heavyImpact();
        } else {
          HapticFeedback.selectionClick();
        }
      }
    });
  }

  void _clearBlur() {
    setState(() {
      _blurSigma = 0.0;
      widget.onSelected(true);
    });
    HapticFeedback.heavyImpact();
  }

  bool _showLottie = false;

  @override
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: _handleTap,
      onLongPress: _clearBlur,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent, // Background transparent
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.buttonBackground, // Border button color
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1. The Content (Blurred Together)
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 20.0, end: _blurSigma),
                duration: const Duration(milliseconds: 300),
                builder: (context, sigma, child) {
                  return ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Image
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 80.0, // Increased to move image up
                            top: 8.0, // Reduced to move image up
                            left: 16.0,
                            right: 16.0,
                          ),
                          child: Image.asset(
                            widget.imagePath,
                            fit: BoxFit.contain,
                          ),
                        ),
                        // Text Overlay (No Gradient)
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(12.0),
                            // Removed gradient decoration
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Invisible icon to balance the layout so title stays centered
                                    if (_blurSigma == 0)
                                      const Opacity(
                                        opacity: 0.0,
                                        child: Icon(
                                          CupertinoIcons.checkmark_alt,
                                          size: 20,
                                        ),
                                      ),
                                    if (_blurSigma == 0)
                                      const SizedBox(width: 4),

                                    Flexible(
                                      child: Text(
                                        widget.title,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontFamily: 'RobotoSlab',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: AppColors.primary,
                                        ),
                                        maxLines: 1, // Allow 1 line for title
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),

                                    if (_blurSigma == 0) ...[
                                      const SizedBox(width: 4),
                                      const Icon(
                                        CupertinoIcons
                                            .checkmark_alt, // Simple tick
                                        color: AppColors
                                            .primary, // requested primary
                                        size: 20,
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.description,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: 'RobotoSlab',
                                    fontSize: 14,
                                    color: AppColors
                                        .secondary, // Light yellow description
                                    height: 1.2,
                                  ),
                                  maxLines:
                                      2, // Allow up to 2 lines for description
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // 2. Lottie Animation (Above Blur, Larger)
              if (_showLottie)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Transform.scale(
                      scale: 1.5, // 50% larger
                      child: Lottie.asset(
                        'assets/animations/touch.json',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

              // 3. Close Icon (X Mark) - Only when fully unblurred
            ],
          ),
        ),
      ),
    );
  }
}
