import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../widgets/animated_gradient_button.dart';
import '../../../../theme/app_colors.dart';
import '../../../../widgets/guilty_pleasure_card.dart';
import '../../../../widgets/dashed_border_painter.dart';
import '../../../../widgets/gradient_app_bar.dart';
import '../../../../widgets/full_screen_image_viewer.dart';
import '../../../../data/guilty_pleasures_data.dart';
import '../widgets/about_me_modal.dart';

/// Profile screen with user info and settings
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isMale = true;
  String _biography = '';
  String? _audioPath;
  bool _isPlaying = false;
  int _playbackSeconds = 0;
  int _totalDurationSeconds = 0;
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
    if (_audioPath == null) return;

    // Use DeviceFileSource for local files
    await _audioPlayer.play(DeviceFileSource(_audioPath!));
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

  Future<void> _deleteRecording() async {
    // Optional: Delete the file from filesystem if needed, but for now just clear path
    // final file = File(_audioPath!);
    // if (await file.exists()) {
    //   await file.delete();
    // }

    _stopPlayback();

    setState(() {
      _audioPath = null;
    });
  }

  String _formatDuration(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: GradientAppBar(
          title: 'Profile',
          showBackButton: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                HapticFeedback.lightImpact();
                context.push('/edit-profile');
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                HapticFeedback.lightImpact();
                context.push('/settings');
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            SafeArea(
              top: false,
              bottom: false,
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  // Header with profile info
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        // Profile Header
                        _buildProfileHeader(),

                        const SizedBox(height: 24),

                        // About Me Section
                        _buildAboutMeSection(),
                      ],
                    ),
                  ),

                  // Tab Bar
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _TabBarDelegate(
                      TabBar(
                        indicator: const UnderlineTabIndicator(
                          borderSide: BorderSide(
                            width: 3.0,
                            color: AppColors.primary,
                          ),
                          insets: EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.white54,
                        labelStyle: const TextStyle(
                          fontFamily: 'RobotoSlab',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        tabs: const [
                          Tab(
                            icon: Icon(Icons.grid_view_rounded, size: 24),
                            text: "PHOTOS",
                          ),
                          Tab(
                            icon: Icon(Icons.lock_clock_outlined, size: 24),
                            text: "PRIVATE",
                          ),
                          Tab(
                            icon: Icon(Icons.favorite_border_rounded, size: 24),
                            text: "INTEREST",
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                body: Padding(
                  padding: const EdgeInsets.only(bottom: 80),
                  child: TabBarView(
                    children: [
                      _buildPhotosTab(),
                      _buildPrivateTab(),
                      _buildInterestsTab(),
                    ],
                  ),
                ),
              ),
            ),

            // UNBLUR Button - Fixed at bottom
            Positioned(
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).padding.bottom + 32,
              child: AnimatedGradientButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  context.push('/paywall');
                },
                borderRadius: BorderRadius.circular(4),
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
            ),
          ],
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
          // Avatar & Badge
          Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: [
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
                    heroTag: 'profile_photo',
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Hero(
                    tag: 'profile_photo',
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
              Positioned(
                bottom: 0,
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.push('/preview-profile');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundDark,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.buttonBackground,
                        width: 1,
                      ),
                    ),
                    child: const Text(
                      'Preview Profile',
                      style: TextStyle(
                        fontFamily: 'RobotoSlab',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.buttonBackground,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 14),
                Text(
                  "joined 7 hours ago",
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    color: AppColors.secondary,
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Gallant Explorer",
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Ankara",
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Male, Straight, 5.9 ft",
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "18 years, Scorpio ♏",
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
    final hasBio = _biography.isNotEmpty;
    final hasAudio = _audioPath != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        // Only open modal if tapping outside interactive elements or if no audio
        onTap: _showAboutMeModal,
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
                      // Biography Text
                      Text(
                        hasBio
                            ? _biography
                            : "Tap to tell others about yourself...",
                        style: TextStyle(
                          fontFamily: 'RobotoSlab',
                          color: hasBio ? Colors.white : Colors.white70,
                          fontSize: 15,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),
                      // Audio Row
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              if (hasAudio) {
                                if (_isPlaying) {
                                  _stopPlayback();
                                } else {
                                  _playRecording();
                                }
                              } else {
                                _showAboutMeModal();
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: hasAudio
                                    ? AppColors.primary.withOpacity(0.2)
                                    : Colors.white.withOpacity(0.1),
                              ),
                              child: Icon(
                                hasAudio
                                    ? (_isPlaying
                                          ? Icons.stop
                                          : Icons.play_arrow)
                                    : Icons.mic,
                                color: hasAudio
                                    ? AppColors.primary
                                    : Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            height: 40, // Fixed height to prevent layout shift
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  hasAudio
                                      ? (_isPlaying
                                            ? "Playing..."
                                            : "Voice intro recorded")
                                      : "Record audio intro",
                                  style: TextStyle(
                                    fontFamily: 'RobotoSlab',
                                    color: hasAudio
                                        ? AppColors.primary
                                        : Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                if (_isPlaying) ...[
                                  Text(
                                    _formatDuration(_playbackSeconds),
                                    style: TextStyle(
                                      fontFamily: 'RobotoSlab',
                                      fontSize: 12,
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                  ),
                                ] else if (hasAudio) ...[
                                  Text(
                                    _formatDuration(_totalDurationSeconds),
                                    style: TextStyle(
                                      fontFamily: 'RobotoSlab',
                                      fontSize: 12,
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          if (hasAudio) ...[
                            const Spacer(),
                            GestureDetector(
                              onTap: _deleteRecording,
                              child: Icon(
                                Icons.delete_outline,
                                color: Colors.white.withOpacity(0.5),
                                size: 22,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutMeModal() {
    // If playing, stop before opening modal
    if (_isPlaying) _stopPlayback();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useRootNavigator: true,
      builder: (context) => AboutMeModal(
        initialBio: _biography,
        initialAudioPath: _audioPath,
        onSave: (bio, audioPath, duration) {
          setState(() {
            _biography = bio;
            _audioPath = audioPath;
            if (duration != null) {
              _totalDurationSeconds = duration;
            } else if (audioPath == null) {
              _totalDurationSeconds = 0;
            }
          });
        },
      ),
    );
  }

  Widget _buildPhotosTab() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: 1,
      itemBuilder: (context, index) {
        return _buildAddPhotoButton();
      },
    );
  }

  Widget _buildPrivateTab() {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              return _buildAddPhotoButton();
            }, childCount: 1),
          ),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(32, 24, 32, 100),
            child: Text(
              "Only people you approve can see your private photos.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'RobotoSlab',
                color: Colors.white54,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInterestsTab() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: guiltyPleasuresData.length,
      itemBuilder: (context, index) {
        final item = guiltyPleasuresData[index];
        return GuiltyPleasureCard(
          title: item['title']!,
          description: item['description']!,
          imagePath: item['image']!,
          showLottie: index == 0,
          onSelected: (isSelected) {},
        );
      },
    );
  }

  Widget _buildAddPhotoButton() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        _showAddPhotoBottomSheet();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.white24),
        ),
        child: const Center(
          child: Icon(Icons.camera_alt, color: Colors.white, size: 32),
        ),
      ),
    );
  }

  void _showAddPhotoBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      useRootNavigator: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.backgroundDark,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Upload Your Photo',
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
              leading: const Icon(Icons.camera_alt, color: Colors.white),
              title: const Text(
                'Camera',
                style: TextStyle(color: Colors.white, fontFamily: 'RobotoSlab'),
              ),
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.pop(context);
                // TODO: Implement Camera Pick
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.white),
              title: const Text(
                'Gallery',
                style: TextStyle(color: Colors.white, fontFamily: 'RobotoSlab'),
              ),
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.pop(context);
                // TODO: Implement Gallery Pick
              },
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
          ],
        ),
      ),
    );
  }
}

/// Tab bar delegate for pinned header
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _TabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height + 12;

  @override
  double get maxExtent => tabBar.preferredSize.height + 12;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      alignment: Alignment.center,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_TabBarDelegate oldDelegate) => false;
}
