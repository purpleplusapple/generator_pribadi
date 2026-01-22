import 'package:flutter/material.dart';
import '../../theme/beauty_salon_ai_theme.dart';
import '../../widgets/masonry_history_grid.dart'; // New Component
import '../../services/beauty_salon_result_storage.dart';
import '../../services/beauty_salon_history_repository.dart';
import '../../widgets/fullscreen_viewer.dart';
import '../../widgets/error_toast.dart';

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
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BeautyAIColors.bg0,
      appBar: AppBar(
        title: const Text('Design History'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _resultIds.isEmpty
              ? _buildEmptyState()
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: MasonryHistoryGrid(
                    resultIds: _resultIds,
                    onResultTap: _onResultTap,
                    onResultLongPress: (id) {}, // Optional delete
                    getImageLoader: (id) => _storage.loadResult(id),
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.photo_library_outlined, size: 64, color: BeautyAIColors.line),
          const SizedBox(height: 16),
          Text('No designs yet', style: BeautyAIText.body.copyWith(color: BeautyAIColors.muted)),
        ],
      ),
    );
  }

  void _onResultTap(String id) async {
    final config = await _storage.loadResult(id);
    if (config != null) {
      final path = config.resultData?.generatedImagePath ?? config.originalImagePath;
      if (path != null && mounted) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => FullscreenViewer(imagePath: path)));
      }
    }
  }
}
