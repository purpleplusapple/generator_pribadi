import 'dart:io';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/rooftop_result_storage.dart';
import '../../services/rooftop_history_repository.dart';
import '../../model/rooftop_config.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final RooftopResultStorage _storage = RooftopResultStorage();
  final RooftopHistoryRepository _history = RooftopHistoryRepository();
  List<String> _resultIds = [];
  List<RooftopConfig?> _results = [];
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
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.bg0,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
               padding: const EdgeInsets.all(16),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Text('History', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontFamily: 'DM Serif Display', color: DesignTokens.ink0)),
                   IconButton(icon: const Icon(Icons.filter_list, color: DesignTokens.ink1), onPressed: () {}),
                 ],
               ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _FilterChip('All', true),
                  _FilterChip('Tonight', false),
                  _FilterChip('This Week', false),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: DesignTokens.primary))
                : _resultIds.isEmpty
                  ? const Center(child: Text('No history yet', style: TextStyle(color: DesignTokens.ink1)))
                  : _buildMasonryLikeList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMasonryLikeList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (_results.isNotEmpty) ...[
           const Text('Recent', style: TextStyle(color: DesignTokens.ink1, fontWeight: FontWeight.bold)),
           const SizedBox(height: 12),
           GridView.builder(
             shrinkWrap: true,
             physics: const NeverScrollableScrollPhysics(),
             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
               crossAxisCount: 2,
               childAspectRatio: 0.7,
               crossAxisSpacing: 12,
               mainAxisSpacing: 12,
             ),
             itemCount: _results.length,
             itemBuilder: (context, index) {
               final config = _results[index];
               if (config == null) return const SizedBox();
               return _buildGridItem(config, _resultIds[index]);
             },
           ),
        ],
      ],
    );
  }

  Widget _buildGridItem(RooftopConfig config, String id) {
     final imagePath = config.resultData?.generatedImagePath ?? config.originalImagePath;
     return GestureDetector(
       onTap: () {
         if (imagePath != null) {
           showDialog(
             context: context,
             builder: (_) => Dialog(
               backgroundColor: Colors.transparent,
               insetPadding: EdgeInsets.zero,
               child: Stack(
                 children: [
                   Positioned.fill(child: InteractiveViewer(child: Image.file(File(imagePath)))),
                   Positioned(top: 40, right: 20, child: IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context))),
                 ],
               ),
             ),
           );
         }
       },
       child: Container(
         decoration: BoxDecoration(
           color: DesignTokens.surface,
           borderRadius: BorderRadius.circular(DesignTokens.radiusM),
           image: imagePath != null ? DecorationImage(image: FileImage(File(imagePath)), fit: BoxFit.cover) : null,
         ),
         child: Container(
           decoration: BoxDecoration(
             borderRadius: BorderRadius.circular(DesignTokens.radiusM),
             gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.black.withOpacity(0.8), Colors.transparent]),
           ),
           padding: const EdgeInsets.all(12),
           alignment: Alignment.bottomLeft,
           child: Text(
             config.styleSelections['Style'] ?? 'Rooftop',
             style: const TextStyle(color: DesignTokens.ink0, fontWeight: FontWeight.bold, fontSize: 12),
           ),
         ),
       ),
     );
  }

  // ignore: non_constant_identifier_names
  Widget _FilterChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Chip(
        label: Text(label, style: TextStyle(color: isSelected ? DesignTokens.bg0 : DesignTokens.ink1)),
        backgroundColor: isSelected ? DesignTokens.primary : DesignTokens.surface,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
