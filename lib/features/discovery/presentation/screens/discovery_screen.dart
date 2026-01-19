import 'package:flutter/material.dart';

import '../../../../widgets/gradient_app_bar.dart';

/// Discovery screen - placeholder for future content
class DiscoveryScreen extends StatelessWidget {
  const DiscoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const GradientAppBar(title: 'Discover', showBackButton: false),
      body: const SizedBox.shrink(), // Empty screen
    );
  }
}
