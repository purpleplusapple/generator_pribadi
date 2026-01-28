import 'package:flutter/material.dart';
import '../../../theme/terrace_theme.dart';

class NightUploadAssist extends StatelessWidget {
  const NightUploadAssist({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TerraceAISpacing.lg),
      decoration: BoxDecoration(
        color: TerraceAIColors.surface.withValues(alpha: 0.5),
        borderRadius: TerraceAIRadii.mdRadius,
        border: Border.all(color: TerraceAIColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline_rounded, color: TerraceAIColors.accent, size: 20),
              const SizedBox(width: 8),
              Text('Night Photo Tips', style: TerraceAIText.h3.copyWith(fontSize: 16)),
            ],
          ),
          const SizedBox(height: TerraceAISpacing.md),
          _buildCheckItem('Turn on some existing lights for ambiance'),
          _buildCheckItem('Stand in a corner to capture more space'),
          _buildCheckItem('Keep the floor visible'),
          _buildCheckItem('Avoid using flash against glass'),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TerraceAISpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline_rounded, color: TerraceAIColors.success, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TerraceAIText.body.copyWith(fontSize: 14, color: TerraceAIColors.ink1),
            ),
          ),
        ],
      ),
    );
  }
}
