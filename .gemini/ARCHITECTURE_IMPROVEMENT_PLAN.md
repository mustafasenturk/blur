# Blur App Development Overview

Blur is a Flutter-based anonymous chat application featuring secure, privacy-focused conversations. This document serves as the central reference for architectural decisions, UI patterns, and feature implementations.

## Key Focus Areas

- **Anonymous Matching**: Connect with strangers based on interests and preferences
- **Premium Experience**: Elite, gold-themed dark UI with modern aesthetics
- **Voice & Bio Profiles**: 30-second audio intros and biography support
- **Privacy First**: End-to-end encrypted conversations (planned)
- **Conversion Optimization**: Premium subscription via RevenueCat

## Current Architecture

### Navigation (GoRouter + StatefulShellRoute)

The app uses Jive-style persistent bottom tab navigation with four main branches:

```
/match      → MatchScreen      (Tab 0) - Anonymous chat partner discovery
/discovery  → DiscoveryScreen  (Tab 1) - Browse potential connections
/chats      → ChatListScreen   (Tab 2) - Conversation list
/profile    → ProfileScreen    (Tab 3) - User profile & settings
```

**Overlay Routes** (push on top of tabs):

- `/settings` → SettingsScreen
- `/edit-profile` → EditProfileScreen

### Feature Modules

```
lib/features/
├── auth/         # Login, Registration, Splash
├── chat/         # Chat list and conversations
├── discovery/    # User discovery with filters
├── match/        # Random matching system
├── profile/      # Profile, About Me modal, Photos
├── settings/     # App settings
└── subscription/ # RevenueCat premium subscriptions
```

### Core Layer

```
lib/
├── core/         # Shared services and providers
├── data/         # Static data (guilty pleasures, etc.)
├── routing/      # GoRouter configuration
├── theme/        # AppColors, AppTheme, Typography
└── widgets/      # Reusable UI components
```

## Key Features

### About Me Modal

- Biography input (max 255 characters)
- 30-second audio recording/playback
- Located in `/lib/features/profile/presentation/widgets/about_me_modal.dart`

### Premium Subscriptions

- RevenueCat integration
- Weekly, Monthly, Quarterly packages
- Located in `/lib/features/subscription/`

### UI Theme

- Dark theme with gold/yellow accents
- Primary color: `#FFD700` (Gold)
- Background: `#001F3D` (Dark Blue)
- RobotoSlab font throughout

## Completed Improvements

- [x] GoRouter with StatefulShellRoute navigation
- [x] Feature-based folder structure
- [x] iOS permissions (Camera, Microphone, Photos, Location)
- [x] Android permissions (Camera, Audio, Storage, Location)
- [x] Riverpod state management setup
- [x] RevenueCat subscription integration
- [x] About Me modal with voice recording
- [x] MainScreen eliminated - individual tab screens

## Pending Improvements

- [ ] Firebase integration (Auth, FCM, Analytics)
- [ ] Push notifications
- [ ] Localization (l10n)
- [ ] Error tracking (Sentry)
- [ ] Connectivity service
- [ ] Chat functionality
- [ ] Real-time matching system
