import 'package:flutter/material.dart';
import '../../../theme/terrace_theme.dart';
import '../../../widgets/glass_card.dart';

class SpaceSelector extends StatelessWidget {
  const SpaceSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: TerraceAISpacing.xl),
          child: Text('Your Space Size', style: TerraceAIText.h2),
        ),
        const SizedBox(height: TerraceAISpacing.md),
        SizedBox(
          height: 120,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: TerraceAISpacing.xl),
            scrollDirection: Axis.horizontal,
            children: [
              _buildOption('Small Balcony', Icons.crop_square_rounded),
              _buildOption('Narrow Strip', Icons.view_column_rounded),
              _buildOption('Rooftop', Icons.deck_rounded),
              _buildOption('Patio', Icons.grid_view_rounded),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOption(String label, IconData icon) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: TerraceAISpacing.md),
      child: GlassCard(
        padding: const EdgeInsets.all(TerraceAISpacing.md),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: TerraceAIColors.primary, size: 32),
            const SizedBox(height: TerraceAISpacing.sm),
            Text(
              label,
              style: TerraceAIText.small.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
