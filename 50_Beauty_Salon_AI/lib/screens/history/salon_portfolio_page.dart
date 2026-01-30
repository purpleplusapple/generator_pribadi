import 'dart:io';
import 'package:flutter/material.dart';
import '../../model/beauty_config.dart';
import '../../services/beauty_salon_history_repository.dart';
import '../../services/beauty_salon_result_storage.dart';
import '../../theme/beauty_theme.dart';
import '../../theme/beauty_tokens.dart';
import '../result/salon_reveal_page.dart';

class SalonPortfolioPage extends StatefulWidget {
  const SalonPortfolioPage({super.key});

  @override
  State<SalonPortfolioPage> createState() => _SalonPortfolioPageState();
}

class _SalonPortfolioPageState extends State<SalonPortfolioPage> {
  final BeautySalonHistoryRepository _historyRepo = BeautySalonHistoryRepository();
  final BeautySalonResultStorage _storage = BeautySalonResultStorage();

  List<BeautyAIConfig> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    final ids = await _historyRepo.getHistoryIds();
    final List<BeautyAIConfig> loaded = [];

    for (final id in ids) {
      final item = await _storage.loadResult(id);
      if (item != null) {
        loaded.add(item);
      }
    }

    if (mounted) {
      setState(() {
        _items = loaded;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BeautyTheme.bg0,
      appBar: AppBar(
        title: const Text('My Portfolio'),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: BeautyTheme.primary))
          : _items.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadHistory,
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      return _PortfolioItem(
                        item: _items[index],
                        onTap: () {
                          // Navigate to Reveal Page
                          if (_items[index].resultData?.localResultPath != null &&
                              _items[index].originalImagePath != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SalonRevealPage(
                                  config: _items[index],
                                  resultImage: File(_items[index].resultData!.localResultPath!),
                                  originalImage: File(_items[index].originalImagePath!),
                                ),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
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
              color: BeautyTheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.photo_library_outlined, size: 48, color: BeautyTheme.primary),
          ),
          const SizedBox(height: 16),
          Text(
            'No Designs Yet',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text('Create your first salon glow-up!'),
        ],
      ),
    );
  }
}

class _PortfolioItem extends StatelessWidget {
  final BeautyAIConfig item;
  final VoidCallback onTap;

  const _PortfolioItem({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final imagePath = item.resultData?.localResultPath;
    final styleName = BeautyStylePresets.getById(item.selectedStyleId ?? '')?.name ?? 'Custom';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(BeautyTokens.radiusM),
          boxShadow: BeautyTokens.shadowSoft,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(BeautyTokens.radiusM)),
                child: imagePath != null
                    ? Image.file(
                        File(imagePath),
                        fit: BoxFit.cover,
                      )
                    : Container(color: BeautyTheme.surface2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    styleName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(item.timestamp),
                    style: const TextStyle(
                      fontSize: 10,
                      color: BeautyTheme.muted,
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
