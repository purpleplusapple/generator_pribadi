import 'package:flutter/material.dart';
import '../../theme/terrace_theme.dart';

class TerraceMoodHeader extends StatelessWidget {
  const TerraceMoodHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(TerraceSpacing.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tonight on Your',
            style: TerraceText.h2.copyWith(fontWeight: FontWeight.w400, color: TerraceColors.laceGray),
          ),
          Text(
            'Terrace',
            style: TerraceText.h1.copyWith(color: TerraceColors.metallicGold),
          ),
          const SizedBox(height: TerraceSpacing.md),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _MoodChip(label: 'Cozy', isSelected: true),
                _MoodChip(label: 'Minimal'),
                _MoodChip(label: 'Jungle'),
                _MoodChip(label: 'Party'),
                _MoodChip(label: 'Romantic'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MoodChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _MoodChip({required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: TerraceSpacing.sm),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? TerraceColors.metallicGold : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? TerraceColors.metallicGold : TerraceColors.laceGray.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? TerraceColors.soleBlack : TerraceColors.canvasWhite,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }
}
