import 'package:flutter/material.dart';
import '../theme/hotel_room_ai_theme.dart';

class MoodBoardStaggeredGrid extends StatelessWidget {
  final List<MoodBoardItem> items;
  final Function(MoodBoardItem) onTap;

  const MoodBoardStaggeredGrid({
    super.key,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final leftColumn = <Widget>[];
    final rightColumn = <Widget>[];

    for (int i = 0; i < items.length; i++) {
      final widget = _MoodCard(item: items[i], onTap: () => onTap(items[i]));
      if (i % 2 == 0) {
        leftColumn.add(widget);
        leftColumn.add(const SizedBox(height: HotelAISpacing.base));
      } else {
        rightColumn.add(widget);
        rightColumn.add(const SizedBox(height: HotelAISpacing.base));
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(children: leftColumn),
        ),
        const SizedBox(width: HotelAISpacing.base),
        Expanded(
          child: Column(children: rightColumn),
        ),
      ],
    );
  }
}

class MoodBoardItem {
  final String id;
  final String title;
  final String imageUrl;
  final String category;
  final double heightRatio; // 1.0 = square, 1.5 = tall

  MoodBoardItem({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.category,
    this.heightRatio = 1.0,
  });
}

class _MoodCard extends StatelessWidget {
  final MoodBoardItem item;
  final VoidCallback onTap;

  const _MoodCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: HotelAIColors.bg1,
          borderRadius: HotelAIRadii.mediumRadius,
          boxShadow: HotelAIShadows.soft,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            AspectRatio(
              aspectRatio: 1 / item.heightRatio,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(HotelAIRadii.medium),
                ),
                child: Container(
                  color: HotelAIColors.primarySoft,
                  // Placeholder for image loading
                  child: Image.asset(
                    item.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Icon(Icons.image, color: HotelAIColors.muted),
                    ),
                  ),
                ),
              ),
            ),

            // Text
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.category.toUpperCase(),
                    style: HotelAIText.caption.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: HotelAIColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.title,
                    style: HotelAIText.bodyMedium,
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
