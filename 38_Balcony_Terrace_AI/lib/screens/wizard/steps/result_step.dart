import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';
import '../../../theme/terrace_theme.dart';
import '../../../widgets/glass_card.dart';
import '../../../widgets/error_toast.dart';
import '../wizard_controller.dart';

class ResultStep extends StatefulWidget {
  const ResultStep({super.key, required this.controller});

  final WizardController controller;

  @override
  State<ResultStep> createState() => _ResultStepState();
}

class _ResultStepState extends State<ResultStep> {
  bool _showBefore = false;

  void _saveToGallery() async {
    final resultData = widget.controller.resultData;
    final imagePath = resultData?.generatedImagePath ?? widget.controller.selectedImagePath;

    if (imagePath == null) return;

    try {
      final result = await ImageGallerySaver.saveFile(imagePath);
      if (mounted) ErrorToast.showSuccess(context, 'Saved to gallery!');
    } catch (e) {
      if (mounted) ErrorToast.show(context, 'Failed to save');
    }
  }

  void _finish() {
    widget.controller.resetWizard();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final resultData = widget.controller.resultData;
        final generatedPath = resultData?.generatedImagePath;
        final originalPath = widget.controller.selectedImagePath;

        final currentPath = (_showBefore || generatedPath == null) ? originalPath : generatedPath;

        if (currentPath == null) return const Center(child: CircularProgressIndicator());

        return Stack(
          children: [
            // Main Image Viewer
            Positioned.fill(
              child: Image.file(
                File(currentPath),
                fit: BoxFit.cover,
              ),
            ),

            // Top Overlay (Close/Finish)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: _finish,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: TerraceColors.metallicGold),
                      ),
                      child: Text(
                        _showBefore ? 'ORIGINAL' : 'REDESIGNED',
                        style: TerraceText.small.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.save_alt, color: Colors.white),
                      onPressed: _saveToGallery,
                    ),
                  ],
                ),
              ),
            ),

            // Compare Toggle (Centered Bottom)
            Positioned(
              bottom: 120,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTapDown: (_) => setState(() => _showBefore = true),
                  onTapUp: (_) => setState(() => _showBefore = false),
                  onTapCancel: () => setState(() => _showBefore = false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: TerraceColors.primaryEmerald,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: TerraceShadows.goldGlow(opacity: 0.4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.compare_arrows, color: TerraceColors.soleBlack),
                        SizedBox(width: 8),
                        Text(
                          'Hold to Compare',
                          style: TextStyle(
                            color: TerraceColors.soleBlack,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Details Panel (Draggable or Fixed Bottom)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _TerraceDetailsPanel(),
            ),
          ],
        );
      },
    );
  }
}

class _TerraceDetailsPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TerraceSpacing.lg),
      decoration: BoxDecoration(
        color: TerraceColors.bg0.withValues(alpha: 0.9),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(TerraceTokens.radiusLarge)),
        boxShadow: TerraceShadows.modal,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Design Details', style: TerraceText.h3),
              Icon(Icons.keyboard_arrow_up, color: TerraceColors.muted),
            ],
          ),
          const SizedBox(height: TerraceSpacing.md),
          Row(
            children: [
              _DetailChip(Icons.wb_sunny_outlined, 'Warm Light'),
              const SizedBox(width: 8),
              _DetailChip(Icons.grass, 'Ferns'),
              const SizedBox(width: 8),
              _DetailChip(Icons.chair_outlined, 'Rattan'),
            ],
          ),
          const SizedBox(height: TerraceSpacing.md),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Regenerate logic or shop items
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TerraceColors.bg1,
                foregroundColor: TerraceColors.ink0,
                side: const BorderSide(color: TerraceColors.line),
              ),
              child: const Text('Regenerate with Changes'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _DetailChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: TerraceColors.surface,
        borderRadius: BorderRadius.circular(TerraceTokens.radiusSmall),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: TerraceColors.accentAmber),
          const SizedBox(width: 6),
          Text(label, style: TerraceText.caption),
        ],
      ),
    );
  }
}
