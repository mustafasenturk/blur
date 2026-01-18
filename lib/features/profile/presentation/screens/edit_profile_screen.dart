import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../../theme/app_colors.dart';
import 'dart:math';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();

  // Selection States
  String _selectedGender = 'Male';
  String _selectedSexuality = 'Straight';
  int _selectedAge = 18;
  int _selectedHeight = 170; // cm

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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontFamily: 'RobotoSlab',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // USERNAME SECTION
            _buildSectionLabel(Icons.alternate_email, "Nickname"),
            const SizedBox(height: 8),
            const Text(
              "Nickname will be shown in chat",
              style: TextStyle(
                fontFamily: 'RobotoSlab',
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: TextField(
                controller: _usernameController,
                style: const TextStyle(
                  fontFamily: 'RobotoSlab',
                  color: Colors.white,
                  fontSize: 16,
                ),
                maxLength: 32,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  counterText: "", // Hide counter
                  hintText: "Enter nickname",
                  hintStyle: TextStyle(color: Colors.white24),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _generateNickname,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Generate nickname",
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    color: Colors.black, // Dark text on Gold
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // GENDER SECTION
            _buildDropdownTile(
              label: "My gender",
              value: _selectedGender,
              icon: Icons.person_outline,
              onTap: () => _showSelectionSheet(
                title: "My gender",
                subtitle: "Choose your gender to get better matches",
                options: _genders,
                currentValue: _selectedGender,
                onSelected: (val) => setState(() => _selectedGender = val),
              ),
            ),

            const SizedBox(height: 24),

            // SEXUALITY SECTION
            _buildDropdownTile(
              label: "Sexuality",
              value: _selectedSexuality,
              icon: Icons.favorite_border,
              onTap: () => _showSelectionSheet(
                title: "Sexuality",
                subtitle: "Select your sexual orientation",
                options: _sexualities,
                currentValue: _selectedSexuality,
                onSelected: (val) => setState(() => _selectedSexuality = val),
              ),
            ),

            const SizedBox(height: 24),

            // AGE SECTION
            _buildDropdownTile(
              label: "Age",
              value: "$_selectedAge years",
              icon: Icons.cake_outlined,
              onTap: _showAgePicker,
            ),

            const SizedBox(height: 24),

            // HEIGHT SECTION
            _buildDropdownTile(
              label: "Height",
              value: "$_selectedHeight cm",
              icon: Icons.height,
              onTap: _showHeightPicker,
            ),

            const SizedBox(height: 48),

            // SAVE BUTTON (Optional, typically autosave or manual save)
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement save logic
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonBackground,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Save Changes",
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontFamily: 'RobotoSlab',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownTile({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
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
            Icon(icon, color: Colors.white70, size: 24),
            const SizedBox(width: 16),
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
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white24,
              size: 16,
            ),
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
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline, // Generic icon, maybe pass it in
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'RobotoSlab',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
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

  void _showAgePicker() {
    // Simple integer picker for Age
    final FixedExtentScrollController scrollController =
        FixedExtentScrollController(initialItem: _selectedAge - 18);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 300,
        decoration: const BoxDecoration(
          color: AppColors.backgroundDark,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Select Age",
                    style: TextStyle(
                      fontFamily: 'RobotoSlab',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Done",
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoPickerWrapper(
                scrollController: scrollController,
                onSelectedItemChanged: (index) {
                  setState(() {
                    _selectedAge = 18 + index;
                  });
                },
                children: List.generate(
                  82,
                  (index) => Center(
                    child: Text(
                      "${18 + index}",
                      style: const TextStyle(
                        fontFamily: 'RobotoSlab',
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ), // 18 to 99
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showHeightPicker() {
    // Simple integer picker for Height
    final FixedExtentScrollController scrollController =
        FixedExtentScrollController(initialItem: _selectedHeight - 100);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 300,
        decoration: const BoxDecoration(
          color: AppColors.backgroundDark,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Select Height",
                    style: TextStyle(
                      fontFamily: 'RobotoSlab',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Done",
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoPickerWrapper(
                scrollController: scrollController,
                onSelectedItemChanged: (index) {
                  setState(() {
                    _selectedHeight = 100 + index;
                  });
                },
                children: List.generate(
                  151,
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
                ), // 100 to 250
              ),
            ),
          ],
        ),
      ),
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
        decoration: BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(color: Colors.white24, width: 0.5),
          ),
        ),
      ),
      children: children,
    );
  }
}
