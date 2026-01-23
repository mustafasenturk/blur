import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/user_provider.dart';
import '../../../../theme/app_colors.dart';
import 'dart:math';

import '../../../../widgets/gradient_app_bar.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();

  // Selection States
  String _selectedGender = 'Male';
  String _selectedSexuality = 'Straight';
  DateTime _selectedDate = DateTime.now().subtract(
    const Duration(days: 365 * 18),
  );
  int _selectedHeight = 170; // cm
  bool _useMetric = true;

  String get _formattedHeight {
    if (_useMetric) {
      return "$_selectedHeight cm";
    } else {
      final totalInches = (_selectedHeight / 2.54).round();
      final feet = totalInches ~/ 12;
      final inches = totalInches % 12;
      return "$feet' $inches\"";
    }
  }

  // User to provide 100 male/100 female nicknames
  final List<String> _maleNicknames = [
    'AlphaWolf',
    'NightRider',
    'ShadowHunter',
    'IronFist',
    'StormBreaker',
    'LoneRanger',
    'Maverick',
    'GhostWalker',
    'ThunderStrike',
    'SteelHeart',
    'DarkKnight',
    'BladeRunner',
    'CyberPunk',
    'NeonViper',
    'VoidWalker',
    'CrimsonFury',
    'SolarFlare',
    'LunarEclipse',
    'StarLord',
    'GalaxyGuardian',
    'VenomFang',
    'CobraStrike',
    'HawkEye',
    'EagleSoar',
    'FalconDive',
    'TigerClaw',
    'LionHeart',
    'BearForce',
    'WolfPack',
    'FoxCunning',
    'DragonBreath',
    'PhoenixRise',
    'GriffinWing',
    'HydraHead',
    'TitanSmash',
    'AtlasHold',
    'ZeusBolt',
    'HadesFire',
    'PoseidonWave',
    'AresWar',
    'ApolloSun',
    'HermesSpeed',
    'ThorHammer',
    'LokiTrick',
    'OdinSight',
    'SpartanSpirit',
    'VikingRage',
    'SamuraiSoul',
    'NinjaStealth',
    'PirateKing',
    'CyberGhost',
    'TechTitan',
    'CodeBreaker',
    'DataMiner',
    'NetSurfer',
    'PixelMaster',
    'GlitchGamer',
    'RetroRider',
    'ArcadeAce',
    'ConsoleCmdr',
    'BassDrop',
    'RhythmRider',
    'BeatBoxer',
    'SoundWave',
    'MelodyMaker',
    'GuitarHero',
    'DrumMajor',
    'SynthWave',
    'VibeMaster',
    'GrooveKing',
    'SpeedDemon',
    'RoadWarrior',
    'TrackStar',
    'DriftKing',
    'NitroBoost',
    'TurboCharger',
    'GearHead',
    'MotorMouth',
    'PistonPunch',
    'RedLine',
    'AcePilot',
    'SkyWalker',
    'CloudSurfer',
    'JetStream',
    'SonicBoom',
    'CosmicRay',
    'AstroBoy',
    'GalaxyQuest',
    'StarTrekker',
    'SpaceInvader',
    'MountainMan',
    'RiverRat',
    'OceanSoul',
    'DesertFox',
    'JungleCat',
    'ArcticWolf',
    'UrbanLegend',
    'StreetSmart',
    'CitySlicker',
    'MetroMan',
    'NightOwl',
    'EarlyBird',
    'TimeTraveler',
    'DimensionHopper',
    'RealmWalker',
  ];

  final List<String> _femaleNicknames = [
    'MoonLight',
    'StarDust',
    'RoseGold',
    'SilverLining',
    'CrystalGaze',
    'VelvetTouch',
    'DiamondSky',
    'OceanEyes',
    'RubyRed',
    'SapphireBlue',
    'EmeraldCity',
    'PearlWhite',
    'AmethystGem',
    'TopazShine',
    'OpalFire',
    'MidnightMuse',
    'TwilightSparkle',
    'DawnBreaker',
    'SunsetGlow',
    'AuroraBorealis',
    'MysticRiver',
    'SecretGarden',
    'EnchantedForest',
    'FairyDust',
    'PixieHollow',
    'AngelWings',
    'DemonSlayer',
    'VampireQueen',
    'WitchyVibes',
    'SorceressSoul',
    'GalaxyGirl',
    'CosmicCutie',
    'StarGazer',
    'PlanetHopper',
    'CometTail',
    'NebulaCloud',
    'SuperNova',
    'BlackHole',
    'StarlightExpress',
    'MilkyWay',
    'FlowerPower',
    'DaisyDuke',
    'LilyPad',
    'RosePetal',
    'TulipTime',
    'SunflowerSmile',
    'VioletFemme',
    'JasmineScent',
    'OrchidBloom',
    'LotusFlower',
    'HoneyBee',
    'ButterflyKiss',
    'DragonflyDream',
    'LadyBug',
    'FireFly',
    'KittyCat',
    'PuppyLove',
    'BunnyHop',
    'FoxyLady',
    'WolfWoman',
    'SweetHeart',
    'LoveBird',
    'CupidArrow',
    'HeartBreaker',
    'SoulMate',
    'DreamCatcher',
    'HopeFloats',
    'FaithKeeper',
    'CharityGrace',
    'JoyRide',
    'MusicMuse',
    'DanceDiva',
    'PopPrincess',
    'RockChick',
    'JazzBaby',
    'ArtisticSoul',
    'PoeticJustice',
    'StoryTeller',
    'DramaQueen',
    'MovieStar',
    'Fashionista',
    'StyleIcon',
    'GlamourGirl',
    'ChicDee',
    'TrendSetter',
    'BeachBabe',
    'SurferGirl',
    'MermaidTail',
    'SirenSong',
    'CoralReef',
    'SnowBunny',
    'IcePrincess',
    'WinterWonder',
    'AutumnLeaves',
    'SummerBreeze',
    'SpringFling',
    'RainDrop',
    'CloudNine',
    'SkyHigh',
    'WindWalker',
  ];

  final List<String> _genders = ['Male', 'Female', 'Unknown'];

  final List<String> _sexualities = [
    'Straight',
    'Homosexual',
    'Bisexual',
    'Asexual',
    'Queer',
  ];

  @override
  void initState() {
    super.initState();
    // Initialize with existing data if available (Mock for now)
    _usernameController.text = "Gallant Explorer";
    // Sync local state with provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final isMale = ref.read(userProvider).isMale;
      setState(() {
        _selectedGender = isMale ? 'Male' : 'Female';
      });
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _generateNickname() {
    final random = Random();
    List<String> sourceList = _selectedGender == 'Female'
        ? _femaleNicknames
        : _maleNicknames; // Default to male if unknown/other or logic needed

    // If gender is Unknown, maybe mix both? Or default to Male list for now as per prompt "100 male 100 female"
    if (_selectedGender == 'Unknown') {
      sourceList = [..._maleNicknames, ..._femaleNicknames];
    }

    final newName = sourceList[random.nextInt(sourceList.length)];
    setState(() {
      _usernameController.text = newName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: GradientAppBar(
        title: 'Edit Profile',
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton(
              onPressed: () {
                // TODO: Implement save logic
                context.pop();
              },
              child: const Text(
                'Done',
                style: TextStyle(
                  fontFamily: 'RobotoSlab',
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // USERNAME SECTION
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Nickname",
                          style: TextStyle(
                            fontFamily: 'RobotoSlab',
                            fontSize: 12,
                            color: Colors.white54,
                          ),
                        ),
                        TextField(
                          controller: _usernameController,
                          style: const TextStyle(
                            fontFamily: 'RobotoSlab',
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLength: 32,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide.none,
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide.none,
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Theme.of(
                              context,
                            ).scaffoldBackgroundColor,
                            counterText: "", // Hide counter
                            hintText: "Enter nickname",
                            hintStyle: const TextStyle(color: Colors.white24),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            isDense: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(
                      Icons.refresh,
                      color: AppColors.primary,
                      size: 24,
                    ),
                    onPressed: _generateNickname,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.only(left: 4.0),
              child: Text(
                "Nickname will be shown in chat",
                style: TextStyle(
                  fontFamily: 'RobotoSlab',
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // GENDER SECTION
            _buildDropdownTile(
              label: "My gender",
              value: _selectedGender,
              onTap: () => _showSelectionSheet(
                title: "My gender",
                options: _genders,
                currentValue: _selectedGender,
                onSelected: (val) {
                  setState(() => _selectedGender = val);
                  // Update global provider
                  if (val == 'Male') {
                    ref.read(userProvider.notifier).setGender(true);
                  } else if (val == 'Female') {
                    ref.read(userProvider.notifier).setGender(false);
                  }
                },
              ),
            ),

            const SizedBox(height: 24),

            // DATE OF BIRTH SECTION
            _buildDropdownTile(
              label: "Date Of Birth",
              value:
                  "${_selectedDate.day} | ${_selectedDate.month} | ${_selectedDate.year}",
              onTap: () => _selectDate(context),
            ),

            const SizedBox(height: 24),

            // SEXUALITY SECTION
            _buildDropdownTile(
              label: "Sexuality",
              value: _selectedSexuality,
              onTap: () => _showSelectionSheet(
                title: "Sexuality",
                options: _sexualities,
                currentValue: _selectedSexuality,
                onSelected: (val) => setState(() => _selectedSexuality = val),
              ),
            ),

            const SizedBox(height: 24),

            // HEIGHT SECTION
            _buildDropdownTile(
              label: "Height",
              value: _formattedHeight,
              onTap: _showHeightPicker,
            ),

            const SizedBox(height: 24),

            // LOCATION SECTION
            _buildDropdownTile(
              label: "Location",
              value: "Istanbul, Turkey",
              onTap: () {}, // No action
              icon: Icons.refresh,
              iconColor: AppColors.primary,
            ),

            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownTile({
    required String label,
    required String value,
    required VoidCallback onTap,
    IconData? icon,
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'RobotoSlab',
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontFamily: 'RobotoSlab',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Icon(
              icon ?? Icons.arrow_forward_ios,
              color: iconColor ?? Colors.white24,
              size: icon == Icons.refresh
                  ? 24
                  : 16, // Slightly larger for refresh icon
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  void _showSelectionSheet({
    required String title,
    String? subtitle,
    required List<String> options,
    required String currentValue,
    required Function(String) onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: const BoxDecoration(
          color: AppColors.backgroundDark,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'RobotoSlab',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, color: AppColors.primary),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontFamily: 'RobotoSlab',
                        fontSize: 14,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options[index];
                  final isSelected = option == currentValue;

                  return InkWell(
                    onTap: () {
                      onSelected(option);
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected
                            ? Border.all(
                                color: AppColors.primary.withOpacity(0.5),
                              )
                            : null,
                      ),
                      child: Row(
                        children: [
                          Text(
                            option,
                            style: TextStyle(
                              fontFamily: 'RobotoSlab',
                              fontSize: 16,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: isSelected ? Colors.white : Colors.white70,
                            ),
                          ),
                          const Spacer(),
                          if (isSelected)
                            const Icon(Icons.check, color: AppColors.primary),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _selectDate(BuildContext context) {
    final DateTime today = DateTime.now();
    final DateTime lastDate = DateTime(today.year - 18, today.month, today.day);
    DateTime initialDate = _selectedDate;
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
                        setState(() {
                          // Ensure we save the date if it hasn't changed from initial
                          if (_selectedDate.isAfter(lastDate)) {
                            _selectedDate = lastDate;
                          }
                        });
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
                        fontSize: 22,
                      ),
                    ),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: initialDate,
                      maximumDate: lastDate,
                      minimumDate: DateTime(1900),
                      onDateTimeChanged: (DateTime newDate) {
                        setState(() => _selectedDate = newDate);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showHeightPicker() {
    // 100 cm to 250 cm
    // 100 cm = approx 3'3"
    // 250 cm = approx 8'2"

    bool tempIsMetric = _useMetric; // Changed from isMetric to tempIsMetric
    int tempHeightCm = _selectedHeight;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            // Calculate initial item index based on current unit
            int initialItemIndex = 0;
            if (tempIsMetric) {
              // Changed from isMetric to tempIsMetric
              initialItemIndex = tempHeightCm - 100;
            } else {
              // Convert current cm to total inches, then find offset from base 3'3" (39 inches)
              final totalInches = (tempHeightCm / 2.54).round();
              // Base is 100cm ~ 39 inches
              const baseInches = 39;
              initialItemIndex = (totalInches - baseInches).clamp(0, 60);
              // max 250cm ~ 98 inches. 98 - 39 = 59.
            }

            final FixedExtentScrollController scrollController =
                FixedExtentScrollController(initialItem: initialItemIndex);

            return Container(
              height: 350,
              decoration: const BoxDecoration(
                color: AppColors.backgroundDark,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(top: 12),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12,
                    ),
                    child: Stack(
                      // Replaced existing Row with Stack
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            "Select Height",
                            style: TextStyle(
                              fontFamily: 'RobotoSlab',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setModalState(() {
                                  tempIsMetric = true;
                                });
                              },
                              child: Text(
                                "CM",
                                style: TextStyle(
                                  fontFamily: 'RobotoSlab',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: tempIsMetric
                                      ? Colors.white
                                      : Colors.white24,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                "|",
                                style: TextStyle(
                                  color: Colors.white24,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setModalState(() {
                                  tempIsMetric = false;
                                });
                              },
                              child: Text(
                                "FEET",
                                style: TextStyle(
                                  fontFamily: 'RobotoSlab',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: !tempIsMetric
                                      ? Colors.white
                                      : Colors.white24,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                _selectedHeight = tempHeightCm;
                                _useMetric = tempIsMetric; // Updated _useMetric
                              });
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Done",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontFamily: 'RobotoSlab',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: CupertinoPickerWrapper(
                      // Key forces recreation when unit changes, preventing controller mismatch
                      key: ValueKey(
                        tempIsMetric,
                      ), // Changed from isMetric to tempIsMetric
                      scrollController: scrollController,
                      onSelectedItemChanged: (index) {
                        if (tempIsMetric) {
                          // Changed from isMetric to tempIsMetric
                          tempHeightCm = 100 + index;
                        } else {
                          // Base is 39 inches (3'3")
                          // Index adds inches
                          int totalInches = 39 + index;
                          // Convert back to CM for storage
                          tempHeightCm = (totalInches * 2.54).round();
                        }
                      },
                      children:
                          tempIsMetric // Changed from isMetric to tempIsMetric
                          ? List.generate(
                              151, // 100 to 250 inclusive
                              (index) => Center(
                                child: Text(
                                  "${100 + index} cm",
                                  style: const TextStyle(
                                    fontFamily: 'RobotoSlab',
                                    color: Colors.white,
                                    fontSize: 22,
                                  ),
                                ),
                              ),
                            )
                          : List.generate(
                              60, // Approx 3'3" (39") to 8'2" (98"). 98-39 = 59 items. let's say 60.
                              (index) {
                                int totalInches = 39 + index;
                                int feet = totalInches ~/ 12;
                                int inches = totalInches % 12;
                                return Center(
                                  child: Text(
                                    "$feet' $inches\"",
                                    style: const TextStyle(
                                      fontFamily: 'RobotoSlab',
                                      color: Colors.white,
                                      fontSize: 22,
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// Helper wrapper for CupertinoPicker style
class CupertinoPickerWrapper extends StatelessWidget {
  final List<Widget> children;
  final ValueChanged<int> onSelectedItemChanged;
  final FixedExtentScrollController? scrollController;

  const CupertinoPickerWrapper({
    super.key,
    required this.children,
    required this.onSelectedItemChanged,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPicker(
      scrollController: scrollController,
      itemExtent: 40,
      diameterRatio: 1.2,
      onSelectedItemChanged: onSelectedItemChanged,
      selectionOverlay: Container(
        decoration: const BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(color: Colors.white24, width: 1),
          ),
        ),
      ),
      children: children,
    );
  }
}
