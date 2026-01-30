// lib/screens/gallery/gallery_screen.dart
import 'package:flutter/material.dart';
import '../../theme/barber_theme.dart';
import '../../services/barber_result_storage.dart';
import '../../services/barber_history_repository.dart';
import '../../model/barber_config.dart';
import '../../widgets/masonry_barber_history_grid.dart';
import '../../widgets/fullscreen_viewer.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final BarberResultStorage _storage = BarberResultStorage();
  final BarberHistoryRepository _history = BarberHistoryRepository();

  List<String> _resultIds = [];
  List<BarberConfig?> _results = [];
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

  Future<void> _deleteResult(String id) async {
    await _history.removeFromHistory(id);
    _loadResults();
  }

  void _openFullscreen(String id, String imagePath) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullscreenViewer(
          imagePath: imagePath,
          onDelete: () {
            _deleteResult(id);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BarberTheme.bg0,
      appBar: AppBar(
        title: const Text('Design Gallery'),
        backgroundColor: BarberTheme.bg0,
        titleTextStyle: BarberTheme.themeData.textTheme.titleLarge,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadResults,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: BarberTheme.primary))
          : _resultIds.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.collections_bookmark_outlined, size: 64, color: BarberTheme.muted),
                      const SizedBox(height: 16),
                      Text("No designs yet", style: BarberTheme.themeData.textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text("Start creating in the Studio tab", style: BarberTheme.themeData.textTheme.bodyMedium),
                    ],
                  ),
                )
              : MasonryBarberHistoryGrid(
                  resultIds: _resultIds,
                  results: _results,
                  onResultTap: (id, path) => _openFullscreen(id, path),
                  onDelete: _deleteResult,
                ),
    );
  }
}
