import 'dart:async';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blur/core/providers/user_provider.dart';
import 'package:blur/core/utils/ui_utils.dart';
import 'package:blur/theme/app_colors.dart';
import 'package:flutter/services.dart';

import 'package:blur/widgets/dashed_border_painter.dart';
import 'package:blur/widgets/gradient_app_bar.dart';
import 'package:blur/widgets/full_screen_image_viewer.dart';
import '../../../../widgets/full_screen_gallery.dart';
import 'package:go_router/go_router.dart';

/// Other User Profile screen - View another user's profile with actions
class OtherUserProfileScreen extends StatefulWidget {
  final String username;
  final String? userId;

  const OtherUserProfileScreen({
    super.key,
    required this.username,
    this.userId,
  });

  @override
  State<OtherUserProfileScreen> createState() => _OtherUserProfileScreenState();
}

class _OtherUserProfileScreenState extends State<OtherUserProfileScreen> {
  // Mock data to match ProfileScreen defaults
  final bool isMale = true; // Could be passed in or fetched
  final String _biography =
      "I'm a Gallant Explorer looking for new adventures. I love hiking, photography, and good coffee.";
  final String _audioPath = 'mock_audio';
  bool _isPlaying = false;
  int _playbackSeconds = 0;
  final int _totalDurationSeconds = 15;
  Timer? _playbackTimer;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        _stopPlayback();
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _playbackTimer?.cancel();
    super.dispose();
  }

  Future<void> _playRecording() async {
    if (_audioPath == 'mock_audio') {
      setState(() {
        _isPlaying = true;
        _playbackSeconds = 0;
      });

      _playbackTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) {
          setState(() {
            _playbackSeconds++;
          });
          // Stop after 5 seconds for demo
          if (_playbackSeconds >= 5) {
            _stopPlayback();
          }
        }
      });
      return;
    }

    await _audioPlayer.play(DeviceFileSource(_audioPath));
    setState(() {
      _isPlaying = true;
      _playbackSeconds = 0;
    });

    _playbackTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _playbackSeconds++;
        });
      }
    });
  }

  Future<void> _stopPlayback() async {
    await _audioPlayer.stop();
    _playbackTimer?.cancel();
    if (mounted) {
      setState(() {
        _isPlaying = false;
        _playbackSeconds = 0;
      });
    }
  }

  String _formatDuration(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: GradientAppBar(
        title: widget.username,
        showBackButton: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam, color: Colors.white),
            onPressed: () {
              HapticFeedback.lightImpact();
              context.pushNamed(
                'call_screen',
                queryParameters: {
                  'username': widget.username,
                  'isIncoming': 'false',
                  'isVideo': 'true',
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.call, color: Colors.white),
            onPressed: () {
              HapticFeedback.lightImpact();
              context.pushNamed(
                'call_screen',
                queryParameters: {
                  'username': widget.username,
                  'isIncoming': 'false',
                  'isVideo': 'false', // Explicitly false for audio
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              HapticFeedback.lightImpact();
              _showOptionsSheet(context);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileHeader(),
                    const SizedBox(height: 24),
                    if (_biography.isNotEmpty || _audioPath != null)
                      _buildAboutMeSection(),
                    const SizedBox(height: 24),
                    // Photos Section
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Photos",
                        style: TextStyle(
                          fontFamily: 'RobotoSlab',
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildPhotosList(),
                    const SizedBox(height: 24),
                    // Pleasures Section
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Pleasures",
                        style: TextStyle(
                          fontFamily: 'RobotoSlab',
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildInterestsList(),
                    const SizedBox(height: 150), // Increased Bottom padding
                  ],
                ),
              ),
            ],
          ),

          // Bottom Action Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
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
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 0,
                bottom: MediaQuery.of(context).padding.bottom + 16,
              ),
              child: _buildActionButton(
                label: "MESSAGE",
                color: AppColors.primary,
                textColor: Colors.black87,
                onTap: () {
                  if (GoRouter.of(context)
                      .routerDelegate
                      .currentConfiguration
                      .uri
                      .toString()
                      .contains('/chat/')) {
                    context.pop();
                  } else {
                    context.push('/chat/${widget.userId ?? "1"}');
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
          // Shadow moved to parent container as requested
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'RobotoSlab',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textColor,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              FullScreenImageViewer.show(
                context,
                imageProvider: AssetImage(
                  isMale
                      ? 'assets/images/male_avatar.png'
                      : 'assets/images/female_avatar.png',
                ),
                heroTag: 'other_profile_photo',
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Hero(
                tag: 'other_profile_photo',
                child: CircleAvatar(
                  radius: 72,
                  backgroundImage: AssetImage(
                    isMale
                        ? 'assets/images/male_avatar.png'
                        : 'assets/images/female_avatar.png',
                  ),
                  backgroundColor: Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 14),
                const Text(
                  "joined 3 hours ago",
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    color: AppColors.secondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.username,
                  style: const TextStyle(
                    fontFamily: 'RobotoSlab',
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Ankara",
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Male, Straight, 5.9 ft",
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "24 years, Leo ♌",
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutMeSection() {
    final hasAudio = _audioPath != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "About Me",
            style: TextStyle(
              fontFamily: 'RobotoSlab',
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: DashedBorderPainter(borderRadius: 4.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_biography.isNotEmpty)
                      Text(
                        _biography,
                        style: const TextStyle(
                          fontFamily: 'RobotoSlab',
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    if (hasAudio) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              if (_isPlaying) {
                                _stopPlayback();
                              } else {
                                _playRecording();
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary.withOpacity(0.2),
                              ),
                              child: Icon(
                                _isPlaying ? Icons.stop : Icons.play_arrow,
                                color: AppColors.primary,
                                size: 24,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _isPlaying ? "Playing..." : "Voice intro",
                                style: const TextStyle(
                                  fontFamily: 'RobotoSlab',
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                _isPlaying
                                    ? _formatDuration(_playbackSeconds)
                                    : _formatDuration(_totalDurationSeconds),
                                style: TextStyle(
                                  fontFamily: 'RobotoSlab',
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPhotosList() {
    // Generate 10 mixed photos: index % 2 == 0 ? Public : Private
    final photos = List.generate(8, (index) {
      return {
        'isPrivate': index % 2 != 0,
        'image': 'assets/images/male_avatar.png',
        'heroTag': 'photo_$index',
      };
    });

    return SizedBox(
      height: 300, // Further increased height
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: photos.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final photo = photos[index];
          final isPrivate = photo['isPrivate'] as bool;
          final imagePath = photo['image'] as String;
          final heroTag = photo['heroTag'] as String;

          return Consumer(
            builder: (context, ref, _) {
              return GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();

                  if (isPrivate) {
                    final isPremium = ref.read(userProvider).isPremium;
                    if (!isPremium) {
                      final isMale = ref.read(userProvider).isMale;
                      showPremiumRequiredDialog(
                        context,
                        isMale: isMale,
                        message:
                            "You must be a premium member to view private photos.",
                      );
                      return;
                    }
                  }

                  // Open full screen gallery
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenGallery(
                        photos: photos,
                        initialIndex: index,
                        requirePremium: true,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 220, // Further increased width
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white10,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (isPrivate)
                        ImageFiltered(
                          imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Image.asset(imagePath, fit: BoxFit.cover),
                        )
                      else
                        Hero(
                          tag: heroTag,
                          child: Image.asset(imagePath, fit: BoxFit.cover),
                        ),
                      if (isPrivate)
                        Container(
                          color: Colors.transparent,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/close_eye.png',
                                width: 32,
                                height: 32,
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildInterestsList() {
    // Mock selected interests titles only
    final selectedTitles = [
      'Dirty Talk',
      'Cuddling',
      'Eye Contact',
      'Roleplay',
      'Photography',
      'Hiking',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: selectedTitles.map((title) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'RobotoSlab',
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showOptionsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.backgroundDark,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'User Options',
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: Colors.white, size: 24),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.flag_outlined, color: Colors.white),
              title: const Text(
                'Report User',
                style: TextStyle(color: Colors.white, fontFamily: 'RobotoSlab'),
              ),
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.pop(context);
                // Trigger report flow
                showTopToast(
                  context,
                  'User reported',
                  icon: Icons.flag,
                  backgroundColor: Colors.orange,
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.block_outlined,
                color: Colors.redAccent,
              ),
              title: const Text(
                'Block User',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontFamily: 'RobotoSlab',
                ),
              ),
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.pop(context);
                // Trigger block flow
                showTopToast(
                  context,
                  'User blocked',
                  icon: Icons.block,
                  backgroundColor: Colors.red,
                );
              },
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 10),
          ],
        ),
      ),
    );
  }
}
