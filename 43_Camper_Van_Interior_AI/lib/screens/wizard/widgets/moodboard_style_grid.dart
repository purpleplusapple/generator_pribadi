import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../theme/camper_theme.dart';
import '../../../../model/camper_style_def.dart';

class MoodboardStyleGrid extends StatelessWidget {
  final List<CamperStyle> styles;
  final String? selectedStyleId;
  final Function(CamperStyle) onStyleSelected;

  const MoodboardStyleGrid({
    super.key,
    required this.styles,
    required this.selectedStyleId,
    required this.onStyleSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: styles.length,
      itemBuilder: (context, index) {
        final style = styles[index];
        final isSelected = style.id == selectedStyleId;

        return GestureDetector(
          onTap: () => onStyleSelected(style),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected ? CamperAIColors.leatherTan : CamperAIColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: isSelected
                  ? Border.all(color: CamperAIColors.metallicGold, width: 2)
                  : Border.all(color: Colors.transparent),
              boxShadow: isSelected ? CamperAIShadows.goldGlow(opacity: 0.2) : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                    child: Stack(
                      children: [
                        // SVG Moodboard
                         SvgPicture.asset(
                           style.moodboardImage,
                           fit: BoxFit.cover,
                           width: double.infinity,
                           height: double.infinity,
                           placeholderBuilder: (ctx) => Container(color: CamperAIColors.surface2),
                         ),

                        // Selected Overlay
                        if (isSelected)
                          Container(
                            color: CamperAIColors.leatherTan.withOpacity(0.3),
                            child: const Center(
                              child: Icon(Icons.check_circle, color: CamperAIColors.soleBlack, size: 32),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        style.name,
                        style: CamperAIText.bodyMedium.copyWith(
                          color: isSelected ? CamperAIColors.soleBlack : CamperAIColors.canvasWhite,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        style.tags.firstOrNull ?? "Style",
                        style: CamperAIText.caption.copyWith(
                          color: isSelected ? CamperAIColors.soleBlack.withOpacity(0.7) : CamperAIColors.muted,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
