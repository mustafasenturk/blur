import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../theme/app_colors.dart';
import '../../../../widgets/gradient_app_bar.dart';
import '../../../auth/presentation/widgets/restore_account_modal.dart';
import 'package:go_router/go_router.dart';

/// Match screen - Find anonymous chat partners
class MatchScreen extends StatefulWidget {
  const MatchScreen({super.key});

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  String _selectedGenderFilter = 'Everyone';
  bool _isMatching = false;
  final Set<String> _selectedInterests = {};

  // Guilty Pleasures Data (same as register step 4)
  final List<String> _guiltyPleasures = [
    'Dirty Talk',
    'Your Scent',
    'Blindfolds',
    'Biting',
    'Heavy Petting',
    'French Kissing',
    'Cuddling',
    'Oil Massage',
    'Neck Kisses',
    'Tattoos',
    'Eye Contact',
    'Lap Dance',
    'Hair Pulling',
    'Oral',
    'Roleplay',
    'Foot Fetish',
    'Spanking',
    'Exhibitionism',
    'Edible Fun',
    'Sexting',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final state = GoRouterState.of(context);
        final extra = state.extra as Map<String, dynamic>?;
        if (extra != null && extra['show_restore'] == true) {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            useRootNavigator: true,
            builder: (context) => const RestoreAccountModal(),
          );
        }
      } catch (e) {
        // GoRouterState might not be found if not in a route, ignore
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: GradientAppBar(
        showBackButton: false,
        titleWidget: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/icons/logo_transparent.png', height: 24),
            const SizedBox(width: 8),
            ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
              child: const Text(
                'Blur',
                style: TextStyle(
                  fontFamily: 'RobotoSlab',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const Text(
              ':Chat Anonymously',
              style: TextStyle(
                fontFamily: 'RobotoSlab',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const Spacer(flex: 2),
            // Lottie Animation
            SizedBox(
              height: 320,
              child: Lottie.asset(
                'assets/animations/mask.json',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),

            // Chat Stranger Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isMatching
                      ? null
                      : () async {
                          setState(() {
                            _isMatching = true;
                          });

                          // Simulate finding a match
                          await Future.delayed(const Duration(seconds: 2));

                          if (mounted) {
                            setState(() {
                              _isMatching = false;
                            });
                            // Generate a mock ID and navigate
                            final mockId = DateTime.now().millisecondsSinceEpoch
                                .toString();
                            context.push('/chat/stranger-$mockId');
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonBackground,
                    foregroundColor: Colors.black,
                    disabledBackgroundColor: AppColors.buttonBackground
                        .withOpacity(0.5),
                    disabledForegroundColor: Colors.black.withOpacity(0.5),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isMatching) ...[
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.black54,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      const Text(
                        'Chat Stranger',
                        style: TextStyle(
                          fontFamily: 'RobotoSlab',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Subtext
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Connect anonymously. Chat securely.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'RobotoSlab',
                  fontSize: 14,
                  color: AppColors.secondary,
                  height: 1.4,
                ),
              ),
            ),

            const Spacer(flex: 3),

            // Filters Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gender Filter
                  const Text(
                    "Choose a partner's gender",
                    style: TextStyle(
                      fontFamily: 'RobotoSlab',
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Row(
                      children: [
                        _buildGenderOption(
                          'Male',
                          iconPath: 'assets/images/coin.png',
                          iconLeft: true,
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(4),
                          ),
                        ),
                        Container(width: 1, color: Colors.white12),
                        _buildGenderOption('Everyone'),
                        Container(width: 1, color: Colors.white12),
                        _buildGenderOption(
                          'Female',
                          iconPath: 'assets/images/coin.png',
                          iconLeft: false,
                          borderRadius: const BorderRadius.horizontal(
                            right: Radius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Interest Filter
                  const Text(
                    "Choose Interest",
                    style: TextStyle(
                      fontFamily: 'RobotoSlab',
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: _showInterestFilterSheet,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              _selectedInterests.isEmpty
                                  ? 'Any'
                                  : _selectedInterests.join(', '),
                              style: const TextStyle(
                                fontFamily: 'RobotoSlab',
                                color: Colors.white,
                                fontSize: 15,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white54,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderOption(
    String label, {
    String? iconPath,
    bool iconLeft = true,
    BorderRadius? borderRadius,
  }) {
    final isSelected = _selectedGenderFilter == label;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedGenderFilter = label;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: borderRadius,
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (iconPath != null && iconLeft) ...[
                  Image.asset(iconPath, height: 16),
                  const SizedBox(width: 4),
                ],
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    color: isSelected ? Colors.black : Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                if (iconPath != null && !iconLeft) ...[
                  const SizedBox(width: 4),
                  Image.asset(iconPath, height: 16),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showInterestFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            decoration: const BoxDecoration(
              color: AppColors.backgroundDark,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Choose Interests',
                        style: TextStyle(
                          fontFamily: 'RobotoSlab',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          'Done',
                          style: TextStyle(
                            fontFamily: 'RobotoSlab',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Interest Chips - Multi-select
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      16,
                      0,
                      16,
                      MediaQuery.of(context).padding.bottom + 16,
                    ),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _guiltyPleasures.map((interest) {
                        final isSelected = _selectedInterests.contains(
                          interest,
                        );
                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              setState(() {
                                if (isSelected) {
                                  _selectedInterests.remove(interest);
                                } else {
                                  _selectedInterests.add(interest);
                                }
                              });
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.white24,
                              ),
                            ),
                            child: Text(
                              interest,
                              style: TextStyle(
                                fontFamily: 'RobotoSlab',
                                color: isSelected ? Colors.black : Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
