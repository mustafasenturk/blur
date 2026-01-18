import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../theme/app_colors.dart';
import '../../../../widgets/guilty_pleasure_card.dart';
import '../../../../widgets/dashed_border_painter.dart';
import '../../../../widgets/gradient_app_bar.dart';
import '../../../../data/guilty_pleasures_data.dart';
import '../widgets/about_me_modal.dart';

/// Profile screen with user info and settings
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  bool isMale = true;
  String _biography = '';
  String? _audioPath;
  late AnimationController _gradientController;

  @override
  void initState() {
    super.initState();
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _gradientController.dispose();
    super.dispose();
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
              onPressed: () => context.push('/edit-profile'),
            ),
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () => context.push('/settings'),
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

            // BE VISIBLE Button - Fixed at bottom
            Positioned(
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).padding.bottom + 16,
              child: AnimatedBuilder(
                animation: _gradientController,
                builder: (context, child) {
                  return Container(
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primaryDark,
                          AppColors.primary,
                        ],
                        stops: [0.0, _gradientController.value, 1.0],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          // TODO: Implement BE VISIBLE action
                        },
                        borderRadius: BorderRadius.circular(26),
                        child: const Center(
                          child: Text(
                            'BE VISIBLE',
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
                    ),
                  );
                },
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
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
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
              Positioned(
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.buttonBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Text(
                    "Scorpio ♏",
                    style: TextStyle(
                      fontFamily: 'RobotoSlab',
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
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
                Text(
                  "joined 7 hours ago",
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    color: AppColors.secondary,
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Gallant Explorer",
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Near Ankara",
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "Male, Straight, 5.9 ft",
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      "18 years",
                      style: TextStyle(
                        fontFamily: 'RobotoSlab',
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    // Preview Profile Button - aligned with Scorpio
                    Container(
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
                  ],
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
                  child: CustomPaint(painter: DashedBorderPainter()),
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
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: hasAudio
                                  ? AppColors.primary.withOpacity(0.2)
                                  : Colors.white.withOpacity(0.1),
                            ),
                            child: Icon(
                              hasAudio ? Icons.play_arrow : Icons.mic,
                              color: hasAudio
                                  ? AppColors.primary
                                  : Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            hasAudio
                                ? "Voice intro recorded"
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
                          if (hasAudio) ...[
                            const Spacer(),
                            Icon(
                              Icons.check_circle,
                              color: AppColors.success,
                              size: 20,
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useRootNavigator: true,
      builder: (context) => AboutMeModal(
        initialBio: _biography,
        initialAudioPath: _audioPath,
        onSave: (bio, audioPath) {
          setState(() {
            _biography = bio;
            _audioPath = audioPath;
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
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: 1,
            itemBuilder: (context, index) {
              return _buildAddPhotoButton();
            },
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(32, 0, 32, 120),
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
      onTap: _showAddPhotoBottomSheet,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
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
