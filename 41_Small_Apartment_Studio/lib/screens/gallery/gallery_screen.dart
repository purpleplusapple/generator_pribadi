import 'dart:io';
import 'package:flutter/material.dart';
import '../../theme/apartment_tokens.dart';
import '../../services/apartment_history_repository.dart';
import '../../services/apartment_result_storage.dart';
import '../../model/apartment_config.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  late Future<List<ApartmentConfig>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _refreshHistory();
  }

  void _refreshHistory() {
    setState(() {
      _historyFuture = _loadHistory();
    });
  }

  Future<List<ApartmentConfig>> _loadHistory() async {
    // Note: Creating instances here. In a real app, use a DI container or singletons.
    // The previous code showed ApartmentHistoryRepository.instance calls if available,
    // but the file I read didn't have a static instance field (it had _migrationAttempted).
    // I will instantiate it.
    final repo = ApartmentHistoryRepository();
    final ids = await repo.getHistoryIds();
    final List<ApartmentConfig> results = [];
    final storage = ApartmentResultStorage();

    for (final id in ids) {
      final config = await storage.loadResult(id);
      if (config != null) {
        results.add(config);
      }
    }
    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ApartmentTokens.bg0,
      body: FutureBuilder<List<ApartmentConfig>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
             return const Center(child: CircularProgressIndicator(color: ApartmentTokens.primary));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState();
          }

          final items = snapshot.data!;

          return RefreshIndicator(
            onRefresh: () async {
              _refreshHistory();
              await _historyFuture;
            },
            color: ApartmentTokens.primary,
            child: GridView.builder(
              padding: const EdgeInsets.all(ApartmentTokens.s16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75, // Tall cards
                crossAxisSpacing: ApartmentTokens.s12,
                mainAxisSpacing: ApartmentTokens.s12,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return _buildHistoryCard(context, item);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.grid_view, size: 64, color: ApartmentTokens.line),
          const SizedBox(height: 16),
          const Text(
            'No Studios Yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ApartmentTokens.ink0,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Start a new project to see it here.',
            style: TextStyle(color: ApartmentTokens.ink1),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, ApartmentConfig item) {
    // Try to find a display image: Result first, then Original
    String? displayPath;
    if (item.resultData?.localPath != null) {
      displayPath = item.resultData!.localPath;
    } else {
      displayPath = item.originalImagePath;
    }

    return GestureDetector(
      onTap: () {
        // Navigate to result details (TODO)
      },
      child: Container(
        decoration: BoxDecoration(
          color: ApartmentTokens.surface,
          borderRadius: BorderRadius.circular(ApartmentTokens.r16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: displayPath != null && File(displayPath).existsSync()
                  ? Image.file(
                      File(displayPath),
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                  : Container(
                      color: ApartmentTokens.bg0,
                      child: const Center(
                        child: Icon(Icons.image_not_supported, color: ApartmentTokens.line),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Studio Makeover',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: ApartmentTokens.ink0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(item.timestamp),
                    style: const TextStyle(
                      fontSize: 12,
                      color: ApartmentTokens.muted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
