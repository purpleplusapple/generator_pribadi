// lib/screens/gallery/gallery_screen.dart
// Archive (History) Screen

import 'dart:io';
import 'package:flutter/material.dart';
import '../../theme/meeting_room_theme.dart';
import '../../theme/meeting_tokens.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/fullscreen_viewer.dart';
import '../../widgets/error_toast.dart';
import '../../services/meeting_result_storage.dart';
import '../../services/meeting_history_repository.dart';
import '../../model/meeting_ai_config.dart';
import '../../data/meeting_style_repository.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final MeetingResultStorage _storage = MeetingResultStorage();
  final MeetingHistoryRepository _history = MeetingHistoryRepository();

  List<String> _resultIds = [];
  List<MeetingAIConfig?> _results = [];
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
        ErrorToast.show(context, 'Failed to load archive');
      }
    }
  }

  Future<void> _deleteResult(String id) async {
    try {
      await _history.removeFromHistory(id);
      await _loadResults();
      if (mounted) {
        ErrorToast.showSuccess(context, 'Archived item deleted');
      }
    } catch (e) {
      if (mounted) {
        ErrorToast.show(context, 'Failed to delete');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: MeetingTokens.accent))
          : _resultIds.isEmpty
              ? _buildEmptyState()
              : _buildMasonryGrid(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open_rounded, size: 64, color: MeetingTokens.line),
          const SizedBox(height: 16),
          Text('ARCHIVE EMPTY', style: MeetingRoomText.h3.copyWith(color: MeetingTokens.muted)),
        ],
      ),
    );
  }

  Widget _buildMasonryGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75, // Tall cards
      ),
      itemCount: _resultIds.length,
      itemBuilder: (context, index) {
        final id = _resultIds[index];
        final config = index < _results.length ? _results[index] : null;
        return _buildCard(id, config);
      },
    );
  }

  Widget _buildCard(String id, MeetingAIConfig? config) {
    if (config == null) return const SizedBox.shrink();

    final imagePath = config.resultData?.generatedImagePath ?? config.originalImagePath;
    if (imagePath == null) return const SizedBox.shrink();

    String styleName = 'Unknown Style';
    if (config.styleSelection != null) {
       final style = MeetingStyleRepository.getById(config.styleSelection!.styleId);
       styleName = style.name;
    }

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => FullscreenViewer(
            imagePath: imagePath,
            onDelete: () => _deleteResult(id),
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: MeetingTokens.surface,
          borderRadius: BorderRadius.circular(MeetingTokens.radiusLG),
          border: Border.all(color: MeetingTokens.line),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(MeetingTokens.radiusLG)),
                child: Image.file(File(imagePath), fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    styleName.toUpperCase(),
                    style: MeetingRoomText.caption.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                      letterSpacing: 0.5,
                      color: MeetingTokens.accent,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(config.timestamp),
                    style: MeetingRoomText.small.copyWith(color: MeetingTokens.muted),
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
    return "${date.day}/${date.month} ${date.hour}:${date.minute.toString().padLeft(2,'0')}";
  }
}
