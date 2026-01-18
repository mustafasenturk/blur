import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';

/// Gender filter widget for discovery
class GenderFilter extends StatelessWidget {
  const GenderFilter({
    super.key,
    required this.selectedGender,
    required this.onChanged,
  });

  final String selectedGender;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          _buildOption(
            'Male',
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(8),
            ),
            showPremiumIcon: true,
          ),
          Container(width: 1, color: Colors.white12),
          _buildOption('Everyone'),
          Container(width: 1, color: Colors.white12),
          _buildOption(
            'Female',
            borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(8),
            ),
            showPremiumIcon: true,
          ),
        ],
      ),
    );
  }

  Widget _buildOption(
    String gender, {
    BorderRadius? borderRadius,
    bool showPremiumIcon = false,
  }) {
    final isSelected = selectedGender == gender;

    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(gender),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withOpacity(0.2) : null,
            borderRadius: borderRadius,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (showPremiumIcon && gender == 'Male') ...[
                Image.asset('assets/images/coin.png', width: 16, height: 16),
                const SizedBox(width: 4),
              ],
              Text(
                gender,
                style: TextStyle(
                  fontFamily: 'RobotoSlab',
                  color: isSelected ? AppColors.primary : Colors.white70,
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              if (showPremiumIcon && gender == 'Female') ...[
                const SizedBox(width: 4),
                Image.asset('assets/images/coin.png', width: 16, height: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
