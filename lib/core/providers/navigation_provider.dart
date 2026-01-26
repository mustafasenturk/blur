import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider to track the current bottom navigation tab index
final currentTabProvider = StateProvider<int>((ref) => 0);
