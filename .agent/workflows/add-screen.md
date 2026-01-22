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

## Navigation Best Practices

When navigating, always check `/lib/routing/app_router.dart` first:

1.  **Named Routes**: Use `context.pushNamed('route_name')` ONLY if the route has a `name` property defined in the `GoRoute`.

    ```dart
    // In app_router.dart: name: 'user_profile'
    context.pushNamed('user_profile'); // ✅ Correct
    ```

2.  **Path Navigation**: If a route does NOT have a name (e.g. `/chat/:id`), you MUST use `context.push('/path/value')`.
    ```dart
    // In app_router.dart: No name defined
    context.pushNamed('chat_detail'); // ❌ CRASH: Route name not found
    context.push('/chat/123');        // ✅ Correct
    ```

## Theme Guidelines

- Use `AppColors.primary` for gold accents
- Use `AppColors.backgroundDark` for backgrounds
- Font: `fontFamily: 'RobotoSlab'`
