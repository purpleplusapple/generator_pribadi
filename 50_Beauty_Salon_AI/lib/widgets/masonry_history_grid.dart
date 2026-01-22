import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/beauty_salon_ai_theme.dart';

class MasonryHistoryGrid extends StatelessWidget {
  final List<String> resultIds;
  final Function(String id) onResultTap;
  final Function(String id) onResultLongPress;
  final Function(String id) getImageLoader; // Returns path Future

  const MasonryHistoryGrid({
    super.key,
    required this.resultIds,
    required this.onResultTap,
    required this.onResultLongPress,
    required this.getImageLoader,
  });

  @override
  Widget build(BuildContext context) {
    // Simple staggered grid using 2 columns
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              for (int i = 0; i < resultIds.length; i += 2)
                _buildCard(context, resultIds[i], i % 3 == 0), // Vary heights
            ],
          ),
        ),
        const SizedBox(width: BeautyAISpacing.md),
        Expanded(
          child: Column(
            children: [
              for (int i = 1; i < resultIds.length; i += 2)
                _buildCard(context, resultIds[i], i % 2 == 0),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCard(BuildContext context, String id, bool isTall) {
    return FutureBuilder<dynamic>(
      future: getImageLoader(id), // This needs to return the config object ideally
      builder: (context, snapshot) {
        String? imagePath;
        String dateStr = "";

        if (snapshot.hasData) {
          final config = snapshot.data!;
          // Assuming config structure matches what we expect
          imagePath = config.resultData?.generatedImagePath ?? config.originalImagePath;
          final date = config.timestamp as DateTime;
          dateStr = "${date.month}/${date.day}";
        }

        return GestureDetector(
          onTap: () => onResultTap(id),
          onLongPress: () => onResultLongPress(id),
          child: Container(
            margin: const EdgeInsets.only(bottom: BeautyAISpacing.md),
            decoration: BoxDecoration(
              color: BeautyAIColors.surface,
              borderRadius: BeautyAIRadii.mdRadius,
              boxShadow: BeautyAIShadows.soft,
              border: Border.all(color: BeautyAIColors.line),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                  child: imagePath != null
                      ? Image.file(
                          File(imagePath),
                          fit: BoxFit.cover,
                          height: isTall ? 220 : 160,
                          width: double.infinity,
                        )
                      : Container(
                          height: isTall ? 220 : 160,
                          color: BeautyAIColors.bg0,
                          child: Center(
                            child: Icon(Icons.image_not_supported, color: BeautyAIColors.line),
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Design #$id".substring(0, 12),
                        style: BeautyAIText.bodyMedium.copyWith(fontSize: 13),
                      ),
                      Text(
                        dateStr,
                        style: BeautyAIText.caption.copyWith(fontSize: 11),
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
