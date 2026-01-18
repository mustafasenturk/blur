---
description: How to run the Blur app locally
---

# Running Blur Locally

## Prerequisites

- Flutter SDK 3.10+
- Xcode (for iOS)
- Android Studio (for Android)

## Steps

// turbo

1. Get dependencies:

```bash
flutter pub get
```

// turbo 2. Run on all connected devices:

```bash
flutter run -d all
```

// turbo 3. Run on specific platform:

```bash
# iOS Simulator
flutter run -d "iPhone"

# Android Emulator
flutter run -d "emulator"
```

## Hot Reload

- Press `r` in terminal for hot reload
- Press `R` for hot restart
- Press `q` to quit

## Debug Mode

The app runs in debug mode by default with:

- Debug banner visible
- GoRouter debug logging enabled
