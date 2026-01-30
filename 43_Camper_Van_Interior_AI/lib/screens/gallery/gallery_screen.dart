import 'package:flutter/material.dart';
import '../../theme/camper_tokens.dart';
import '../../model/camper_ai_config.dart';
import 'widgets/masonry_van_grid.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final List<CamperAIConfig> _results = []; // TODO: Connect to Storage

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Builds'),
        backgroundColor: Colors.transparent,
      ),
      body: _results.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.photo_library_outlined, size: 64, color: CamperTokens.muted),
                  const SizedBox(height: 16),
                  const Text("No saved builds yet", style: TextStyle(color: CamperTokens.muted)),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: MasonryVanHistoryGrid(
                items: _results,
                onTap: (item) {},
              ),
            ),
    );
  }
}
