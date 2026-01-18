# Blur - Anonymous Chat App

A privacy-focused Flutter application for anonymous conversations with strangers.

## 🌟 Features

- **Anonymous Matching** - Connect with strangers based on interests
- **Voice Introductions** - Record 30-second audio profiles
- **Premium Subscriptions** - RevenueCat integration with weekly/monthly/quarterly plans
- **Modern UI** - Elite dark theme with gold accents

## 🏗️ Architecture

The app follows a **feature-first architecture** with GoRouter's `StatefulShellRoute` for persistent bottom navigation.

### Navigation Structure

```
Tabs:
├── /match      - Match with strangers
├── /discovery  - Discover new people
├── /chats      - Your conversations
└── /profile    - Your profile & settings

Overlays:
├── /settings
└── /edit-profile
```

### Folder Structure

```
lib/
├── core/           # Shared services & constants
├── data/           # Static data
├── features/       # Feature modules
│   ├── auth/
│   ├── chat/
│   ├── discovery/
│   ├── match/
│   ├── profile/
│   ├── settings/
│   └── subscription/
├── routing/        # GoRouter configuration
├── theme/          # App theming
└── widgets/        # Shared widgets
```

## 🚀 Getting Started

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Build for iOS
flutter build ios --no-codesign

# Build for Android
flutter build apk
```

## 📦 Key Dependencies

- **State Management**: flutter_riverpod
- **Navigation**: go_router
- **Subscriptions**: purchases_flutter (RevenueCat)
- **Audio**: record, audioplayers
- **UI**: lottie, flutter_svg

## 🎨 Theme

- **Primary**: Gold (#FFD700)
- **Background**: Dark Blue (#001F3D)
- **Font**: RobotoSlab

## 📱 Permissions

### iOS (Info.plist)

- Camera, Photo Library, Microphone, Location, Contacts, Face ID

### Android (AndroidManifest.xml)

- Internet, Camera, Audio, Storage, Location, Notifications

## 📄 Documentation

See `.gemini/ARCHITECTURE_IMPROVEMENT_PLAN.md` for detailed architecture documentation.
