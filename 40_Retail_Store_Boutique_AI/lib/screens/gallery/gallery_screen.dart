// lib/screens/gallery/gallery_screen.dart
// History/Portfolio Screen with Boutique Grid

import 'dart:io';
import 'package:flutter/material.dart';
import '../../theme/boutique_theme.dart';
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

  List<String> _resultIds = [];
  List<ShoeAIConfig?> _results = [];
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
      if (mounted) setState(() { _resultIds = ids; _results = results; _isLoading = false; });
    } catch (e) {
      if (mounted) { setState(() => _isLoading = false); ErrorToast.show(context, 'Failed to load portfolio'); }
    }
  }

  Future<void> _deleteResult(String id) async {
    try {
      await _history.removeFromHistory(id);
      await _loadResults();
    } catch (e) {
      // ignore
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BoutiqueColors.bg0,
      appBar: AppBar(
        title: Text("Design Portfolio", style: BoutiqueText.h3),
        centerTitle: false,
        backgroundColor: BoutiqueColors.bg0,
        actions: [
          IconButton(
            icon: const Icon(Icons.sort, color: BoutiqueColors.ink1),
            onPressed: () {},
          )
        ],
      ),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator(color: BoutiqueColors.primary))
        : _resultIds.isEmpty ? _buildEmpty() : _MasonryBoutiqueHistoryGrid(
            resultIds: _resultIds,
            results: _results,
            onTap: (path, id) => Navigator.push(context, MaterialPageRoute(builder: (_) => FullscreenViewer(imagePath: path, onDelete: () => _deleteResult(id)))),
            onDelete: _deleteResult,
          ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.collections_bookmark_outlined, size: 64, color: BoutiqueColors.muted.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text("No Designs Yet", style: BoutiqueText.h3.copyWith(color: BoutiqueColors.muted)),
          const SizedBox(height: 8),
          Text("Start a new makeover to build your portfolio", style: BoutiqueText.caption),
        ],
      ),
    );
  }
}

class _MasonryBoutiqueHistoryGrid extends StatelessWidget {
  final List<String> resultIds;
  final List<ShoeAIConfig?> results;
  final Function(String, String) onTap;
  final Function(String) onDelete;

  const _MasonryBoutiqueHistoryGrid({required this.resultIds, required this.results, required this.onTap, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: resultIds.length,
      itemBuilder: (context, index) {
        final id = resultIds[index];
        final config = index < results.length ? results[index] : null;
        if (config == null) return const SizedBox.shrink();

        final path = config.resultData?.generatedImagePath ?? config.originalImagePath;
        if (path == null) return const SizedBox.shrink();

        return GestureDetector(
          onTap: () => onTap(path, id),
          onLongPress: () => onDelete(id),
          child: Container(
            decoration: BoxDecoration(
              color: BoutiqueColors.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: BoutiqueShadows.card,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.file(File(path), fit: BoxFit.cover),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Boutique #${index + 1}",
                        style: BoutiqueText.bodyMedium.copyWith(color: BoutiqueColors.ink0),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(config.timestamp),
                        style: BoutiqueText.caption.copyWith(fontSize: 10),
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

  String _formatDate(DateTime d) {
    return "${d.day}/${d.month}/${d.year}";
  }
}
