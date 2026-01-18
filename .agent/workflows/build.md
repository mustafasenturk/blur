---
description: How to build Blur for production release
---

# Building for Production

## iOS Build

// turbo

1. Get dependencies:

```bash
flutter pub get
```

2. Build iOS (without codesign for CI):

```bash
flutter build ios --no-codesign
```

3. Build iOS IPA (with codesign):

```bash
flutter build ipa
```

## Android Build

// turbo

1. Get dependencies:

```bash
flutter pub get
```

2. Build APK:

```bash
flutter build apk --release
```

3. Build App Bundle (for Play Store):

```bash
flutter build appbundle --release
```

## Output Locations

- **iOS**: `build/ios/iphoneos/Runner.app`
- **Android APK**: `build/app/outputs/flutter-apk/app-release.apk`
- **Android Bundle**: `build/app/outputs/bundle/release/app-release.aab`

## Pre-build Checklist

- [ ] Update version in `pubspec.yaml`
- [ ] Test on real devices
- [ ] Verify RevenueCat products
- [ ] Check all permissions work
