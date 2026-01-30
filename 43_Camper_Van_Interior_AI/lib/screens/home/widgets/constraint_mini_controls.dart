import 'package:flutter/material.dart';
import '../../../../theme/camper_theme.dart';

class ConstraintMiniControls extends StatelessWidget {
  const ConstraintMiniControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CamperAIColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildControl("Van Size", "Sprinter 170"),
          _buildVerticalDivider(),
          _buildControl("Budget", "\$20k-\$40k"),
          _buildVerticalDivider(),
          _buildControl("Off-Grid", "High"),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(height: 30, width: 1, color: CamperAIColors.laceGray.withOpacity(0.2));
  }

  Widget _buildControl(String label, String value) {
    return Column(
      children: [
        Text(label, style: CamperAIText.caption),
        const SizedBox(height: 4),
        Text(value, style: CamperAIText.bodyMedium.copyWith(color: CamperAIColors.leatherTan)),
      ],
    );
  }
}
