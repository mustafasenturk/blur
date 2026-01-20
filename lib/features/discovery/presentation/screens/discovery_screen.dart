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
          return DiscoveryUserCard(
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
            onPlayVoice: () {
              // TODO: Implement playback
            },
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
  });
}

final List<_DiscoverMockUser> _mockUsers = [
  _DiscoverMockUser(
    name: 'Elif Yılmaz',
    profileImage:
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=200&auto=format&fit=crop',
    bio:
        'Sanat ve müzik tutkunu. İstanbul\'da yaşıyorum. Seyahat etmeyi ve yeni kültürler keşfetmeyi severim. 🎨✈️',
    location: 'İstanbul, TR',
    age: '24',
    height: '1.68m',
    gender: 'Kadın',
    orientation: 'Heteroseksüel',
    hasVoice: true,
    photos: [
      DiscoverPhoto(
        url:
            'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?q=80&w=400&auto=format&fit=crop',
        isPrivate: false,
      ),
      DiscoverPhoto(
        url:
            'https://images.unsplash.com/photo-1517841905240-472988babdf9?q=80&w=400&auto=format&fit=crop',
        isPrivate: true,
      ),
      DiscoverPhoto(
        url:
            'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?q=80&w=400&auto=format&fit=crop',
        isPrivate: false,
      ),
      DiscoverPhoto(
        url:
            'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?q=80&w=400&auto=format&fit=crop',
        isPrivate: true,
      ),
    ],
  ),
  _DiscoverMockUser(
    name: 'Can Demir',
    profileImage:
        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=200&auto=format&fit=crop',
    bio:
        'Fotoğrafçılık ve doğa yürüyüşleri hobim. Kahve içmeden güne başlayamam. ☕️📸',
    location: 'İzmir, TR',
    age: '27',
    height: '1.82m',
    gender: 'Erkek',
    orientation: 'Heteroseksüel',
    hasVoice: false,
    photos: [
      DiscoverPhoto(
        url:
            'https://images.unsplash.com/photo-1506744038136-46273834b3fb?q=80&w=400&auto=format&fit=crop',
        isPrivate: false,
      ),
      DiscoverPhoto(
        url:
            'https://images.unsplash.com/photo-1493246507139-91e8fad9978e?q=80&w=400&auto=format&fit=crop',
        isPrivate: true,
      ),
      DiscoverPhoto(
        url:
            'https://images.unsplash.com/photo-1472214103451-9374bd1c798e?q=80&w=400&auto=format&fit=crop',
        isPrivate: false,
      ),
    ],
  ),
  _DiscoverMockUser(
    name: 'Zeynep Kaya',
    profileImage:
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200&auto=format&fit=crop',
    bio:
        'Moda tasarım öğrencisi. Enerjik ve pozitif biriyim. Dans etmeyi çok severim! 💃✨',
    location: 'Ankara, TR',
    age: '22',
    height: '1.70m',
    gender: 'Kadın',
    orientation: 'Biseksüel',
    hasVoice: true,
    photos: [
      DiscoverPhoto(
        url:
            'https://images.unsplash.com/photo-1516726817505-f16325303a5d?q=80&w=400&auto=format&fit=crop',
        isPrivate: true,
      ),
      DiscoverPhoto(
        url:
            'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?q=80&w=400&auto=format&fit=crop',
        isPrivate: false,
      ),
      DiscoverPhoto(
        url:
            'https://images.unsplash.com/photo-1504703395950-b89145a5425b?q=80&w=400&auto=format&fit=crop',
        isPrivate: true,
      ),
      DiscoverPhoto(
        url:
            'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?q=80&w=400&auto=format&fit=crop',
        isPrivate: false,
      ),
    ],
  ),
];
