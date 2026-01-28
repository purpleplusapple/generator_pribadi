import 'package:flutter/material.dart';
import '../../../theme/terrace_theme.dart';
import '../../../widgets/terrace_chip.dart';

class TonightHeader extends StatelessWidget {
  final Function(String) onMoodSelected;

  const TonightHeader({
    super.key,
    required this.onMoodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TerraceAISpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.nights_stay_rounded,
                color: TerraceAIColors.accent,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'GOOD EVENING',
                style: TerraceAIText.small.copyWith(
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w700,
                  color: TerraceAIColors.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: TerraceAISpacing.sm),
          Text(
            'Tonight on\nYour Terrace',
            style: TerraceAIText.h1,
          ),
          const SizedBox(height: TerraceAISpacing.lg),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                TerraceChip(label: 'Cozy', isSelected: true, onTap: () => onMoodSelected('Cozy')),
                const SizedBox(width: 8),
                TerraceChip(label: 'Party', isSelected: false, onTap: () => onMoodSelected('Party')),
                const SizedBox(width: 8),
                TerraceChip(label: 'Romantic', isSelected: false, onTap: () => onMoodSelected('Romantic')),
                const SizedBox(width: 8),
                TerraceChip(label: 'Zen', isSelected: false, onTap: () => onMoodSelected('Zen')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
