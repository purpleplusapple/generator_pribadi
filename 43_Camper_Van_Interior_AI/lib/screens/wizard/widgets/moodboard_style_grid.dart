import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../theme/camper_tokens.dart';
import '../../../model/camper_style.dart';

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
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75, // Taller cards
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
              color: CamperTokens.surface,
              borderRadius: BorderRadius.circular(CamperTokens.radiusM),
              border: Border.all(
                color: isSelected ? CamperTokens.primary : CamperTokens.line,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected ? [
                BoxShadow(
                  color: CamperTokens.primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ] : [],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Moodboard Image (SVG)
                Expanded(
                  flex: 3,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(CamperTokens.radiusM - 1)),
                    child: SvgPicture.asset(
                      style.moodboardAsset,
                      fit: BoxFit.cover,
                      placeholderBuilder: (context) => Container(color: CamperTokens.bg1),
                    ),
                  ),
                ),
                // Info
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          style.name,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isSelected ? CamperTokens.primary : CamperTokens.ink0,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 4,
                          children: style.tags.take(2).map((tag) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: CamperTokens.bg0,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(tag, style: const TextStyle(fontSize: 9, color: CamperTokens.muted)),
                          )).toList(),
                        )
                      ],
                    ),
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
