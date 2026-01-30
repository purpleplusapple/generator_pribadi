import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../theme/barber_theme.dart';
import '../model/barber_config.dart';
import '../model/style_repository.dart';

class MasonryBarberHistoryGrid extends StatelessWidget {
  final List<String> resultIds;
  final List<BarberConfig?> results;
  final Function(String id, String imagePath) onResultTap;
  final Function(String id) onDelete;

  const MasonryBarberHistoryGrid({
    super.key,
    required this.resultIds,
    required this.results,
    required this.onResultTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      padding: const EdgeInsets.all(16),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      itemCount: resultIds.length,
      itemBuilder: (context, index) {
        final id = resultIds[index];
        final config = index < results.length ? results[index] : null;

        if (config == null) return const SizedBox();

        final imagePath = config.resultData?.generatedImagePath ?? config.originalImagePath;
        final styleName = config.selectedStyleId != null
            ? StyleRepository.getById(config.selectedStyleId!).name
            : "Unknown Style";

        return GestureDetector(
          onTap: () {
            if (imagePath != null) onResultTap(id, imagePath);
          },
          child: Container(
            decoration: BoxDecoration(
              color: BarberTheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: BarberTheme.line),
              boxShadow: [
                 BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4)),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (imagePath != null)
                  Stack(
                    children: [
                      Image.file(
                        File(imagePath),
                        fit: BoxFit.cover,
                        height: (index % 3 == 0) ? 200 : 140, // Varied height for masonry effect
                      ),
                      Positioned(
                        right: 4,
                        top: 4,
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.white, size: 20),
                          style: IconButton.styleFrom(backgroundColor: Colors.black45),
                          onPressed: () => onDelete(id),
                        ),
                      )
                    ],
                  )
                else
                  Container(height: 140, color: BarberTheme.surface2, child: const Icon(Icons.broken_image, color: BarberTheme.muted)),

                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(styleName, style: BarberTheme.themeData.textTheme.labelLarge),
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(config.timestamp),
                        style: BarberTheme.themeData.textTheme.labelMedium?.copyWith(color: BarberTheme.muted),
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    return '${date.day}/${date.month}';
  }
}
