import 'package:flutter/material.dart';

import '../../../../widgets/gradient_app_bar.dart';
import '../widgets/discovery_user_card.dart';

/// Discovery screen - placeholder for future content
class DiscoveryScreen extends StatelessWidget {
  const DiscoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const GradientAppBar(title: 'Discover', showBackButton: false),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 16, bottom: 80),
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
    pleasures: ['Roleplay', 'Edible Fun', 'Sexting', 'Exhibitionism'],
    photos: [
      DiscoverPhoto(url: 'assets/images/female.png', isPrivate: true),
      DiscoverPhoto(url: 'assets/images/female.png', isPrivate: false),
      DiscoverPhoto(url: 'assets/images/female.png', isPrivate: true),
      DiscoverPhoto(url: 'assets/images/female.png', isPrivate: false),
    ],
  ),
];
