---
description: How to analyze and fix code issues in Blur
---

# Code Analysis

// turbo-all

## Quick Analysis

1. Analyze entire project:

```bash
flutter analyze
```

2. Analyze specific directory:

```bash
flutter analyze lib/features/profile/
```

## Fix Common Issues

3. Fix formatting:

```bash
dart format lib/
```

4. Get dependencies:

```bash
flutter pub get
```

5. Clean build:

```bash
flutter clean && flutter pub get
```

## Check for Outdated Packages

6. Check outdated:

```bash
flutter pub outdated
```

7. Upgrade compatible packages:

```bash
flutter pub upgrade
```

## Error Categories

| Type      | Severity      | Action                    |
| --------- | ------------- | ------------------------- |
| `error`   | 🔴 Critical   | Must fix before build     |
| `warning` | 🟡 Important  | Should fix soon           |
| `info`    | 🔵 Suggestion | Can ignore if intentional |

## Common Deprecation Warnings

The `withOpacity` deprecation warnings are from Flutter SDK changes.
Current pattern:

```dart
// Old (deprecated)
color.withOpacity(0.5)

// New (preferred)
color.withValues(alpha: 0.5)
```
