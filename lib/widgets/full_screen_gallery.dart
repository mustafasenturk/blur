import 'dart:ui';
import 'package:blur/core/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blur/core/utils/ui_utils.dart';
import '../../../../theme/app_colors.dart';

class FullScreenGallery extends ConsumerStatefulWidget {
  final List<Map<String, Object>> photos;
  final int initialIndex;
  final bool requirePremium;

  const FullScreenGallery({
    super.key,
    required this.photos,
    required this.initialIndex,
    this.requirePremium = false,
  });

  @override
  ConsumerState<FullScreenGallery> createState() => _FullScreenGalleryState();
}

class _FullScreenGalleryState extends ConsumerState<FullScreenGallery> {
  late PageController _pageController;
  int _currentIndex = 0;
  final Set<int> _revealedIndices = {};

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _revealPhoto(int index) {
    setState(() {
      _revealedIndices.add(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.photos.length,
            itemBuilder: (context, index) {
              final photo = widget.photos[index];
              final isPrivate = photo['isPrivate'] as bool;
              final imagePath = photo['image'] as String;
              final heroTag = photo['heroTag'] as String;
              final isRevealed = _revealedIndices.contains(index);

              return GestureDetector(
                onTap: () {
                  if (isPrivate && !isRevealed) {
                    if (widget.requirePremium) {
                      final isPremium = ref.read(userProvider).isPremium;
                      if (!isPremium) {
                        final isMale = ref.read(userProvider).isMale;
                        showPremiumRequiredDialog(context, isMale: isMale);
                        return;
                      }
                    }
                    _revealPhoto(index);
                  }
                },
                child: InteractiveViewer(
                  child: Center(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (isPrivate && !isRevealed) ...[
                          ImageFiltered(
                            imageFilter: ImageFilter.blur(
                              sigmaX: 15,
                              sigmaY: 15,
                            ),
                            child: Image.asset(imagePath, fit: BoxFit.contain),
                          ),
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/images/close_eye.png',
                                  width: 64,
                                  height: 64,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  "Sensitive Content",
                                  style: TextStyle(
                                    fontFamily: 'RobotoSlab',
                                    color: AppColors.primary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  "Tap to view",
                                  style: TextStyle(
                                    fontFamily: 'RobotoSlab',
                                    color: AppColors.primary,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ] else ...[
                          Hero(
                            tag: heroTag,
                            child: Image.asset(imagePath, fit: BoxFit.contain),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
            onPageChanged: _onPageChanged,
          ),

          // Close Button
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Page Indicators
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.photos.length, (index) {
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.4),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
