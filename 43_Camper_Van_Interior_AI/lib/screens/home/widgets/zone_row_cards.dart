import 'package:flutter/material.dart';
import '../../../../theme/camper_theme.dart';

class ZoneRowCards extends StatelessWidget {
  const ZoneRowCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Design Zones", style: CamperAIText.h3),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildCard("Kitchen", Icons.kitchen),
              _buildCard("Sleeping", Icons.bed),
              _buildCard("Storage", Icons.inventory_2),
              _buildCard("Work", Icons.laptop),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCard(String title, IconData icon) {
    return Container(
      width: 100,
      height: 100,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: CamperAIColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: CamperAIColors.laceGray.withOpacity(0.1)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: CamperAIColors.leatherTan, size: 32),
          const SizedBox(height: 8),
          Text(title, style: CamperAIText.bodyMedium),
        ],
      ),
    );
  }
}
