import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:blur/theme/app_colors.dart';
import 'package:blur/widgets/full_screen_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DiscoveryUserCard extends StatefulWidget {
  final String userName;
  final String userImageUrl;
  final String biography;
  final String location;
  final String age;
  final String height;
  final String gender;
  final String orientation;
  final bool hasVoiceRecording;
  final String? voiceUrl; // URL or path to voice file
  final List<DiscoverPhoto> photos;
  final List<String> pleasures;

  const DiscoveryUserCard({
    super.key,
    required this.userName,
    required this.userImageUrl,
    required this.biography,
    required this.location,
    required this.age,
    required this.height,
    required this.gender,
    required this.orientation,
    required this.photos,
    this.pleasures = const [],
    this.hasVoiceRecording = false,
    this.voiceUrl,
  });

  @override
  State<DiscoveryUserCard> createState() => _DiscoveryUserCardState();
}

class _DiscoveryUserCardState extends State<DiscoveryUserCard> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });

    _audioPlayer.onDurationChanged.listen((newDuration) {
      if (mounted) {
        setState(() {
          _duration = newDuration;
        });
      }
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      if (mounted) {
        setState(() {
          _position = newPosition;
        });
      }
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _toggleAudio() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      // For now, playing a dummy sound if no URL is provided, or the provided URL
      if (widget.voiceUrl != null && widget.voiceUrl!.isNotEmpty) {
        try {
          if (widget.voiceUrl!.startsWith('http')) {
            await _audioPlayer.play(UrlSource(widget.voiceUrl!));
          } else {
            await _audioPlayer.play(
              AssetSource(widget.voiceUrl!.replaceFirst('assets/', '')),
            );
          }
        } catch (e) {
          debugPrint('Error playing audio: $e');
        }
      } else {
        debugPrint('No voice URL provided');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Total items = Bio Card + Photos
    final totalItems = 1 + widget.photos.length;

    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. FIXED HEADER
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 4, 8),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        context.pushNamed(
                          'user_profile',
                          queryParameters: {
                            'username': widget.userName,
                            // In real app, pass actual user ID
                            'userId': 'mock-user-123',
                          },
                        );
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white24,
                                width: 1,
                              ),
                            ),
                            child: ClipOval(
                              child: _buildImage(widget.userImageUrl),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.userName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${widget.location} • ${widget.age}',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.white70),
                    onPressed: _showActionBottomSheet,
                  ),
                ],
              ),
            ),

            // 2. HORIZONTAL SCROLLABLE CONTENT
            SizedBox(
              height: 380, // Height for the cards
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: totalItems,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildBioAndPleasuresCard(context);
                  }
                  final photoIndex = index - 1;
                  return _buildPhotoItem(context, widget.photos[photoIndex]);
                },
              ),
            ),

            const SizedBox(height: 24), // Spacing between different users
          ],
        ),

        // FLOATING ACTION BUTTONS
        Positioned(
          right: 12,
          bottom: 0,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Add Friend Button
              GestureDetector(
                onTap: () {
                  // TODO: Implement add friend logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Friend request sent!')),
                  );
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.buttonBackground,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.person_add_rounded,
                    color: AppColors.black,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Message Button
              GestureDetector(
                onTap: () {
                  context.push('/chat/mock-user-123');
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.chat_bubble_rounded,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // FIRST KART: Bio, Voice, Pleasures
  Widget _buildBioAndPleasuresCard(BuildContext context) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C), // Dark Card Background
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Bio Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.format_quote_rounded,
                    color: Colors.white.withOpacity(0.1),
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.biography,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFFE0E0E0),
                      fontSize: 16,
                      height: 1.5,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Voice Player (Only if hasVoiceRecording is true)
                  // If hasVoiceRecording is false, show nothing here as requested.
                  if (widget.hasVoiceRecording) ...[
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: _toggleAudio,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: _isPlaying
                              ? AppColors.primary.withOpacity(0.2)
                              : Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30),
                          border: _isPlaying
                              ? Border.all(
                                  color: AppColors.primary.withOpacity(0.5),
                                )
                              : null,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _isPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              color: _isPlaying
                                  ? AppColors.primary
                                  : Colors.white,
                              size: 28,
                            ),
                            const SizedBox(width: 8),
                            // Waveform Visual
                            SizedBox(
                              height: 24,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: List.generate(12, (i) {
                                  // Animate height if playing? Simple random effect for now or static
                                  final height = 12.0 + (i % 3) * 6.0;
                                  return Container(
                                    width: 3,
                                    height: height,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _isPlaying
                                          ? AppColors.primary
                                          : Colors.white70,
                                      borderRadius: BorderRadius.circular(1.5),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Pleasures Button
          GestureDetector(
            onTap: () => _showPleasuresDialog(context),
            child: Container(
              height: 56,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${widget.pleasures.length}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.local_fire_department,
                    color: Colors.black,
                    size: 24,
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Pleasures',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // OTHER CARDS: Photos
  Widget _buildPhotoItem(BuildContext context, DiscoverPhoto photo) {
    return GestureDetector(
      onTap: () {
        if (!photo.isPrivate) {
          final imageProvider = photo.url.startsWith('http')
              ? NetworkImage(photo.url)
              : AssetImage(photo.url) as ImageProvider;

          FullScreenImageViewer.show(
            context,
            imageProvider: imageProvider,
            heroTag:
                photo.url + DateTime.now().toString(), // Helper for uniqueness
          );
        }
      },
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image Logic
            if (photo.isPrivate)
              ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: _buildImage(photo.url),
              )
            else
              Hero(
                tag: photo.url + DateTime.now().toString(),
                child: _buildImage(photo.url),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String path) {
    if (path.startsWith('http')) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[900],
            child: const Center(
              child: Icon(Icons.error_outline, color: Colors.white24),
            ),
          );
        },
      );
    } else {
      return Image.asset(
        path,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[900],
            child: const Center(
              child: Icon(Icons.image_not_supported, color: Colors.white24),
            ),
          );
        },
      );
    }
  }

  void _showPleasuresDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        decoration: const BoxDecoration(
          color: AppColors.backgroundDark,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${widget.userName}'s Pleasures",
                    style: const TextStyle(
                      fontFamily: 'RobotoSlab',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        fontFamily: 'RobotoSlab',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Interest Chips
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  0,
                  0,
                  0,
                  MediaQuery.of(context).padding.bottom + 16,
                ),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.start,
                  children: widget.pleasures.map((pleasure) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.5),
                        ),
                      ),
                      child: Text(
                        pleasure,
                        style: const TextStyle(
                          fontFamily: 'RobotoSlab',
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showActionBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      useRootNavigator: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1E1E1E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.only(bottom: 20),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 16, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.userName,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.close,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              ListTile(
                leading: const Icon(Icons.send_rounded, color: Colors.white),
                title: const Text(
                  'Send Message',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/chat/mock-user-123');
                },
              ),
              ListTile(
                leading: const Icon(Icons.flag_outlined, color: Colors.white),
                title: const Text(
                  'Report User',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Implement report logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User reported')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.block_outlined, color: Colors.red),
                title: const Text(
                  'Block User',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Implement block logic
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('User blocked')));
                },
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom + 10),
            ],
          ),
        ),
      ),
    );
  }
}

class DiscoverPhoto {
  final String url;
  final bool isPrivate;

  DiscoverPhoto({required this.url, required this.isPrivate});
}
