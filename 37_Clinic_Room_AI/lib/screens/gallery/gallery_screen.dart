import 'dart:io';
import 'package:flutter/material.dart';
import '../../theme/clinic_theme.dart';
import '../../widgets/clinical_card.dart';
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
      backgroundColor: ClinicColors.bg0,
      appBar: AppBar(
        title: const Text('Saved Designs'),
        centerTitle: true,
        backgroundColor: ClinicColors.bg0,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _loadResults,
        color: ClinicColors.primary,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _resultIds.isEmpty
                ? _buildEmptyState()
                : _buildGrid(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: ClinicColors.bg1,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.grid_view, size: 48, color: ClinicColors.ink2),
          ),
          const SizedBox(height: ClinicSpacing.lg),
          Text('No Saved Designs', style: ClinicText.h3),
          const SizedBox(height: 8),
          Text(
            'Your generated clinic layouts will appear here.',
            style: ClinicText.caption,
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(ClinicSpacing.lg),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: ClinicSpacing.md,
        mainAxisSpacing: ClinicSpacing.md,
        childAspectRatio: 0.8,
      ),
      itemCount: _resultIds.length,
      itemBuilder: (context, index) {
        final id = _resultIds[index];
        return _buildGridItem(id);
      },
    );
  }

  Widget _buildGridItem(String id) {
    return FutureBuilder<ShoeAIConfig?>(
      future: _storage.loadResult(id),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const ClinicalCard(child: Center(child: CircularProgressIndicator()));
        }

        final config = snapshot.data!;
        final imagePath = config.resultData?.generatedImagePath ?? config.originalImagePath;

        if (imagePath == null) return const SizedBox.shrink();

        return ClinicalCard(
          padding: EdgeInsets.zero,
          onTap: () => _openFullscreen(imagePath, id),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                  child: Image.file(File(imagePath), fit: BoxFit.cover),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatDate(config.timestamp),
                      style: ClinicText.caption.copyWith(fontSize: 10),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Clinic Layout',
                      style: ClinicText.small.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}
