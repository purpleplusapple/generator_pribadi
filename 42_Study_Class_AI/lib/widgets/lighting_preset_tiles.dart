import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LightingPresetTiles extends StatelessWidget {
  const LightingPresetTiles({super.key});

  @override
  Widget build(BuildContext context) {
    final presets = [
      {'color': Colors.amber, 'title': 'Task Lamp'},
      {'color': Colors.lightBlueAccent, 'title': 'Daylight'},
      {'color': Colors.orangeAccent, 'title': 'Warm Cozy'},
      {'color': Colors.indigoAccent, 'title': 'Night Study'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: presets.map((preset) {
          return Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: StudyAIColors.surface,
                  boxShadow: [
                    BoxShadow(
                      color: (preset['color'] as Color).withValues(alpha: 0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: Icon(Icons.lightbulb, color: preset['color'] as Color),
              ),
              const SizedBox(height: 8),
              Text(
                preset['title'] as String,
                style: StudyAIText.label.copyWith(fontSize: 10),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
