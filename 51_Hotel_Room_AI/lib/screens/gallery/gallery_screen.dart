// lib/screens/gallery/gallery_screen.dart
// Gallery screen with Date Grouped Grid
// Option A: Boutique Linen

import 'dart:io';
import 'package:flutter/material.dart';
import '../../theme/hotel_room_ai_theme.dart';
import '../../widgets/fullscreen_viewer.dart';
import '../../widgets/error_toast.dart';
import '../../services/hotel_result_storage.dart';
import '../../services/hotel_history_repository.dart';
import '../../model/hotel_ai_config.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final HotelResultStorage _storage = HotelResultStorage();
  final HotelHistoryRepository _history = HotelHistoryRepository();

  // Map of Date String -> List of IDs
  Map<String, List<String>> _groupedResults = {};
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

      // We need to load configs to group by date, which is heavy.
      // For now, we might just load them linearly or try to optimization.
      // But let's load all for simplicity as per requirement.

      Map<String, List<String>> groups = {};

      for (var id in ids) {
        final config = await _storage.loadResult(id);
        if (config != null) {
          final date = config.timestamp;
          final key = _getDateKey(date);
          if (!groups.containsKey(key)) groups[key] = [];
          groups[key]!.add(id);
        }
      }

      if (mounted) {
        setState(() {
          _groupedResults = groups;
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

  String _getDateKey(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(DateTime(date.year, date.month, date.day));

    if (diff.inDays == 0 && date.day == now.day) return "Today";
    if (diff.inDays == 1 || (diff.inDays == 0 && date.day != now.day)) return "Yesterday";
    return "${date.day}/${date.month}/${date.year}";
  }

  Future<void> _deleteResult(String id) async {
    try {
      await _history.removeFromHistory(id);
      await _loadResults();
      if (mounted) ErrorToast.showSuccess(context, 'Deleted');
    } catch (e) {
      if (mounted) ErrorToast.show(context, 'Failed to delete');
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
      backgroundColor: HotelAIColors.bg0,
      appBar: AppBar(
        title: Text('Design Portfolio', style: HotelAIText.h3),
        centerTitle: false,
        backgroundColor: HotelAIColors.bg0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadResults,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: HotelAIColors.primary))
          : _groupedResults.isEmpty
              ? _buildEmptyState()
              : ListView(
                  padding: const EdgeInsets.all(HotelAISpacing.lg),
                  children: _groupedResults.entries.map((entry) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            entry.key,
                            style: HotelAIText.h3.copyWith(color: HotelAIColors.primary),
                          ),
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.8,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: entry.value.length,
                          itemBuilder: (context, index) {
                             return _buildItem(entry.value[index]);
                          },
                        ),
                      ],
                    );
                  }).toList(),
                ),
    );
  }

  Widget _buildItem(String id) {
    return FutureBuilder<HotelAIConfig?>(
      future: _storage.loadResult(id),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container(color: HotelAIColors.bg1);

        final config = snapshot.data!;
        final imagePath = config.resultData?.generatedImagePath ?? config.originalImagePath;

        if (imagePath == null) return Container(color: HotelAIColors.line);

        return GestureDetector(
          onTap: () => _openFullscreen(imagePath, id),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: HotelAIRadii.mediumRadius,
              boxShadow: HotelAIShadows.soft,
              color: HotelAIColors.bg1,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                    child: Image.file(
                      File(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    config.styleSelections['Interior Style'] ?? 'Custom',
                    style: HotelAIText.caption.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.collections_bookmark_outlined, size: 64, color: HotelAIColors.line),
          const SizedBox(height: 16),
          Text("No designs yet", style: HotelAIText.h3.copyWith(color: HotelAIColors.muted)),
        ],
      ),
    );
  }
}
