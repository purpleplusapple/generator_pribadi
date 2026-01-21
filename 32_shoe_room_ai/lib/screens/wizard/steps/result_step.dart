// lib/screens/wizard/steps/result_step.dart
// Result step with generated image and action buttons

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';
import '../../../theme/shoe_room_ai_theme.dart';
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
  Future<void> _saveToGallery() async {
    // Use generated image if available, otherwise use original
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
    // Use generated image if available, otherwise use original
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
        text: 'Check out my AI-generated laundry room redesign!',
      );
    } catch (e) {
      if (mounted) {
        ErrorToast.show(context, 'Failed to share image');
      }
    }
  }

  void _tryAgain() {
    widget.controller.resetWizard();
  }

  void _editSelections() {
    widget.controller.goToStep(1); // Jump to style step
  }

  void _compareImages() {
    final resultData = widget.controller.resultData;
    final originalPath = widget.controller.selectedImagePath;
    final generatedPath = resultData?.generatedImagePath;

    if (originalPath == null || generatedPath == null) {
      ErrorToast.show(context, 'Both images needed for comparison');
      return;
    }

    // Show fullscreen comparison
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _ComparisonScreen(
          beforeImagePath: originalPath,
          afterImagePath: generatedPath,
        ),
      ),
    );
  }

  void _moreVariations() {
    ErrorToast.showInfo(context, 'More variations coming soon!');
  }

  void _finish() {
    // Reset wizard and navigate back (will return to home tab)
    widget.controller.resetWizard();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        // Use generated image if available, otherwise fall back to original
        final resultData = widget.controller.resultData;
        final imagePath = resultData?.generatedImagePath ?? 
                         widget.controller.selectedImagePath;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(ShoeAISpacing.base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: ShoeAISpacing.lg),
              
              // Success Header
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.celebration_rounded,
                    color: ShoeAIColors.laceGray,
                    size: 32,
                  ),
                  const SizedBox(width: ShoeAISpacing.sm),
                  Text(
                    'Your Redesign is Ready!',
                    style: ShoeAIText.h2,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              
              const SizedBox(height: ShoeAISpacing.sm),
              
              Text(
                resultData?.generatedImagePath != null
                    ? 'Here\'s your AI-powered laundry room transformation'
                    : 'Here\'s your selected laundry room photo',
                style: ShoeAIText.body.copyWith(
                  color: ShoeAIColors.canvasWhite.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: ShoeAISpacing.xxl),
              
              // Generated Image Display
              if (imagePath != null)
                GlassCard(
                  padding: EdgeInsets.zero,
                  child: ClipRRect(
                    borderRadius: ShoeAIRadii.cardRadius,
                    child: Image.file(
                      File(imagePath),
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                )
              else
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                    color: ShoeAIColors.canvasWhite.withValues(alpha: 0.05),
                    borderRadius: ShoeAIRadii.cardRadius,
                  ),
                  child: Center(
                    child: Text(
                      'No image available',
                      style: ShoeAIText.body,
                    ),
                  ),
                ),
              
              const SizedBox(height: ShoeAISpacing.xxl),
              
              // Action Buttons Grid (3x2)
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.save_alt_rounded,
                      label: 'Save',
                      onTap: _saveToGallery,
                    ),
                  ),
                  const SizedBox(width: ShoeAISpacing.md),
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.share_rounded,
                      label: 'Share',
                      onTap: _shareImage,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: ShoeAISpacing.md),
              
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.refresh_rounded,
                      label: 'Try Again',
                      onTap: _tryAgain,
                    ),
                  ),
                  const SizedBox(width: ShoeAISpacing.md),
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.compare_arrows_rounded,
                      label: 'Compare',
                      onTap: _compareImages,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: ShoeAISpacing.md),
              
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.edit_rounded,
                      label: 'Edit',
                      onTap: _editSelections,
                    ),
                  ),
                  const SizedBox(width: ShoeAISpacing.md),
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.auto_awesome_rounded,
                      label: 'More',
                      onTap: _moreVariations,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: ShoeAISpacing.xxl),
              
              // Finish Button
              GradientButton(
                label: 'Finish',
                icon: Icons.check_circle_rounded,
                onPressed: _finish,
                size: ButtonSize.large,
              ),
              
              const SizedBox(height: ShoeAISpacing.xxl),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GlassCard(
      child: InkWell(
        onTap: onTap,
        borderRadius: ShoeAIRadii.cardRadius,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: ShoeAISpacing.lg,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: ShoeAIColors.leatherTan,
                size: 32,
              ),
              const SizedBox(height: ShoeAISpacing.sm),
              Text(
                label,
                style: ShoeAIText.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Fullscreen comparison screen
class _ComparisonScreen extends StatelessWidget {
  const _ComparisonScreen({
    required this.beforeImagePath,
    required this.afterImagePath,
  });

  final String beforeImagePath;
  final String afterImagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ShoeAIColors.soleBlack,
      appBar: AppBar(
        title: const Text('Compare'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: ImageComparisonSlider(
          beforeImagePath: beforeImagePath,
          afterImagePath: afterImagePath,
        ),
      ),
    );
  }
}
