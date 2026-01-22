import 'package:flutter/material.dart';
import '../theme/beauty_salon_ai_theme.dart';

class EditorialLookCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const EditorialLookCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: BeautyAIMotion.fast,
        padding: const EdgeInsets.all(BeautyAISpacing.md),
        decoration: BoxDecoration(
          color: isSelected ? BeautyAIColors.primary : BeautyAIColors.surface,
          borderRadius: BeautyAIRadii.mdRadius,
          border: Border.all(
            color: isSelected ? BeautyAIColors.primary : BeautyAIColors.line,
            width: 1,
          ),
          boxShadow: isSelected ? BeautyAIShadows.floating : BeautyAIShadows.soft,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.2)
                    : BeautyAIColors.bg0,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : BeautyAIColors.primary,
                size: 24,
              ),
            ),
            const Spacer(),
            Text(
              title,
              style: BeautyAIText.bodyMedium.copyWith(
                color: isSelected ? Colors.white : BeautyAIColors.ink0,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: BeautyAIText.caption.copyWith(
                color: isSelected ? Colors.white.withValues(alpha: 0.8) : BeautyAIColors.muted,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
