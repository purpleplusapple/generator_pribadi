// lib/screens/gallery/gallery_screen.dart
// Gallery screen with grid of saved results

import 'dart:io';
import 'package:flutter/material.dart';
import '../../theme/shoe_room_ai_theme.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/fullscreen_viewer.dart';
import '../../widgets/error_toast.dart';
import '../../services/shoe_result_storage.dart';
import '../../services/laundry_history_repository.dart';
import '../../model/shoe_ai_config.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final LaundryResultStorage _storage = LaundryResultStorage();
  final LaundryHistoryRepository _history = LaundryHistoryRepository();

  List<ShoeAIConfig> _results = [];
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
      final results = await Future.wait(
        ids.map((id) => _storage.loadResult(id)),
      );
      if (mounted) {
        setState(() {
          _results = results.whereType<ShoeAIConfig>().toList();
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
        backgroundColor: ShoeAIColors.soleBlack,
        title: Text(
          'Clear All Results?',
          style: ShoeAIText.h3,
        ),
        content: Text(
          'This will delete all saved redesigns. This action cannot be undone.',
          style: ShoeAIText.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: ShoeAIColors.error,
            ),
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

  void _openFullscreen(ShoeAIConfig config) {
    final imagePath = config.resultData?.generatedImagePath ?? config.originalImagePath;
    if (imagePath == null) return;
    final id = config.timestamp.toIso8601String();

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
      appBar: AppBar(
        title: const Text('Gallery'),
        actions: [
          if (_results.isNotEmpty)
            IconButton(
              onPressed: _clearAllResults,
              icon: const Icon(Icons.delete_sweep_rounded),
              tooltip: 'Clear All',
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadResults,
        color: ShoeAIColors.leatherTan,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(ShoeAIColors.leatherTan),
                ),
              )
            : _results.isEmpty
                ? _buildEmptyState()
                : _buildGrid(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      padding: const EdgeInsets.all(ShoeAISpacing.xxl),
      children: [
        const SizedBox(height: ShoeAISpacing.xxl),
        Icon(
          Icons.photo_library_outlined,
          size: 80,
          color: ShoeAIColors.canvasWhite.withValues(alpha: 0.3),
        ),
        const SizedBox(height: ShoeAISpacing.xl),
        Text(
          'No Saved Results',
          style: ShoeAIText.h2,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: ShoeAISpacing.sm),
        Text(
          'Your generated redesigns will appear here.\nTap the Wizard tab to create your first one!',
          style: ShoeAIText.body.copyWith(
            color: ShoeAIColors.canvasWhite.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(ShoeAISpacing.base),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: ShoeAISpacing.md,
        mainAxisSpacing: ShoeAISpacing.md,
        childAspectRatio: 0.75,
      ),
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final config = _results[index];
        return _buildGridItem(config);
      },
    );
  }

  Widget _buildGridItem(ShoeAIConfig config) {
    final imagePath = config.resultData?.generatedImagePath ?? config.originalImagePath;
    final id = config.timestamp.toIso8601String();

    if (imagePath == null) {
      return GlassCard(
        child: Center(
          child: Icon(
            Icons.error_outline,
            color: ShoeAIColors.error.withValues(alpha: 0.5),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => _openFullscreen(config),
      onLongPress: () => _deleteResult(id),
      child: GlassCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(ShoeAISpacing.base),
                ),
                child: Image.file(
                  File(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(ShoeAISpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatDate(config.timestamp),
                    style: ShoeAIText.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (config.styleSelections.isNotEmpty)
                    Text(
                      '${config.styleSelections.length} styles',
                      style: ShoeAIText.caption.copyWith(
                        color: ShoeAIColors.metallicGold,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
      return '${date.month}/${date.day}/${date.year}';
    }
  }
}
