---
description: How to add a new screen to Blur with proper routing
---

# Adding a New Screen

## 1. Create the Screen File

Create in the appropriate feature folder:

```
lib/features/{feature}/presentation/screens/{screen_name}_screen.dart
```

Example structure:

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../theme/app_colors.dart';

class NewScreen extends StatefulWidget {
  const NewScreen({super.key});

  @override
  State<NewScreen> createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: // Your content
      ),
    );
  }
}
```

## 2. Add Route to Router

In `/lib/routing/app_router.dart`:

### For Overlay Routes (covers bottom nav):

```dart
GoRoute(
  path: '/new-screen',
  parentNavigatorKey: _rootNavigatorKey,
  pageBuilder: (context, state) => _buildTransitionPage(
    key: state.pageKey,
    child: const NewScreen(),
  ),
),
```

### For Tab-Nested Routes:

Add under the appropriate `StatefulShellBranch`.

## 3. Update Routes Constants

In `/lib/routing/routes.dart`:

```dart
static const String newScreen = '/new-screen';
```

## 4. Navigate to Screen

```dart
// Push (can go back)
context.push('/new-screen');

// Go (replaces current)
context.go('/new-screen');
```

## Theme Guidelines

- Use `AppColors.primary` for gold accents
- Use `AppColors.backgroundDark` for backgrounds
- Font: `fontFamily: 'RobotoSlab'`
