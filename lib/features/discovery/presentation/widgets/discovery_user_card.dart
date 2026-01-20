import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';

class DiscoveryUserCard extends StatelessWidget {
  final String userName;
  final String userImageUrl;
  final String biography;
  final String location;
  final String age;
  final String height;
  final String gender;
  final String orientation;
  final bool hasVoiceRecording;
  final List<DiscoverPhoto> photos;
  final VoidCallback? onPlayVoice;

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
    this.hasVoiceRecording = false,
    this.onPlayVoice,
  });

  @override
  Widget build(BuildContext context) {
    // Total number of items = 1 (Info Card) + Photos
    final totalItems = 1 + photos.length;

    return Container(
      height: 280, // Fixed height for horizontal list
      margin: const EdgeInsets.only(bottom: 24),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: totalItems,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildInfoCard(context);
          }
          final photoIndex = index - 1;
          return _buildPhotoItem(context, photos[photoIndex]);
        },
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Container(
      width: 320, // Fixed width for the info card
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Avatar + Basic Info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Large Profile Avatar
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 2),
                  color: Colors.grey[800],
                ),
                child: ClipOval(
                  child: Image.network(
                    userImageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Name & Location & Stats
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Location
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 14,
                          color: Colors.white.withOpacity(0.6),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Stats Badges (Wrap)
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _buildStatBadge(age),
                        _buildStatBadge(height),
                        _buildStatBadge(gender),
                        _buildStatBadge(orientation),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Spacer(),

          // Biography
          Text(
            biography,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 13,
              height: 1.5,
            ),
          ),

          // Voice Note (if exists)
          if (hasVoiceRecording) ...[
            const SizedBox(height: 12),
            GestureDetector(
              onTap: onPlayVoice,
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.play_arrow_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Container(
                      height: 2,
                      width: 40,
                      color: AppColors.primary.withOpacity(0.5),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      height: 2,
                      width: 20,
                      color: AppColors.primary.withOpacity(0.3),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '0:15',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withOpacity(0.9),
          fontSize: 10, // Small text for stats
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildPhotoItem(BuildContext context, DiscoverPhoto photo) {
    return Container(
      width: 180, // Slightly wider for better photo visibility
      margin: const EdgeInsets.only(right: 12),
      decoration: const BoxDecoration(color: Color(0xFF1E1E1E)),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (photo.isPrivate)
            ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: _buildSafeImage(photo.url),
            )
          else
            _buildSafeImage(photo.url),

          if (photo.isPrivate)
            Container(
              alignment: Alignment.center,
              color: Colors.black.withOpacity(0.2),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.blur_on,
                  color: Colors.white.withOpacity(0.9),
                  size: 28,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSafeImage(String url) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey[800],
          child: const Center(
            child: Icon(Icons.broken_image, color: Colors.white30),
          ),
        );
      },
    );
  }
}

class DiscoverPhoto {
  final String url;
  final bool isPrivate;

  DiscoverPhoto({required this.url, required this.isPrivate});
}
