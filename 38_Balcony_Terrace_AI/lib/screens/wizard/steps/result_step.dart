// lib/screens/wizard/steps/result_step.dart
// Result step with Details Panel and Comparison

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';
import '../../../theme/terrace_theme.dart';
import '../../../widgets/glass_card.dart';
import '../../../widgets/gradient_button.dart';
import '../../../widgets/error_toast.dart';
import '../../../widgets/image_comparison_slider.dart';
import '../wizard_controller.dart';

class ResultStep extends StatefulWidget {
  const ResultStep({
    super.key,
    required this.controller,
  });

  final WizardController controller;

  @override
  State<ResultStep> createState() => _ResultStepState();
}

class _ResultStepState extends State<ResultStep> {
  bool _showComparison = false;

  Future<void> _saveToGallery() async {
    final resultData = widget.controller.resultData;
    final imagePath = resultData?.generatedImagePath ??
                     widget.controller.selectedImagePath;

    if (imagePath == null) {
      ErrorToast.show(context, 'No image to save');
      return;
    }

    try {
      final result = await ImageGallerySaver.saveFile(imagePath);
      if (mounted) {
        if (result['isSuccess'] == true) {
          ErrorToast.showSuccess(context, 'Saved to gallery!');
        } else {
          ErrorToast.show(context, 'Failed to save image');
        }
      }
    } catch (e) {
      if (mounted) {
        ErrorToast.show(context, 'Failed to save image');
      }
    }
  }

  Future<void> _shareImage() async {
    final resultData = widget.controller.resultData;
    final imagePath = resultData?.generatedImagePath ??
                     widget.controller.selectedImagePath;

    if (imagePath == null) {
      ErrorToast.show(context, 'No image to share');
      return;
    }

    try {
      await Share.shareXFiles(
        [XFile(imagePath)],
        text: 'Check out my balcony makeover with Balcony Terrace AI!',
      );
    } catch (e) {
      if (mounted) {
        ErrorToast.show(context, 'Failed to share image');
      }
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

        if (generatedPath == null) {
           return const Center(child: Text('No result generated yet.'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(TerraceAISpacing.base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Area
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: TerraceAIRadii.lgRadius,
                    child: SizedBox(
                      height: 400,
                      width: double.infinity,
                      child: _showComparison && originalPath != null
                          ? ImageComparisonSlider(
                              beforeImagePath: originalPath,
                              afterImagePath: generatedPath,
                            )
                          : Image.file(File(generatedPath), fit: BoxFit.cover),
                    ),
                  ),

                  // Toggle Button
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: FloatingActionButton.small(
                      backgroundColor: TerraceAIColors.surface.withValues(alpha: 0.8),
                      foregroundColor: TerraceAIColors.ink0,
                      onPressed: () => setState(() => _showComparison = !_showComparison),
                      child: Icon(_showComparison ? Icons.image_rounded : Icons.compare_arrows_rounded),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: TerraceAISpacing.lg),

              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton.filled(
                    onPressed: _saveToGallery,
                    icon: const Icon(Icons.download_rounded),
                    style: IconButton.styleFrom(backgroundColor: TerraceAIColors.surface2),
                  ),
                  IconButton.filled(
                    onPressed: _shareImage,
                    icon: const Icon(Icons.share_rounded),
                    style: IconButton.styleFrom(backgroundColor: TerraceAIColors.surface2),
                  ),
                  GradientButton(
                    label: 'Done',
                    onPressed: _finish,
                    icon: Icons.check_rounded,
                  ),
                ],
              ),

              const SizedBox(height: TerraceAISpacing.xl),

              // Details Panel
              _buildDetailsPanel(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailsPanel() {
    // Mock data based on selections would go here
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Design Details', style: TerraceAIText.h3),
          const SizedBox(height: TerraceAISpacing.md),
          _buildDetailRow('Style', 'Custom Night Garden'),
          _buildDetailRow('Lighting', 'Warm Lanterns'),
          _buildDetailRow('Plants', 'Lush Tropical Mix'),
          const SizedBox(height: TerraceAISpacing.md),
          Text(
            'Tip: Use weather-resistant materials for the cushions shown in the render.',
            style: TerraceAIText.caption.copyWith(fontStyle: FontStyle.italic),
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
          Text(label, style: TerraceAIText.body.copyWith(color: TerraceAIColors.muted)),
          Text(value, style: TerraceAIText.bodyMedium),
        ],
      ),
    );
  }
}
