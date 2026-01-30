import 'package:flutter/material.dart';
import '../../data/storage_styles.dart';
import '../../theme/storage_theme.dart';

class MoodboardStyleGrid extends StatelessWidget {
  final StorageStyle style;
  final bool isSelected;
  final VoidCallback onTap;

  const MoodboardStyleGrid({
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
          color: StorageColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? StorageColors.primaryLime : StorageColors.line,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: StorageColors.primaryLime.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            // 4-Tile Collage (AspectRatio 1:1)
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(child: _buildTile(style.tileImages[0])),
                          const SizedBox(width: 1),
                          Expanded(child: _buildTile(style.tileImages[1])),
                        ],
                      ),
                    ),
                    const SizedBox(height: 1),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(child: _buildTile(style.tileImages[2])),
                          const SizedBox(width: 1),
                          Expanded(child: _buildTile(style.tileImages[3])),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Title Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              width: double.infinity,
              color: StorageColors.surface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    style.name,
                    style: StorageTheme.darkTheme.textTheme.labelLarge?.copyWith(
                      fontSize: 12,
                      color: isSelected ? StorageColors.primaryLime : StorageColors.ink0,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    style.description,
                    style: StorageTheme.darkTheme.textTheme.bodySmall?.copyWith(fontSize: 10),
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

  Widget _buildTile(String assetPath) {
    return Image.asset(
      assetPath,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(color: StorageColors.surface2),
    );
  }
}
