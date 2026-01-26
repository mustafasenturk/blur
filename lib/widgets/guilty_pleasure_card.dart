import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

class GuiltyPleasureCard extends StatefulWidget {
  final String title;
  final String description;
  final String imagePath;
  final bool showLottie;
  final ValueChanged<bool> onSelected;
  final bool startUnblurred;

  const GuiltyPleasureCard({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath, // Keeping parameter to avoid breaking API
    this.showLottie = false,
    required this.onSelected,
    this.startUnblurred = false,
  });

  @override
  State<GuiltyPleasureCard> createState() => _GuiltyPleasureCardState();
}

class _GuiltyPleasureCardState extends State<GuiltyPleasureCard>
    with AutomaticKeepAliveClientMixin {
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    // In profile edit/view mode, we might want to show if it's already selected.
    // However, the previous logic was about "revealing" it.
    // For now, start unselected unless we pass initial selection state,
    // but the widget API doesn't have 'initialSelected'.
    // We will assume startUnblurred implies "selected/revealed" or just handle local toggle.
    // If this is used in Profile Screen list where we just view them, we might need a read-only mode,
    // but based on `ProfileScreen` usage, it seems interactive.
    if (widget.startUnblurred) {
      _isSelected = true;
    }
  }

  void _handleTap() {
    setState(() {
      _isSelected = !_isSelected;
      widget.onSelected(_isSelected);
      HapticFeedback.selectionClick();
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: _isSelected
              ? AppColors.primary
              : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(30), // Bubble shape
          border: Border.all(
            color: _isSelected ? AppColors.primary : Colors.white24,
            width: 1,
          ),
        ),
        child: Text(
          widget.title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'RobotoSlab',
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: _isSelected ? Colors.black87 : Colors.white,
          ),
        ),
      ),
    );
  }
}
