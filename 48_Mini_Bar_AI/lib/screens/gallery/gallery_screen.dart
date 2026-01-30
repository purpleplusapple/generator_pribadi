// lib/screens/gallery/gallery_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import '../../theme/mini_bar_theme.dart';
import '../../theme/design_tokens.dart';
import '../../services/mini_bar_result_storage.dart';
import '../../model/mini_bar_config.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final _storage = MiniBarResultStorage();
  List<MiniBarConfig> _results = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await _storage.getAllResults();
    if (mounted) setState(() { _results = list; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: Text('Design Portfolio', style: MiniBarText.h3)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _results.isEmpty
              ? Center(child: Text('No designs yet', style: MiniBarText.body.copyWith(color: MiniBarColors.muted)))
              : GridView.builder(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 100),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    final item = _results[index];
                    final path = item.resultData?.generatedImagePath ?? item.originalImagePath;

                    return Container(
                      decoration: BoxDecoration(
                        color: MiniBarColors.surface,
                        borderRadius: BorderRadius.circular(MiniBarRadii.k18),
                        border: Border.all(color: MiniBarColors.line),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(MiniBarRadii.k18)),
                              child: path != null
                                  ? Image.file(File(path), fit: BoxFit.cover)
                                  : Container(color: MiniBarColors.bg1),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.selectedStyleId ?? 'Custom', style: MiniBarText.h4, maxLines: 1),
                                Text(
                                  '${item.timestamp.month}/${item.timestamp.day}',
                                  style: MiniBarText.small.copyWith(color: MiniBarColors.muted)
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
