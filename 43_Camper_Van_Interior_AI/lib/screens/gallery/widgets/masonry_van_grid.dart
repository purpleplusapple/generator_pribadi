import 'dart:io';
import 'package:flutter/material.dart';
import '../../theme/camper_theme.dart';
import '../../model/camper_config.dart';
import '../../widgets/glass_card.dart';

class MasonryVanGrid extends StatelessWidget {
  final List<String> ids;
  final List<CamperConfig?> results;
  final Function(String, String) onTap;

  const MasonryVanGrid({
    super.key,
    required this.ids,
    required this.results,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final leftIds = <String>[];
    final leftConfigs = <CamperConfig?>[];
    final rightIds = <String>[];
    final rightConfigs = <CamperConfig?>[];

    for (var i = 0; i < ids.length; i++) {
      if (i % 2 == 0) {
        leftIds.add(ids[i]);
        leftConfigs.add(results[i]);
      } else {
        rightIds.add(ids[i]);
        rightConfigs.add(results[i]);
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildColumn(leftIds, leftConfigs)),
          const SizedBox(width: 16),
          Expanded(child: _buildColumn(rightIds, rightConfigs)),
        ],
      ),
    );
  }

  Widget _buildColumn(List<String> colIds, List<CamperConfig?> colConfigs) {
    return Column(
      children: List.generate(colIds.length, (index) {
        final config = colConfigs[index];
        final id = colIds[index];
        if (config == null) return const SizedBox.shrink();

        // Calculate a random height aspect ratio for "Masonry" feel
        // Or just let the content dictate size.
        // I'll make the image height variable based on index to simulate masonry if images are same aspect.
        // But usually images are user uploads.

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: GestureDetector(
            onTap: () {
               final img = config.resultData?.generatedImagePath ?? config.originalImagePath;
               if (img != null) onTap(img, id);
            },
            child: GlassCard(
              padding: EdgeInsets.zero,
              borderRadius: BorderRadius.circular(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: config.originalImagePath != null
                        ? Image.file(
                            File(config.originalImagePath!), // Use original for preview if result missing
                            fit: BoxFit.cover,
                            height: (index % 3 == 0) ? 200 : 150, // Variation
                          )
                        : Container(height: 150, color: CamperAIColors.surface2),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          config.selectedStyleId ?? "Custom Build",
                          style: CamperAIText.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(config.timestamp),
                          style: CamperAIText.caption,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.month}/${date.day}";
  }
}
