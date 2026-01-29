// lib/screens/gallery/gallery_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../theme/terrace_theme.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/fullscreen_viewer.dart';
import '../../widgets/error_toast.dart';
import '../../services/terrace_result_storage.dart';
import '../../services/terrace_history_repository.dart';
import '../../model/terrace_ai_config.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final TerraceResultStorage _storage = TerraceResultStorage();
  final TerraceHistoryRepository _history = TerraceHistoryRepository();

  List<String> _resultIds = [];
  List<TerraceAIConfig?> _results = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadResults();
  }

  Future<void> _loadResults() async {
    setState(() => _isLoading = true);
    try {
      final ids = await _history.getHistoryIds();
      final results = await _storage.loadResults(ids);

      if (mounted) {
        setState(() {
          _resultIds = ids;
          _results = results;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TerraceColors.bg0,
      appBar: AppBar(
        title: const Text('Design History'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: TerraceColors.metallicGold))
          : _resultIds.isEmpty
              ? _buildEmptyState()
              : MasonryGridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  padding: const EdgeInsets.all(12),
                  itemCount: _resultIds.length,
                  itemBuilder: (context, index) {
                    final config = index < _results.length ? _results[index] : null;
                    return _buildGridItem(config);
                  },
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.photo_library_outlined, size: 64, color: TerraceColors.muted),
          const SizedBox(height: 16),
          Text('No designs yet', style: TerraceText.h3),
        ],
      ),
    );
  }

  Widget _buildGridItem(TerraceAIConfig? config) {
    if (config == null) return const SizedBox.shrink();

    final imagePath = config.resultData?.generatedImagePath ?? config.originalImagePath;
    if (imagePath == null) return const SizedBox.shrink();

    // Random height for masonry effect (simulated by aspect ratio)
    // Actually MasonryGridView handles variable height children.
    // We'll just let the image determine height or fix it.

    return GestureDetector(
      onTap: () {
        // Navigate to details
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(TerraceTokens.radiusMedium),
          color: TerraceColors.surface,
          boxShadow: TerraceShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(TerraceTokens.radiusMedium)),
              child: Image.file(
                File(imagePath),
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Terrace Design',
                    style: TerraceText.bodyMedium,
                  ),
                  Text(
                    '${config.timestamp.day}/${config.timestamp.month}',
                    style: TerraceText.caption,
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
