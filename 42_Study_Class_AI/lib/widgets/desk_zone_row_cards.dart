import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DeskZoneRowCards extends StatelessWidget {
  const DeskZoneRowCards({super.key});

  @override
  Widget build(BuildContext context) {
    final zones = [
      {'icon': Icons.menu_book, 'title': 'Reading Desk'},
      {'icon': Icons.draw, 'title': 'Whiteboard'},
      {'icon': Icons.inventory_2, 'title': 'Storage Wall'},
      {'icon': Icons.laptop_mac, 'title': 'Minimal Desk'},
    ];

    return SizedBox(
      height: 110,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: zones.length,
        itemBuilder: (context, index) {
          final zone = zones[index];
          return Container(
            width: 100,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: StudyAIColors.surface2,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: StudyAIColors.line.withValues(alpha: 0.5)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(zone['icon'] as IconData, color: StudyAIColors.primary, size: 28),
                const SizedBox(height: 8),
                Text(
                  zone['title'] as String,
                  textAlign: TextAlign.center,
                  style: StudyAIText.label.copyWith(fontSize: 11),
                  maxLines: 2,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
