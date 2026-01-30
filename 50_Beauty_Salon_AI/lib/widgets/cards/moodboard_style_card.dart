import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../model/beauty_config.dart';
import '../../theme/beauty_theme.dart';
import '../../theme/beauty_tokens.dart';

class MoodboardStyleCard extends StatelessWidget {
  final BeautyStyle style;
  final bool isSelected;
  final VoidCallback onTap;

  const MoodboardStyleCard({
    super.key,
    required this.style,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(BeautyTokens.radiusM),
          border: isSelected
              ? Border.all(color: BeautyTheme.primary, width: 2)
              : Border.all(color: Colors.transparent, width: 2),
          boxShadow: isSelected ? BeautyTokens.shadowSoft : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(BeautyTokens.radiusM - 2)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    SvgPicture.asset(
                      style.moodboardImage,
                      fit: BoxFit.cover,
                      placeholderBuilder: (_) => Container(
                        color: BeautyTheme.bg0,
                        child: const Center(child: Icon(Icons.image, color: BeautyTheme.muted)),
                      ),
                    ),
                    if (isSelected)
                      Container(
                        color: BeautyTheme.primary.withOpacity(0.1),
                        child: const Center(
                          child: Icon(Icons.check_circle, color: BeautyTheme.primary, size: 32),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                style.name,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? BeautyTheme.primary : BeautyTheme.ink1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
