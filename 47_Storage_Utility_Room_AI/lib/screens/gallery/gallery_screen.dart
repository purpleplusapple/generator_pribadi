import 'dart:io';
import 'package:flutter/material.dart';
import '../../theme/storage_theme.dart';
import '../../services/laundry_history_repository.dart'; // Reusing logic
import '../../services/shoe_result_storage.dart'; // Reusing logic (renamed internally?)
import '../../model/shoe_ai_config.dart'; // Reusing model
// import '../../widgets/glass_card.dart'; // Replacing with standard Card
// import '../../widgets/fullscreen_viewer.dart'; // Might need to check this

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  // Using the existing repositories (renaming classes is risky without refactoring everything)
  final LaundryResultStorage _storage = LaundryResultStorage();
  final LaundryHistoryRepository _history = LaundryHistoryRepository();

  List<String> _resultIds = [];
  List<ShoeAIConfig?> _results = []; // Keeping the model
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
        // Toast logic here or snackbar
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StorageColors.bg0,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Inventory & History", style: StorageTheme.darkTheme.textTheme.headlineMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadResults,
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: StorageColors.primaryLime))
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
          Image.asset("assets/illustrations/empty_history.jpg", height: 200, width: 200),
          const SizedBox(height: 20),
          Text(
            "No Organization Projects Yet",
            style: StorageTheme.darkTheme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            "Start a new project from the Dashboard.",
            style: StorageTheme.darkTheme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildMasonryGrid() {
    // Simple Grid implementation
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _resultIds.length,
      itemBuilder: (context, index) {
        final config = index < _results.length ? _results[index] : null;
        if (config == null) return const SizedBox();

        final imagePath = config.resultData?.generatedImagePath ?? config.originalImagePath;

        return Container(
          decoration: BoxDecoration(
            color: StorageColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: StorageColors.line),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: imagePath != null
                    ? Image.file(File(imagePath), fit: BoxFit.cover)
                    : Container(color: StorageColors.surface2),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Storage Project ${index + 1}",
                      style: const TextStyle(fontWeight: FontWeight.bold, color: StorageColors.ink0),
                    ),
                    Text(
                      config.timestamp.toString().split(' ')[0],
                      style: const TextStyle(fontSize: 10, color: StorageColors.muted),
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
}
