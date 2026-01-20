import 'dart:async';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:blur/theme/app_colors.dart';
import 'package:blur/widgets/guilty_pleasure_card.dart';
import 'package:blur/widgets/dashed_border_painter.dart';
import 'package:blur/widgets/gradient_app_bar.dart';
import 'package:blur/widgets/full_screen_image_viewer.dart';
import 'package:blur/data/guilty_pleasures_data.dart';
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
  String? _audioPath = 'mock_audio';
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
    if (_audioPath == null) return;

    // Simulate playback for mock audio
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
          title: widget.username,
          showBackButton: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.call, color: Colors.white),
              onPressed: () {
                context.pushNamed(
                  'call_screen',
                  queryParameters: {
                    'username': widget.username,
                    'isIncoming': 'false',
                  },
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onPressed: () => _showOptionsSheet(context),
            ),
          ],
        ),
        body: Stack(
          children: [
            NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      _buildProfileHeader(),
                      const SizedBox(height: 24),
                      if (_biography.isNotEmpty || _audioPath != null)
                        _buildAboutMeSection(),
                    ],
                  ),
                ),
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
                padding: const EdgeInsets.only(
                  bottom: 90,
                ), // Space for bottom bar
                child: TabBarView(
                  children: [
                    _buildPhotosTab(),
                    _buildPrivateTab(),
                    _buildInterestsTab(),
                  ],
                ),
              ),
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
      onTap: onTap,
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

  Widget _buildPhotosTab() {
    // Mock photos
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            image: const DecorationImage(
              image: AssetImage('assets/images/male_avatar.png'), // Placeholder
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

  Widget _buildPrivateTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Stack(
          fit: StackFit.expand,
          children: [
            // Blurred Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Image.asset(
                  'assets/images/male_avatar.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Lock Overlay
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Icon(
                  Icons.lock_outline,
                  color: Colors.white54,
                  size: 32,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInterestsTab() {
    // Mock selected interests
    final selectedTitles = [
      'Dirty Talk',
      'Cuddling',
      'Eye Contact',
      'Roleplay',
    ];
    final selectedInterests = guiltyPleasuresData
        .where((item) => selectedTitles.contains(item['title']))
        .toList();

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: selectedInterests.length,
      itemBuilder: (context, index) {
        final item = selectedInterests[index];
        return GuiltyPleasureCard(
          title: item['title']!,
          description: item['description']!,
          imagePath: item['image']!,
          showLottie: false,
          onSelected: (isSelected) {},
          startUnblurred: true,
        );
      },
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
                Navigator.pop(context);
                // Trigger report flow
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Report flow not implemented yet"),
                  ),
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
                Navigator.pop(context);
                // Trigger block flow
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Block flow not implemented yet"),
                  ),
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
