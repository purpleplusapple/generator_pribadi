// lib/screens/gallery/gallery_screen.dart
// Gallery screen with grid of saved results

import 'dart:io';
import 'package:flutter/material.dart';
import '../../theme/guest_room_ai_theme.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/fullscreen_viewer.dart';
import '../../widgets/error_toast.dart';
import '../../services/guest_result_storage.dart';
import '../../services/guest_history_repository.dart';
import '../../model/guest_ai_config.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final GuestResultStorage _storage = GuestResultStorage();
  final GuestHistoryRepository _history = GuestHistoryRepository();

  List<String> _resultIds = [];
  List<GuestAIConfig?> _results = [];
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
        backgroundColor: GuestAIColors.soleBlack,
        title: Text(
          'Clear All Results?',
          style: GuestAIText.h3,
        ),
        content: Text(
          'This will delete all saved redesigns. This action cannot be undone.',
          style: GuestAIText.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: GuestAIColors.error,
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
        color: GuestAIColors.leatherTan,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(GuestAIColors.leatherTan),
                ),
              )
            : _resultIds.isEmpty
                ? _buildEmptyState()
                : _buildGrid(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      padding: const EdgeInsets.all(GuestAISpacing.xxl),
      children: [
        const SizedBox(height: GuestAISpacing.xxl),
        Icon(
          Icons.photo_library_outlined,
          size: 80,
          color: GuestAIColors.canvasWhite.withValues(alpha: 0.3),
        ),
        const SizedBox(height: GuestAISpacing.xl),
        Text(
          'No Saved Results',
          style: GuestAIText.h2,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: GuestAISpacing.sm),
        Text(
          'Your generated redesigns will appear here.\nTap the Wizard tab to create your first one!',
          style: GuestAIText.body.copyWith(
            color: GuestAIColors.canvasWhite.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(GuestAISpacing.base),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: GuestAISpacing.md,
        mainAxisSpacing: GuestAISpacing.md,
        childAspectRatio: 0.75,
      ),
      itemCount: _resultIds.length,
      itemBuilder: (context, index) {
        final id = _resultIds[index];
        final config = index < _results.length ? _results[index] : null;
        return _buildGridItem(id, config);
      },
    );
  }

  Widget _buildGridItem(String id, GuestAIConfig? config) {
    if (config == null) {
      return GlassCard(
        child: Center(
          child: Icon(
            Icons.error_outline,
            color: GuestAIColors.error.withValues(alpha: 0.5),
          ),
        ),
      );
    }

    // Use generated image if available, otherwise use original
    final imagePath =
        config.resultData?.generatedImagePath ?? config.originalImagePath;
    if (imagePath == null) {
      return GlassCard(
        child: Center(
          child: Icon(
            Icons.error_outline,
            color: GuestAIColors.error.withValues(alpha: 0.5),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => _openFullscreen(imagePath, id),
      onLongPress: () => _deleteResult(id),
      child: GlassCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(GuestAISpacing.base),
                ),
                child: Image.file(
                  File(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(GuestAISpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatDate(config.timestamp),
                    style: GuestAIText.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (config.styleSelections.isNotEmpty)
                    Text(
                      '${config.styleSelections.length} styles',
                      style: GuestAIText.caption.copyWith(
                        color: GuestAIColors.metallicGold,
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
