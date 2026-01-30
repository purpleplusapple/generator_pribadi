import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StudyDashboardHeader extends StatelessWidget {
  final String currentVibe;
  final ValueChanged<String> onVibeChanged;

  const StudyDashboardHeader({
    super.key,
    required this.currentVibe,
    required this.onVibeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Study Mode',
            style: StudyAIText.h3.copyWith(color: StudyAIColors.muted),
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              'Deep Focus',
              'Cozy',
              'Bright',
              'Minimal',
            ].map((vibe) {
              final isSelected = currentVibe == vibe;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(vibe),
                  selected: isSelected,
                  onSelected: (val) {
                    if (val) onVibeChanged(vibe);
                  },
                  backgroundColor: StudyAIColors.surface,
                  selectedColor: StudyAIColors.primary,
                  labelStyle: TextStyle(
                    color: isSelected ? StudyAIColors.bg0 : StudyAIColors.ink1,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected ? Colors.transparent : StudyAIColors.line,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
