// lib/screens/wizard/steps/result_step.dart
// Result step with Swipe Compare
// Option A: Boutique Linen

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';
import '../../../theme/hotel_room_ai_theme.dart';
import '../../../widgets/error_toast.dart';
import '../../../widgets/swipe_compare.dart';
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
    final resultData = widget.controller.resultData;
    final imagePath = resultData?.generatedImagePath ??
                     widget.controller.selectedImagePath;

    if (imagePath == null) return;

    try {
      final result = await ImageGallerySaver.saveFile(imagePath);
      if (mounted) {
        if (result['isSuccess'] == true) {
          ErrorToast.showSuccess(context, 'Saved to gallery!');
        } else {
          ErrorToast.show(context, 'Failed to save');
        }
      }
    } catch (e) {
      if (mounted) ErrorToast.show(context, 'Failed to save');
    }
  }

  Future<void> _shareImage() async {
    final resultData = widget.controller.resultData;
    final imagePath = resultData?.generatedImagePath ??
                     widget.controller.selectedImagePath;

    if (imagePath == null) return;

    try {
      await Share.shareXFiles(
        [XFile(imagePath)],
        text: 'Check out my hotel room design!',
      );
    } catch (e) {
      if (mounted) ErrorToast.show(context, 'Failed to share');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final resultData = widget.controller.resultData;
        final originalPath = widget.controller.selectedImagePath;
        final generatedPath = resultData?.generatedImagePath;

        final hasBoth = originalPath != null && generatedPath != null;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(HotelAISpacing.lg),
          child: Column(
            children: [
              Text("Your Design Suite", style: HotelAIText.h2),
              const SizedBox(height: 8),
              Text(
                "Swipe to compare the transformation.",
                style: HotelAIText.body.copyWith(color: HotelAIColors.muted),
              ),
              const SizedBox(height: 24),

              if (hasBoth)
                Container(
                  height: 350,
                  decoration: BoxDecoration(
                    borderRadius: HotelAIRadii.mediumRadius,
                    boxShadow: HotelAIShadows.cardElevated,
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SwipeBeforeAfterCompare(
                      beforeImage: FileImage(File(originalPath)),
                      afterImage: FileImage(File(generatedPath)),
                    ),
                  ),
                )
              else if (originalPath != null)
                 ClipRRect(
                    borderRadius: HotelAIRadii.mediumRadius,
                    child: Image.file(File(originalPath)),
                 ),

              const SizedBox(height: 32),

              // Action Grid
              Row(
                children: [
                  Expanded(
                    child: _ResultAction(
                      icon: Icons.download_rounded,
                      label: "Save",
                      onTap: _saveToGallery,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _ResultAction(
                      icon: Icons.share_outlined,
                      label: "Share",
                      onTap: _shareImage,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _ResultAction(
                      icon: Icons.refresh,
                      label: "New",
                      onTap: () => widget.controller.resetWizard(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _ResultAction(
                      icon: Icons.edit_outlined,
                      label: "Edit",
                      onTap: () => widget.controller.goToStep(1),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ResultAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ResultAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: HotelAIRadii.mediumRadius,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: HotelAIColors.bg1,
          borderRadius: HotelAIRadii.mediumRadius,
          border: Border.all(color: HotelAIColors.line),
        ),
        child: Column(
          children: [
            Icon(icon, color: HotelAIColors.ink0),
            const SizedBox(height: 4),
            Text(label, style: HotelAIText.button),
          ],
        ),
      ),
    );
  }
}
