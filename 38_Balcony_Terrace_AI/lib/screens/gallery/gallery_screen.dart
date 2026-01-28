// lib/screens/gallery/gallery_screen.dart
// Gallery screen with Masonry Grid

import 'dart:io';
import 'package:flutter/material.dart';
import '../../theme/terrace_theme.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/fullscreen_viewer.dart';
import '../../widgets/error_toast.dart';
import '../../services/terrace_result_storage.dart'; // File not renamed yet
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
      // Reverse to show newest first
      final reversedIds = ids.reversed.toList();
      final results = await _storage.loadResults(reversedIds);

      if (mounted) {
        setState(() {
          _resultIds = reversedIds;
          _results = results;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ErrorToast.show(context, 'Failed to load gallery');
      }
    }
  }

  Future<void> _deleteResult(String id) async {
    try {
      await _history.removeFromHistory(id);
      await _loadResults();
      if (mounted) {
        ErrorToast.showSuccess(context, 'Result deleted');
      }
    } catch (e) {
      if (mounted) {
        ErrorToast.show(context, 'Failed to delete result');
      }
    }
  }

  Future<void> _clearAllResults() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: TerraceAIColors.surface,
        title: Text('Clear All Results?', style: TerraceAIText.h3),
        content: Text(
          'This will delete all saved redesigns. This action cannot be undone.',
          style: TerraceAIText.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: TerraceAIColors.danger),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _history.clearHistory();
        await _loadResults();
        if (mounted) {
          ErrorToast.showSuccess(context, 'All results cleared');
        }
      } catch (e) {
        if (mounted) {
          ErrorToast.show(context, 'Failed to clear results');
        }
      }
    }
  }

  void _openFullscreen(String imagePath, String id) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullscreenViewer(
          imagePath: imagePath,
          onDelete: () => _deleteResult(id),
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Bokeh background visible
      appBar: AppBar(
        title: const Text('Gallery'),
        actions: [
          if (_resultIds.isNotEmpty)
            IconButton(
              onPressed: _clearAllResults,
              icon: const Icon(Icons.delete_sweep_rounded),
              tooltip: 'Clear All',
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadResults,
        color: TerraceAIColors.primary,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(TerraceAIColors.primary),
                ),
              )
            : _resultIds.isEmpty
                ? _buildEmptyState()
                : _buildMasonryGrid(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      padding: const EdgeInsets.all(TerraceAISpacing.xxl),
      children: [
        const SizedBox(height: TerraceAISpacing.xxl),
        Icon(
          Icons.photo_library_outlined,
          size: 80,
          color: TerraceAIColors.muted.withValues(alpha: 0.3),
        ),
        const SizedBox(height: TerraceAISpacing.xl),
        Text(
          'No Saved Results',
          style: TerraceAIText.h2,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: TerraceAISpacing.sm),
        Text(
          'Your generated redesigns will appear here.',
          style: TerraceAIText.body.copyWith(color: TerraceAIColors.muted),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildMasonryGrid() {
    // Split into two columns
    List<Widget> leftCol = [];
    List<Widget> rightCol = [];

    for (int i = 0; i < _resultIds.length; i++) {
      final item = _buildGridItem(_resultIds[i], i < _results.length ? _results[i] : null);
      if (i % 2 == 0) {
        leftCol.add(item);
        leftCol.add(const SizedBox(height: TerraceAISpacing.md));
      } else {
        rightCol.add(item);
        rightCol.add(const SizedBox(height: TerraceAISpacing.md));
      }
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        TerraceAISpacing.base,
        TerraceAISpacing.base,
        TerraceAISpacing.base,
        120, // Bottom padding for dock
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Column(children: leftCol)),
          const SizedBox(width: TerraceAISpacing.md),
          Expanded(child: Column(children: rightCol)),
        ],
      ),
    );
  }

  Widget _buildGridItem(String id, TerraceAIConfig? config) {
    if (config == null) return const SizedBox.shrink();

    // Use generated image if available, otherwise use original
    final imagePath =
        config.resultData?.generatedImagePath ?? config.originalImagePath;

    if (imagePath == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => _openFullscreen(imagePath, id),
      onLongPress: () => _deleteResult(id),
      child: GlassCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(TerraceAIRadii.md),
              ),
              child: Image.file(
                File(imagePath),
                fit: BoxFit.cover,
                // Make even/odd items potentially different aspect ratios for true masonry look?
                // For now, let's keep it simple or random height?
                // fit: BoxFit.cover usually needs a height.
                // We'll use a constrained height or let the image define it if we didn't use fit.
                // But local files might be huge.
                // Let's use a fixed height for now but vary it slightly by index?
                // Actually, just letting it flow might break layout if image is huge.
                // Better to set a height.
                height: 180, // Fixed for simplicity in this pass
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(TerraceAISpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatDate(config.timestamp),
                    style: TerraceAIText.caption.copyWith(fontSize: 10),
                  ),
                  const SizedBox(height: 2),
                  // Extract mood if present
                  if (config.styleSelections.containsKey('category_id'))
                    Text(
                      _formatCategory(config.styleSelections['category_id']!),
                      style: TerraceAIText.small.copyWith(
                        color: TerraceAIColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
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

  String _formatCategory(String id) {
    // Basic formatting: cozy_lantern -> Cozy Lantern
    return id.split('_').map((word) =>
      word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : ''
    ).join(' ');
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        return '${diff.inMinutes}m ago';
      }
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${date.month}/${date.day}';
    }
  }
}
