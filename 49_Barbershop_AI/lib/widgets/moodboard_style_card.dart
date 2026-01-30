import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/barber_theme.dart';
import '../model/barber_style.dart';

class MoodboardStyleCard extends StatelessWidget {
  final BarberStyle style;
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
      child: Container(
        decoration: BoxDecoration(
          color: BarberTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: BarberTheme.primary, width: 2)
              : Border.all(color: BarberTheme.line, width: 1),
          boxShadow: isSelected
              ? [BoxShadow(color: BarberTheme.primary.withOpacity(0.3), blurRadius: 12)]
              : [],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 4-tile Moodboard Image
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  SvgPicture.asset(
                    style.moodboardAsset,
                    fit: BoxFit.cover,
                  ),
                  if (isSelected)
                    Container(
                      color: BarberTheme.primary.withOpacity(0.2),
                      child: const Center(
                        child: Icon(Icons.check_circle, color: BarberTheme.primary, size: 32),
                      ),
                    ),
                ],
              ),
            ),
            // Title & Desc
            Container(
              padding: const EdgeInsets.all(12),
              color: BarberTheme.surface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    style.name,
                    style: BarberTheme.themeData.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    style.description,
                    style: BarberTheme.themeData.textTheme.labelMedium?.copyWith(
                      color: BarberTheme.muted,
                      fontSize: 11,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
