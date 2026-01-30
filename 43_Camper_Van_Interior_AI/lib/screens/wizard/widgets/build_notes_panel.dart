import 'package:flutter/material.dart';
import '../../../../theme/camper_theme.dart';
import '../../../../model/camper_config.dart';
import '../../../../data/camper_styles_data.dart';

class BuildNotesPanel extends StatelessWidget {
  final CamperConfig config;

  const BuildNotesPanel({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    final style = CamperStylesData.styles.firstWhere(
      (s) => s.id == config.selectedStyleId,
      orElse: () => CamperStylesData.styles.first,
    );

    // Extract key specs from params or defaults
    final vanSize = config.styleParams['van_size'] ?? 'Sprinter 144';
    final layout = config.styleParams['layout_bed'] ?? 'Fixed Rear';
    final offGrid = config.styleParams['off_grid']?.toString() ?? '50';
    final budget = config.styleParams['budget']?.toString() ?? '30k';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CamperAIColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: CamperAIShadows.modal,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.assignment, color: CamperAIColors.leatherTan),
              const SizedBox(width: 8),
              Text("Build Specifications", style: CamperAIText.h3),
            ],
          ),
          const SizedBox(height: 16),
          _buildSpecRow("Style", style.name),
          _buildSpecRow("Chassis", vanSize),
          _buildSpecRow("Layout", layout),
          _buildSpecRow("Off-Grid", "$offGrid%"),
          _buildSpecRow("Est. Budget", "\$$budget"),

          const SizedBox(height: 16),
          Text("Notes", style: CamperAIText.bodyMedium.copyWith(color: CamperAIColors.muted)),
          const SizedBox(height: 4),
          Text(
            style.description,
            style: CamperAIText.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: CamperAIText.body.copyWith(color: CamperAIColors.muted)),
          Text(value, style: CamperAIText.body.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
