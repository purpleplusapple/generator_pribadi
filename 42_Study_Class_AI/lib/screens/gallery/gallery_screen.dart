import 'dart:io';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/study_result_storage.dart';
import '../../services/study_history_repository.dart';
import '../../model/study_ai_config.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final StudyResultStorage _storage = StudyResultStorage();
  final StudyHistoryRepository _history = StudyHistoryRepository();

  List<String> _resultIds = [];
  List<StudyAIConfig?> _results = [];
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
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: StudyAIColors.primary));
    }

    if (_resultIds.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.history_edu, size: 64, color: StudyAIColors.muted),
            const SizedBox(height: 16),
            Text('No designs yet', style: StudyAIText.h2),
            Text('Start your first project!', style: StudyAIText.bodySmall),
          ],
        ),
      );
    }

    // Split for Masonry
    final leftItems = <int>[];
    final rightItems = <int>[];
    for (int i = 0; i < _resultIds.length; i++) {
      if (i % 2 == 0) leftItems.add(i);
      else rightItems.add(i);
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('History'),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildColumn(leftItems)),
            const SizedBox(width: 16),
            Expanded(child: _buildColumn(rightItems)),
          ],
        ),
      ),
    );
  }

  Widget _buildColumn(List<int> indices) {
    return Column(
      children: indices.map((index) {
        final config = index < _results.length ? _results[index] : null;
        if (config == null) return const SizedBox.shrink();

        final imagePath = config.resultData?.generatedImagePath ?? config.originalImagePath;
        // Pseudo-random height for masonry effect
        final height = 150.0 + (index % 3) * 50;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: StudyAIColors.surface,
            boxShadow: StudyAIShadows.card,
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imagePath != null)
                Image.file(
                  File(imagePath),
                  height: height,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: height,
                    color: StudyAIColors.surface2,
                    child: const Center(child: Icon(Icons.broken_image)),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      config.selectedStyleId ?? 'Custom',
                      style: StudyAIText.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(config.timestamp),
                      style: StudyAIText.label,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
