import 'dart:io';
import 'package:flutter/material.dart';
import '../../theme/guest_theme.dart';
import '../../services/guest_result_storage.dart';
import '../../services/guest_history_repository.dart';
import '../../model/guest_ai_config.dart';
import '../../widgets/fullscreen_viewer.dart';

class GuestHistoryScreen extends StatefulWidget {
  const GuestHistoryScreen({super.key});

  @override
  State<GuestHistoryScreen> createState() => _GuestHistoryScreenState();
}

class _GuestHistoryScreenState extends State<GuestHistoryScreen> {
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
      }
    }
  }

  void _openFullscreen(String imagePath, String id) {
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
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_resultIds.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.hotel_class, size: 64, color: GuestAIColors.muted.withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            Text("No Designs Yet", style: GuestAIText.h2.copyWith(color: GuestAIColors.muted)),
            Text("Start creating your dream guest room!", style: GuestAIText.body),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _resultIds.length,
      itemBuilder: (context, index) {
        final id = _resultIds[index];
        final config = _results[index];
        if (config == null) return const SizedBox();

        final imagePath = config.resultData?.generatedImagePath ?? config.originalImagePath;

        return GestureDetector(
          onTap: () {
            if (imagePath != null) _openFullscreen(imagePath, id);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(GuestAIRadii.regular),
              border: Border.all(color: GuestAIColors.line),
              color: GuestAIColors.pureWhite,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(GuestAIRadii.regular)),
                    child: imagePath != null
                        ? Image.file(File(imagePath), fit: BoxFit.cover)
                        : Container(color: GuestAIColors.muted),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        config.selectedStyleId ?? "Unknown Style",
                        style: GuestAIText.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "${config.timestamp.month}/${config.timestamp.day}",
                        style: GuestAIText.small,
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
}
