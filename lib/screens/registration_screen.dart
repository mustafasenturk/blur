import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

import '../theme/app_colors.dart';
import 'main_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  bool _initialAnimationComplete = false;

  @override
  void initState() {
    super.initState();
    // Start with both visible (unselected state), then select Man after delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _selectedGender = 'Man';
          _initialAnimationComplete = true; // Mark animation as done
        });
      }
    });
  }

  // State for Gender Step
  String? _selectedGender; // Start as null to show both unblurred initially
  final Set<int> _selectedInterestsIndices = {};

  // State for Date of Birth Step
  DateTime? _birthDate;
  int get _age {
    if (_birthDate == null) return 0;
    final today = DateTime.now();
    int age = today.year - _birthDate!.year;
    if (today.month < _birthDate!.month ||
        (today.month == _birthDate!.month && today.day < _birthDate!.day)) {
      age--;
    }
    return age;
  }

  // State for Height Step
  int _heightCm = 180;
  bool _useMetric = true;
  Timer? _pressTimer;

  void _updateHeight(int delta) {
    setState(() {
      _heightCm = (_heightCm + delta).clamp(100, 250);
    });
    HapticFeedback.selectionClick();
  }

  void _startContinuousChange(int delta) {
    _updateHeight(delta); // Initial change
    _pressTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      _updateHeight(delta);
    });
  }

  void _stopContinuousChange() {
    _pressTimer?.cancel();
    _pressTimer = null;
  }

  String get _heightDisplay {
    if (_useMetric) {
      return '$_heightCm CM';
    } else {
      // 1 inch = 2.54 cm
      double totalInches = _heightCm / 2.54;
      int feet = (totalInches / 12).floor();
      int inches = (totalInches % 12).round();
      if (inches == 12) {
        feet++;
        inches = 0;
      }
      return "$feet'$inches\"";
    }
  }

  // State for Interests Step
  // State for Guilty Pleasures Step
  final List<Map<String, String>> _guiltyPleasures = [
    {
      'title': 'Dirty Talk',
      'description': 'Whisper filthy, naughty things into my ear.',
      'image': 'assets/images/pleasures/dirty_talk.png',
    },
    {
      'title': 'Your Scent',
      'description': 'Your natural musk drives me absolutely wild.',
      'image': 'assets/images/pleasures/your_scent.png',
    },
    {
      'title': 'Blindfolds',
      'description': 'Heightened senses when I can’t see your next move.',
      'image': 'assets/images/pleasures/blindfolds.png',
    },
    {
      'title': 'Biting',
      'description': 'Gently graze your teeth against my sensitive skin.',
      'image': 'assets/images/pleasures/biting.png',
    },
    {
      'title': 'Heavy Petting',
      'description': 'Hands roaming everywhere, igniting a serious fire.',
      'image': 'assets/images/pleasures/heavy_petting.png',
    },
    {
      'title': 'French Kissing',
      'description': 'Deep, wet, passionate tongues tangling together.',
      'image': 'assets/images/pleasures/french_kisses.png',
    },
    {
      'title': 'Cuddling',
      'description': 'Skin on skin, holding you tight after the fun.',
      'image': 'assets/images/pleasures/cuddling.png',
    },
    {
      'title': 'Oil Massage',
      'description': 'Slippery hands exploring every inch of my body.',
      'image': 'assets/images/pleasures/oil_massage.png',
    },
    {
      'title': 'Neck Kisses',
      'description': 'Soft lips on my neck make me shiver instantly.',
      'image': 'assets/images/pleasures/neck_kisses.png',
    },
    {
      'title': 'Tattoos',
      'description': 'Ink on skin is my ultimate visual turn-on.',
      'image': 'assets/images/pleasures/tattoos.png',
    },
    {
      'title': 'Eye Contact',
      'description': 'Staring deep into your soul while we connect.',
      'image': 'assets/images/pleasures/eye_contact.png',
    },
    {
      'title': 'Lap Dance',
      'description': 'Moving my hips against you in a private show.',
      'image': 'assets/images/pleasures/lap_dance.png',
    },
    {
      'title': 'Hair Pulling',
      'description': 'Grab my hair and take total control of me.',
      'image': 'assets/images/pleasures/hair_pulling.png',
    },
    {
      'title': 'Oral',
      'description': 'Giving or receiving, I am addicted to the taste.',
      'image': 'assets/images/pleasures/oral.png',
    },
    {
      'title': 'Roleplay',
      'description': 'Acting out our wildest secret fantasies tonight.',
      'image': 'assets/images/pleasures/roleplay.png',
    },
    {
      'title': 'Foot Fetish',
      'description': 'Adoring the beauty and shape of your feet.',
      'image': 'assets/images/pleasures/foot_fetish.png',
    },
    {
      'title': 'Spanking',
      'description': 'A little sting for a massive wave of pleasure.',
      'image': 'assets/images/pleasures/spanking.png',
    },
    {
      'title': 'Exhibitionism',
      'description': 'The thrill of strangers potentially seeing us together.',
      'image': 'assets/images/pleasures/exhibitionism.png',
    },
    {
      'title': 'Edible Fun',
      'description': 'Licking sweet treats off your naked body.',
      'image': 'assets/images/pleasures/edible_fun.png',
    },
    {
      'title': 'Sexting',
      'description': 'Teasing you with naughty texts and risky photos.',
      'image': 'assets/images/pleasures/sexting.png',
    },
  ];

  void _selectDate(BuildContext context) {
    final DateTime today = DateTime.now();
    final DateTime lastDate = DateTime(today.year - 18, today.month, today.day);
    DateTime initialDate = _birthDate ?? lastDate;

    if (initialDate.isAfter(lastDate)) initialDate = lastDate;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF222222),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext builder) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              // Header with Done button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Choose your date of birth',
                      style: TextStyle(
                        fontFamily: 'RobotoSlab',
                        color: AppColors.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Save selection if null/unchanged
                        if (_birthDate == null) {
                          setState(() => _birthDate = initialDate);
                        }
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Done',
                        style: TextStyle(
                          fontFamily: 'RobotoSlab',
                          color: AppColors.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoTheme(
                  data: const CupertinoThemeData(
                    brightness: Brightness.dark,
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: TextStyle(
                        fontFamily: 'RobotoSlab',
                        color: Colors.white,
                        fontSize: 22, // Increased font size to widen visually
                      ),
                    ),
                  ),
                  child: SizedBox(
                    width: double.infinity, // Force full width
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: initialDate,
                      maximumDate: lastDate,
                      minimumDate: DateTime(1900),
                      onDateTimeChanged: (DateTime newDate) {
                        setState(() => _birthDate = newDate);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ).then((_) {
      if (mounted && _birthDate != null) {
        // Trigger Confirmation Dialog immediately after bottom sheet closes
        // But delay slightly to ensure frame is stable or just call directly
        _showAgeConfirmationDialog();
      }
    });
  }

  void _showAgeConfirmationDialog() {
    if (_birthDate == null || !mounted) return;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF222222),
        title: const Text(
          'Are you sure?',
          style: TextStyle(fontFamily: 'RobotoSlab', color: Colors.white),
        ),
        content: Text(
          'You are $_age? You won\'t be able to change it later.',
          style: const TextStyle(
            fontFamily: 'RobotoSlab',
            color: Colors.white70,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _selectDate(context); // Re-open picker
            },
            child: const Text('No', style: TextStyle(color: Colors.white38)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _proceedToNextStep();
            },
            child: const Text(
              'Yes',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _nextPage() {
    if (_currentStep == 1) {
      if (_birthDate == null) {
        _selectDate(context);
      } else {
        _showAgeConfirmationDialog();
      }
    } else {
      _proceedToNextStep();
    }
  }

  void _proceedToNextStep() {
    if (_currentStep < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentStep++;
      });
    } else {
      // Finish registration
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MainScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildGenderStep(),
                  _buildAgeStep(),
                  _buildHeightStep(),
                  _buildInterestsStep(),
                ],
              ),
            ),

            // Bottom Action Button
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 24.0),
              child: _buildNextButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderStep() {
    return Column(
      children: [
        const SizedBox(height: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60.0),
            child: _GenderOption(
              imagePath: 'assets/images/male.png',
              isSelected: _selectedGender == 'Man',
              // Initially, if animation isn't done, show as visible (unblurred)
              forceVisible: !_initialAnimationComplete,
              onTap: () {
                setState(() {
                  _selectedGender = 'Man';
                  _initialAnimationComplete = true;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60.0),
            child: _GenderOption(
              imagePath: 'assets/images/female.png',
              isSelected: _selectedGender == 'Woman',
              // Initially, if animation isn't done, show as visible (unblurred)
              forceVisible: !_initialAnimationComplete,
              onTap: () {
                setState(() {
                  _selectedGender = 'Woman';
                  _initialAnimationComplete = true;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 32),
        const Text(
          'WHO ARE YOU?',
          style: TextStyle(
            fontFamily: 'RobotoSlab',
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.0),
          child: Text(
            "Make sure your gender is correct. You won't be able to change it later.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'RobotoSlab',
              fontSize: 14,
              color: Colors.white70,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildAgeStep() {
    final String imagePath = _selectedGender == 'Man'
        ? 'assets/images/male_thinking.png'
        : 'assets/images/female_thinking.png';

    return GestureDetector(
      onTap: () => _selectDate(context),
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Title at Top
          const Text(
            'CHOOSE YOUR DATE OF BIRTH',
            style: TextStyle(
              fontFamily: 'RobotoSlab',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 32),

          // Image Center with Blur/Fade at bottom
          Expanded(
            flex: 5,
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Colors.white, Colors.transparent],
                  stops: [
                    0.0,
                    0.5,
                    1.0,
                  ], // Adjusted stops for more gradual/larger blur
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Blurred "Shadow" Layer
                    ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.contain,
                        color: Colors.white.withOpacity(
                          0.5,
                        ), // Whitish tint for "white shadow" feel
                        colorBlendMode: BlendMode.srcATop,
                      ),
                    ),
                    // Sharp Layer
                    Image.asset(imagePath, fit: BoxFit.contain),
                  ],
                ),
              ),
            ),
          ),

          const Spacer(),

          // Disclaimer
          const Text(
            'You have to be at least 18.',
            style: TextStyle(
              fontFamily: 'RobotoSlab',
              fontSize: 14,
              color: Colors.white70,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 16),

          // "Day | Month | Year" Text Link - Bigger, wider spacing, at bottom
          Padding(
            padding: const EdgeInsets.only(bottom: 32.0, left: 24, right: 24),
            child: SizedBox(
              height: 56, // Match standard button height
              child: Center(
                child: Text(
                  _birthDate == null
                      ? 'Day   |   Month   |   Year'
                      : '${_birthDate!.day}   |   ${_birthDate!.month}   |   ${_birthDate!.year}',
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    fontSize: 32, // Further increased size
                    fontWeight: FontWeight.w700,
                    color: _birthDate == null ? Colors.white38 : Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeightStep() {
    final String imagePath = (_selectedGender ?? 'Man') == 'Man'
        ? 'assets/images/male_shadow.png'
        : 'assets/images/female_shadow.png';

    // Calculate scale factor based on height (100cm - 250cm)
    // Base scale 1.0 at 170cm
    // Range 0.85 to 1.15
    double scale = 0.85 + ((_heightCm - 100) / 150) * 0.3;

    return Column(
      children: [
        const SizedBox(height: 16),
        const Text(
          'WHAT IS YOUR HEIGHT?',
          style: TextStyle(
            fontFamily: 'RobotoSlab',
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
            letterSpacing: 0.3,
          ),
        ),
        const Spacer(),
        Expanded(
          flex: 8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 1), // Left spacer
              Expanded(
                flex: 6,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    // Blurred Shadow Layer (The white effect)
                    Transform.scale(
                      scale: scale,
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(
                          sigmaX: 15.0,
                          sigmaY: 15.0,
                        ),
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.contain,
                          color: Colors.white.withOpacity(0.5),
                          colorBlendMode: BlendMode.srcATop,
                        ),
                      ),
                    ),
                    // Main Image Layer
                    Transform.scale(
                      scale: scale,
                      child: Image.asset(imagePath, fit: BoxFit.contain),
                    ),
                  ],
                ),
              ),
              // Arrow Buttons Logic
              Padding(
                padding: const EdgeInsets.only(
                  left: 18.0,
                ), // Increase space from image
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTapDown: (_) => _startContinuousChange(1),
                      onTapUp: (_) => _stopContinuousChange(),
                      onTapCancel: () => _stopContinuousChange(),
                      child: Container(
                        color: Colors.transparent, // Hit test expansion
                        padding: const EdgeInsets.all(8),
                        child: Image.asset(
                          'assets/images/up_arrow.png',
                          width: 40,
                          height: 120,
                          color: Colors.white,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    GestureDetector(
                      onTapDown: (_) => _startContinuousChange(-1),
                      onTapUp: (_) => _stopContinuousChange(),
                      onTapCancel: () => _stopContinuousChange(),
                      child: Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.all(8),
                        child: Image.asset(
                          'assets/images/down_arrow.png',
                          width: 40,
                          height: 120,
                          color: Colors.white,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 1), // Right spacer
            ],
          ),
        ),

        const Spacer(flex: 1), // Move spacer above the controls
        // Unit Selector
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => setState(() => _useMetric = false),
              child: Text(
                'FEET',
                style: TextStyle(
                  fontFamily: 'RobotoSlab',
                  fontSize: 16,
                  fontWeight: !_useMetric ? FontWeight.bold : FontWeight.normal,
                  color: !_useMetric ? Colors.white : Colors.white54,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '|',
                style: TextStyle(
                  fontFamily: 'RobotoSlab',
                  fontSize: 16,
                  color: Colors.white24,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => _useMetric = true),
              child: Text(
                'CM',
                style: TextStyle(
                  fontFamily: 'RobotoSlab',
                  fontSize: 16,
                  fontWeight: _useMetric ? FontWeight.bold : FontWeight.normal,
                  color: _useMetric ? Colors.white : Colors.white54,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        Text(
          'YOUR HEIGHT: $_heightDisplay',
          style: const TextStyle(
            fontFamily: 'RobotoSlab',
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 32), // Padding before the bottom button area
      ],
    );
  }

  Widget _buildInterestsStep() {
    return Column(
      children: [
        // Fixed Header
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
          child: Column(
            children: [
              Text(
                'MY GUILTY PLEASURES',
                style: TextStyle(
                  fontFamily: 'RobotoSlab',
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                  letterSpacing: 1.0,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Image.asset(
                'assets/icons/logo_transparent.png',
                height: 60,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),

        // Scrollable Grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.85, // Taller cards
              crossAxisSpacing: 12, // Increased spacing
              mainAxisSpacing: 12,
            ),
            itemCount: _guiltyPleasures.length,
            itemBuilder: (context, index) {
              final item = _guiltyPleasures[index];
              return _GuiltyPleasureCard(
                title: item['title']!,
                description: item['description']!,
                imagePath: item['image']!,
                showLottie: index == 0,
                onSelected: (isSelected) {
                  setState(() {
                    if (isSelected) {
                      _selectedInterestsIndices.add(index);
                    } else {
                      _selectedInterestsIndices.remove(index);
                    }
                  });
                },
              );
            },
          ),
        ),
        // Spacer for bottom button area (since button is fixed in parent,
        // but we might want some padding at end of scroll)
        const SizedBox(height: 0),
      ],
    );
  }

  Widget _buildNextButton() {
    bool isEnabled = false;
    if (_currentStep == 0) {
      isEnabled = _selectedGender != null;
    } else if (_currentStep == 1) {
      // Button hidden effectively by layout, but if shown, requires birthDate
      return const SizedBox.shrink(); // Hide continue button in Age step, interaction is via text/sheet
    } else if (_currentStep == 2) {
      // Height step - always enabled
      isEnabled = true;
    } else if (_currentStep == 3) {
      // Guilty pleasures step - always enabled (interaction is optional/exploratory)
      isEnabled = true;
    }

    return GestureDetector(
      onTap: isEnabled ? _nextPage : null,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: isEnabled ? AppColors.buttonBackground : Colors.white10,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            _currentStep == 3
                ? 'Continue (${_selectedInterestsIndices.length}/${_guiltyPleasures.length})'
                : 'Continue',
            style: TextStyle(
              fontFamily: 'RobotoSlab',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
              color: isEnabled ? Colors.black : Colors.white38,
            ),
          ),
        ),
      ),
    );
  }
}

class _GenderOption extends StatelessWidget {
  final String imagePath;
  final bool isSelected;
  final bool forceVisible;
  final VoidCallback onTap;

  const _GenderOption({
    required this.imagePath,
    required this.isSelected,
    this.forceVisible = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Layer: ALWAYS Blurred
          // Using RepaintBoundary to cache the expensive blur operation
          RepaintBoundary(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Image.asset(imagePath, fit: BoxFit.contain),
            ),
          ),

          // Foreground Layer: Sharp Image
          // We show this if it IS selected OR forced visible
          AnimatedOpacity(
            opacity: (isSelected || forceVisible) ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Image.asset(imagePath, fit: BoxFit.contain),
          ),
        ],
      ),
    );
  }
}

class _GuiltyPleasureCard extends StatefulWidget {
  final String title;
  final String description;
  final String imagePath;

  const _GuiltyPleasureCard({
    required this.title,
    required this.description,
    required this.imagePath,
    this.showLottie = false,
    required this.onSelected,
  });

  final bool showLottie;
  final ValueChanged<bool> onSelected;

  @override
  State<_GuiltyPleasureCard> createState() => _GuiltyPleasureCardState();
}

class _GuiltyPleasureCardState extends State<_GuiltyPleasureCard>
    with AutomaticKeepAliveClientMixin {
  double _blurSigma = 20.0; // Start with heavy blur

  void _handleTap() {
    setState(() {
      if (_blurSigma == 0.0) {
        // If fully unblurred, reset back to blurred (deselect)
        _blurSigma = 20.0;
        widget.onSelected(false);
        HapticFeedback.selectionClick();
      } else {
        // Otherwise, reduce blur
        _blurSigma = (_blurSigma - 5.0).clamp(0.0, 20.0);
        if (_blurSigma == 0.0) {
          widget.onSelected(true);
          HapticFeedback.heavyImpact();
        } else {
          HapticFeedback.selectionClick();
        }
      }
    });
  }

  void _clearBlur() {
    setState(() {
      _blurSigma = 0.0;
      widget.onSelected(true);
    });
    HapticFeedback.heavyImpact();
  }

  bool _showLottie = false;

  @override
  void initState() {
    super.initState();
    if (widget.showLottie) {
      _showLottie = true;
      // Hide Lottie after 4 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showLottie = false;
          });
        }
      });
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: _handleTap,
      onLongPress: _clearBlur,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent, // Background transparent
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.buttonBackground, // Border button color
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1. The Content (Blurred Together)
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 20.0, end: _blurSigma),
                duration: const Duration(milliseconds: 300),
                builder: (context, sigma, child) {
                  return ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Image
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 80.0, // Increased to move image up
                            top: 8.0, // Reduced to move image up
                            left: 16.0,
                            right: 16.0,
                          ),
                          child: Image.asset(
                            widget.imagePath,
                            fit: BoxFit.contain,
                          ),
                        ),
                        // Text Overlay (No Gradient)
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(12.0),
                            // Removed gradient decoration
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Invisible icon to balance the layout so title stays centered
                                    if (_blurSigma == 0)
                                      const Opacity(
                                        opacity: 0.0,
                                        child: Icon(
                                          CupertinoIcons.checkmark_alt,
                                          size: 20,
                                        ),
                                      ),
                                    if (_blurSigma == 0)
                                      const SizedBox(width: 4),

                                    Flexible(
                                      child: Text(
                                        widget.title,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontFamily: 'RobotoSlab',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: AppColors.primary,
                                        ),
                                        maxLines: 1, // Allow 1 line for title
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),

                                    if (_blurSigma == 0) ...[
                                      const SizedBox(width: 4),
                                      const Icon(
                                        CupertinoIcons
                                            .checkmark_alt, // Simple tick
                                        color: AppColors
                                            .primary, // requested primary
                                        size: 20,
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.description,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: 'RobotoSlab',
                                    fontSize: 14,
                                    color: AppColors
                                        .secondary, // Light yellow description
                                    height: 1.2,
                                  ),
                                  maxLines:
                                      2, // Allow up to 2 lines for description
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // 2. Lottie Animation (Above Blur, Larger)
              if (_showLottie)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Transform.scale(
                      scale: 1.5, // 50% larger
                      child: Lottie.asset(
                        'assets/animations/touch.json',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

              // 3. Close Icon (X Mark) - Only when fully unblurred
            ],
          ),
        ),
      ),
    );
  }
}
