import 'package:flutter/material.dart';
import '../../../../theme/camper_theme.dart';
import '../../../../widgets/glass_card.dart';

class VanStudioHeader extends StatelessWidget {
  const VanStudioHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Your Van Layout", style: CamperAIText.h2),
        const SizedBox(height: CamperAISpacing.sm),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildChip("Solo Explorer", true),
              _buildChip("Couple Cozy", false),
              _buildChip("Family Bunk", false),
              _buildChip("Digital Nomad", false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? CamperAIColors.leatherTan : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? CamperAIColors.leatherTan : CamperAIColors.laceGray.withOpacity(0.3),
          ),
        ),
        child: Text(
          label,
          style: CamperAIText.bodyMedium.copyWith(
            color: isSelected ? CamperAIColors.soleBlack : CamperAIColors.canvasWhite,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
