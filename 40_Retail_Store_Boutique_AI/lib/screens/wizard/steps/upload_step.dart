// lib/screens/wizard/steps/upload_step.dart
// Upload step with Retail Assist Panel

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../theme/boutique_theme.dart';
import '../../../widgets/glass_card.dart';
import '../../../widgets/error_toast.dart';
import '../wizard_controller.dart';

class UploadStep extends StatefulWidget {
  const UploadStep({
    super.key,
    required this.controller,
  });

  final WizardController controller;

  @override
  State<UploadStep> createState() => _UploadStepState();
}

class _UploadStepState extends State<UploadStep> {
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    setState(() => _isLoading = true);

    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 85,
      );

      if (image != null) {
        widget.controller.setSelectedImage(image.path);
        if (mounted) {
          ErrorToast.showSuccess(context, 'Photo ready for redesign!');
        }
      }
    } catch (e) {
      if (mounted) {
        ErrorToast.show(
          context,
          'Failed to select photo. Please check permissions.',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _clearImage() {
    widget.controller.setSelectedImage(null);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final hasImage = widget.controller.selectedImagePath != null;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Store Photo", style: BoutiqueText.h2),
              Text("Upload a clear photo of your retail space.", style: BoutiqueText.body.copyWith(color: BoutiqueColors.muted)),

              const SizedBox(height: 24),

              // Upload Area
              if (hasImage)
                _buildImagePreview()
              else
                _buildUploadBox(),

              const SizedBox(height: 32),

              // Retail Assist Panel (Two-panel concept tailored for mobile: Top/Bottom)
              const _RetailUploadAssistPanel(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUploadBox() {
    return GestureDetector(
      onTap: () => _pickImage(ImageSource.gallery),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: BoutiqueColors.surface.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: BoutiqueColors.line, style: BorderStyle.solid, width: 2),
          // Dashed border effect simulation using dotted image is complex, sticking to solid line with nice color
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: BoutiqueColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add_a_photo, size: 32, color: BoutiqueColors.primary),
            ),
            const SizedBox(height: 16),
            Text("Tap to Upload", style: BoutiqueText.h3),
            Text("or Open Camera", style: BoutiqueText.caption),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    final imagePath = widget.controller.selectedImagePath!;
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Image.file(
            File(imagePath),
            height: 240,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: () => _pickImage(ImageSource.gallery),
              icon: const Icon(Icons.refresh),
              label: const Text("Change"),
            ),
            const SizedBox(width: 16),
            TextButton.icon(
              onPressed: _clearImage,
              icon: const Icon(Icons.delete, color: BoutiqueColors.danger),
              label: Text("Remove", style: TextStyle(color: BoutiqueColors.danger)),
            ),
          ],
        )
      ],
    );
  }
}

class _RetailUploadAssistPanel extends StatelessWidget {
  const _RetailUploadAssistPanel();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Photo Guide", style: BoutiqueText.h3.copyWith(fontSize: 18)),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: BoutiqueColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: BoutiqueColors.line),
          ),
          child: Column(
            children: [
              // Panel 1: Tips
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.lightbulb_outline, color: BoutiqueColors.primary, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Best Practices", style: BoutiqueText.bodyMedium),
                          const SizedBox(height: 4),
                          Text("• Use wide angle if possible\n• Ensure aisles are visible\n• Capture entrance or focal point", style: BoutiqueText.caption),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: BoutiqueColors.line),
              // Panel 2: Checklist
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.checklist, color: BoutiqueColors.accent2, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("AI Visibility Check", style: BoutiqueText.bodyMedium),
                          const SizedBox(height: 4),
                          Text("• Shelves detected\n• Lighting sources visible\n• Signage clear", style: BoutiqueText.caption),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
