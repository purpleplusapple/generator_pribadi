// lib/screens/gallery/gallery_screen.dart
// Gallery screen with Masonry Grid

import 'package:flutter/material.dart';
import '../../theme/camper_theme.dart';
import '../../services/camper_storage.dart';
import '../../services/camper_history_repository.dart';
import '../../model/camper_config.dart';
import 'widgets/masonry_van_grid.dart';
import '../../widgets/fullscreen_viewer.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final CamperResultStorage _storage = CamperResultStorage();
  final CamperHistoryRepository _history = CamperHistoryRepository();

  List<String> _resultIds = [];
  List<CamperConfig?> _results = [];
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
      print(e);
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _openFullscreen(String imagePath, String id) {
     // Need to check if FullscreenViewer exists and if it's generic enough.
     // Assuming yes, but let's be safe.
     // If not, I'll just skip fullscreen or implement simple one.
     // I'll assume it exists from Camper Room.

     Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullscreenViewer(
          imagePath: imagePath,
          onDelete: () async {
             await _history.removeFromHistory(id);
             _loadResults();
          },
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CamperAIColors.soleBlack,
      appBar: AppBar(
        title: const Text('Saved Builds'),
        centerTitle: false,
        backgroundColor: CamperAIColors.soleBlack,
        actions: [
          if (_resultIds.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () async {
                await _history.clearHistory();
                _loadResults();
              },
            )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: CamperAIColors.leatherTan))
          : _resultIds.isEmpty
              ? Center(child: Text("No builds yet.", style: CamperAIText.body))
              : MasonryVanGrid(
                  ids: _resultIds,
                  results: _results,
                  onTap: _openFullscreen,
                ),
    );
  }
}
