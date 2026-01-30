import 'dart:io';
import 'package:flutter/material.dart';
import '../../model/beauty_config.dart';
import '../../theme/beauty_theme.dart';
import '../../theme/beauty_tokens.dart';

class SalonRevealPage extends StatefulWidget {
  final BeautyAIConfig config;
  final File resultImage;
  final File originalImage;

  const SalonRevealPage({
    super.key,
    required this.config,
    required this.resultImage,
    required this.originalImage,
  });

  @override
  State<SalonRevealPage> createState() => _SalonRevealPageState();
}

class _SalonRevealPageState extends State<SalonRevealPage> {
  bool _showOriginal = false;
  bool _showNotes = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white54,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.close, color: BeautyTheme.ink0),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.share, color: BeautyTheme.ink0),
            ),
            onPressed: () {
              // Share logic
            },
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: BeautyTheme.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.download, color: Colors.white),
            ),
            onPressed: () {
              // Save logic
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Stack(
        children: [
          // 1. Image Viewer (Full Screen)
          Positioned.fill(
            child: GestureDetector(
              onTapDown: (_) => setState(() => _showOriginal = true),
              onTapUp: (_) => setState(() => _showOriginal = false),
              onTapCancel: () => setState(() => _showOriginal = false),
              child: Image.file(
                _showOriginal ? widget.originalImage : widget.resultImage,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 2. Compare Hint
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Press and hold to compare',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ),

          // 3. Salon Notes Panel (Bottom)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            bottom: _showNotes ? 0 : -200,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BeautyTokens.liquidGlass(
                tint: Colors.white,
                opacity: 0.9,
                radius: 30,
              ).copyWith(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Salon Notes',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      IconButton(
                        icon: const Icon(Icons.keyboard_arrow_down),
                        onPressed: () => setState(() => _showNotes = false),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow('Style', widget.config.selectedStyleId ?? 'Unknown'),
                  _buildDetailRow('Stations', '${widget.config.controlValues['station_count'] ?? '-'}'),
                  _buildDetailRow('Lighting', '${widget.config.controlValues['lighting'] ?? '-'}'),

                  if (widget.config.userNote != null && widget.config.userNote!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        '"${widget.config.userNote}"',
                        style: const TextStyle(fontStyle: FontStyle.italic, color: BeautyTheme.muted),
                      ),
                    ),

                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Start New Design'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 4. Reveal Button (if hidden)
          if (!_showNotes)
            Positioned(
              bottom: 32,
              right: 24,
              child: FloatingActionButton(
                backgroundColor: BeautyTheme.primary,
                onPressed: () => setState(() => _showNotes = true),
                child: const Icon(Icons.info_outline, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: BeautyTheme.muted)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600, color: BeautyTheme.ink1),
          ),
        ],
      ),
    );
  }
}
