
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
