// lib/screens/gallery/gallery_screen.dart
// Gallery screen with grid of saved results

import 'dart:io';
import 'package:flutter/material.dart';
import '../../theme/beauty_salon_ai_theme.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/fullscreen_viewer.dart';
import '../../widgets/error_toast.dart';
import '../../services/beauty_salon_result_storage.dart';
import '../../services/beauty_salon_history_repository.dart';
import '../../model/beauty_salon_ai_config.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final BeautySalonResultStorage _storage = BeautySalonResultStorage();
  final BeautySalonHistoryRepository _history = BeautySalonHistoryRepository();

  List<String> _resultIds = [];
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
      if (mounted) {
        setState(() {
          _resultIds = ids;
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
        backgroundColor: BeautyAIColors.creamWhite,
        title: Text(
          'Clear All Results?',
          style: BeautyAIText.h3,
        ),
        content: Text(
          'This will delete all saved redesigns. This action cannot be undone.',
          style: BeautyAIText.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: BeautyAIColors.error,
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
        color: BeautyAIColors.roseGold,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(BeautyAIColors.roseGold),
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
      padding: const EdgeInsets.all(BeautyAISpacing.xxl),
      children: [
        const SizedBox(height: BeautyAISpacing.xxl),
        Icon(
          Icons.photo_library_outlined,
          size: 80,
          color: BeautyAIColors.creamWhite.withValues(alpha: 0.3),
        ),
        const SizedBox(height: BeautyAISpacing.xl),
        Text(
          'No Saved Results',
          style: BeautyAIText.h2,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: BeautyAISpacing.sm),
        Text(
          'Your generated redesigns will appear here.\nTap the Wizard tab to create your first one!',
          style: BeautyAIText.body.copyWith(
            color: BeautyAIColors.creamWhite.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(BeautyAISpacing.base),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: BeautyAISpacing.md,
        mainAxisSpacing: BeautyAISpacing.md,
        childAspectRatio: 0.75,
      ),
      itemCount: _resultIds.length,
      itemBuilder: (context, index) {
        final id = _resultIds[index];
        return _buildGridItem(id);
      },
    );
  }

  Widget _buildGridItem(String id) {
    return FutureBuilder<BeautySalonAIConfig?>(
      future: _storage.loadResult(id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return GlassCard(
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  BeautyAIColors.roseGold.withValues(alpha: 0.5),
                ),
              ),
            ),
          );
        }

        final config = snapshot.data;
        if (config == null) {
          return GlassCard(
            child: Center(
              child: Icon(
                Icons.error_outline,
                color: BeautyAIColors.error.withValues(alpha: 0.5),
              ),
            ),
          );
        }

        // Use generated image if available, otherwise use original
        final imagePath = config.resultData?.generatedImagePath ?? config.originalImagePath;
        if (imagePath == null) {
          return GlassCard(
            child: Center(
              child: Icon(
                Icons.error_outline,
                color: BeautyAIColors.error.withValues(alpha: 0.5),
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
                      top: Radius.circular(BeautyAISpacing.base),
                    ),
                    child: Image.file(
                      File(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(BeautyAISpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatDate(config.timestamp),
                        style: BeautyAIText.caption,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (config.styleSelections.isNotEmpty)
                        Text(
                          '${config.styleSelections.length} styles',
                          style: BeautyAIText.caption.copyWith(
                            color: BeautyAIColors.metallicGold,
                          ),
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
