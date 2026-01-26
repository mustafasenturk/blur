import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:blur/core/providers/user_provider.dart';
import 'package:blur/theme/app_colors.dart';
import '../../../../widgets/gradient_app_bar.dart';
import '../widgets/discovery_user_card.dart';

/// Discovery screen - placeholder for future content
class DiscoveryScreen extends ConsumerStatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  ConsumerState<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends ConsumerState<DiscoveryScreen> {
  // Filter States
  RangeValues _ageRange = const RangeValues(18, 99);
  late String _selectedGender = 'Female'; // Default fallback
  bool _photosOnly = false;

  @override
  void initState() {
    super.initState();
    // Default gender based on user
    final user = ref.read(userProvider);
    _selectedGender = user.isMale ? 'Female' : 'Male';
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useRootNavigator: true, // Fix bottom bar coverage
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            decoration: const BoxDecoration(
              color: AppColors.backgroundDark,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Auto height
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filters',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'RobotoSlab',
                        ),
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              final user = ref.read(userProvider);
                              setModalState(() {
                                _ageRange = const RangeValues(18, 99);
                                _selectedGender = user.isMale
                                    ? 'Female'
                                    : 'Male';
                                _photosOnly = false;
                              });
                              setState(() {
                                _ageRange = const RangeValues(18, 99);
                                _selectedGender = user.isMale
                                    ? 'Female'
                                    : 'Male';
                                _photosOnly = false;
                              }); // Apply to parent
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Reset',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontFamily: 'RobotoSlab',
                                fontSize: 16,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Removed Divider
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Age Range
                        _buildSectionTitle('Age Range'),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${_ageRange.start.round()}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '${_ageRange.end.round()}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        RangeSlider(
                          values: _ageRange,
                          min: 18,
                          max: 99,
                          activeColor: AppColors.primary,
                          inactiveColor: Colors.white10,
                          onChanged: (values) {
                            setModalState(() => _ageRange = values);
                          },
                        ),

                        const SizedBox(height: 32),

                        // Gender
                        _buildSectionTitle('Interested In'),
                        const SizedBox(height: 16),
                        Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: Row(
                            children: [
                              _buildGenderOption(
                                'Male',
                                setModalState,
                                borderRadius: const BorderRadius.horizontal(
                                  left: Radius.circular(4),
                                ),
                              ),
                              Container(width: 1, color: Colors.white12),
                              _buildGenderOption('All', setModalState),
                              Container(width: 1, color: Colors.white12),
                              _buildGenderOption(
                                'Female',
                                setModalState,
                                borderRadius: const BorderRadius.horizontal(
                                  right: Radius.circular(4),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Photos Only
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildSectionTitle('With Photos Only'),
                            Switch(
                              value: _photosOnly,
                              activeColor: AppColors.primary,
                              onChanged: (val) {
                                setModalState(() => _photosOnly = val);
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Apply Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {}); // Apply to parent
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Apply Filters',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'RobotoSlab',
                              ),
                            ),
                          ),
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
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: 'RobotoSlab',
      ),
    );
  }

  Widget _buildGenderOption(
    String label,
    StateSetter setModalState, {
    BorderRadius? borderRadius,
  }) {
    final isSelected = _selectedGender == label;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setModalState(() => _selectedGender = label);
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: borderRadius,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'RobotoSlab',
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: GradientAppBar(
        title: 'Discover',
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded, color: Colors.white),
            onPressed: _showFilterBottomSheet,
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.only(
          top: 16,
          bottom: MediaQuery.of(context).padding.bottom + 100,
        ),
        itemCount: _mockUsers.length,
        itemBuilder: (context, index) {
          final user = _mockUsers[index];
          final isLast = index == _mockUsers.length - 1;

          return Column(
            children: [
              DiscoveryUserCard(
                userName: user.name,
                userImageUrl: user.profileImage,
                biography: user.bio,
                location: user.location,
                age: user.age,
                height: user.height,
                gender: user.gender,
                orientation: user.orientation,
                hasVoiceRecording: user.hasVoice,
                voiceUrl: user.voiceUrl,
                photos: user.photos,
                pleasures: user.pleasures,
              ),
              if (!isLast)
                Center(
                  child: Image.asset(
                    'assets/images/seperator.png',
                    width: double.infinity,
                    fit: BoxFit.contain,
                    height: 40, // Adjust height as needed
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

// Mock Data Models
class _DiscoverMockUser {
  final String name;
  final String profileImage;
  final String bio;
  final String location;
  final String age;
  final String height;
  final String gender;
  final String orientation;
  final bool hasVoice;
  final String? voiceUrl;
  final List<DiscoverPhoto> photos;
  final List<String> pleasures;

  _DiscoverMockUser({
    required this.name,
    required this.profileImage,
    required this.bio,
    required this.location,
    required this.age,
    required this.height,
    required this.gender,
    required this.orientation,
    required this.hasVoice,
    this.voiceUrl,
    required this.photos,
    required this.pleasures,
  });
}

final List<_DiscoverMockUser> _mockUsers = [
  _DiscoverMockUser(
    name: 'Elif Yılmaz',
    profileImage: 'assets/images/female.png', // Use asset
    bio:
        'Passionate about art and music. Living in Istanbul. I love traveling and discovering new cultures. 🎨✈️',
    location: 'Istanbul, TR',
    age: '24',
    height: '1.68m',
    gender: 'Female',
    orientation: 'Heterosexual',
    hasVoice: true,
    voiceUrl: 'assets/sounds/ringtone.mp3',
    pleasures: ['Dirty Talk', 'French Kissing', 'Neck Kisses', 'Eye Contact'],
    photos: [
      DiscoverPhoto(url: 'assets/images/female.png', isPrivate: false),
      DiscoverPhoto(url: 'assets/images/female.png', isPrivate: true),
      DiscoverPhoto(url: 'assets/images/female.png', isPrivate: false),
      DiscoverPhoto(url: 'assets/images/female.png', isPrivate: true),
    ],
  ),
  _DiscoverMockUser(
    name: 'Can Demir',
    profileImage: 'assets/images/male.png', // Use asset
    bio:
        'Photography and hiking are my hobbies. I cannot start the day without coffee. ☕️📸',
    location: 'Izmir, TR',
    age: '27',
    height: '1.82m',
    gender: 'Male',
    orientation: 'Heterosexual',
    hasVoice: false,
    pleasures: ['Your Scent', 'Heavy Petting', 'Cuddling', 'Oil Massage'],
    photos: [
      DiscoverPhoto(url: 'assets/images/male.png', isPrivate: false),
      DiscoverPhoto(url: 'assets/images/male.png', isPrivate: true),
      DiscoverPhoto(url: 'assets/images/male.png', isPrivate: false),
    ],
  ),
  _DiscoverMockUser(
    name: 'Zeynep Kaya',
    profileImage: 'assets/images/female.png',
    bio:
        'Fashion design student. I am energetic and positive. I love dancing very much! 💃✨',
    location: 'Ankara, TR',
    age: '22',
    height: '1.70m',
    gender: 'Female',
    orientation: 'Bisexual',
    hasVoice: true,
    voiceUrl: 'assets/sounds/ringtone.mp3',
    pleasures: ['Roleplay', 'Edible Fun', 'Sexting', 'Exhibitionism'],
    photos: [
      DiscoverPhoto(url: 'assets/images/female.png', isPrivate: true),
      DiscoverPhoto(url: 'assets/images/female.png', isPrivate: false),
      DiscoverPhoto(url: 'assets/images/female.png', isPrivate: true),
      DiscoverPhoto(url: 'assets/images/female.png', isPrivate: false),
    ],
  ),
];
