import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/guest_theme.dart';
import '../model/guest_style_definition.dart';

class MoodboardStyleCard extends StatelessWidget {
  final GuestStyleDefinition style;
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
          color: GuestAIColors.pureWhite,
          borderRadius: BorderRadius.circular(GuestAIRadii.regular),
          border: Border.all(
            color: isSelected ? GuestAIColors.brass : GuestAIColors.line,
            width: isSelected ? 3 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: GuestAIColors.brass.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 2x2 Grid Collage
            AspectRatio(
              aspectRatio: 1.0,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(GuestAIRadii.regular - 1)),
                child: _buildGrid(),
              ),
            ),

            // Text Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    style.name,
                    style: GuestAIText.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: style.tags.take(3).map((tag) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: GuestAIColors.softSurface,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        tag.toUpperCase(),
                        style: GuestAIText.small.copyWith(fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                    )).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid() {
    // We expect 4 images in tileImages
    // If not, we fallback safely
    final images = style.tileImages.take(4).toList();
    while (images.length < 4) {
      // Pad with first image or placeholder if list is empty
      if (images.isNotEmpty) {
        images.add(images[0]);
      } else {
        // Absolute fallback (shouldn't happen with our data)
        return Container(color: GuestAIColors.muted);
      }
    }

    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildTile(images[0])),
              const SizedBox(width: 2),
              Expanded(child: _buildTile(images[1])),
            ],
          ),
        ),
        const SizedBox(height: 2),
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildTile(images[2])),
              const SizedBox(width: 2),
              Expanded(child: _buildTile(images[3])),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTile(String path) {
    return Image.asset(
      path,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(color: GuestAIColors.softSurface, child: const Icon(Icons.error, size: 16));
      },
    );
  }
}
