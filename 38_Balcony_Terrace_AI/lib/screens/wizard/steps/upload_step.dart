// lib/screens/wizard/steps/upload_step.dart
// Upload step with Night Photo Assist

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../theme/terrace_theme.dart';
import '../../../widgets/glass_card.dart';
import '../../../widgets/error_toast.dart';
import '../wizard_controller.dart';
import '../widgets/night_upload_assist.dart';

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
          ErrorToast.showSuccess(context, 'Photo selected successfully!');
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
    if (mounted) {
      ErrorToast.showInfo(context, 'Photo cleared');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final hasImage = widget.controller.selectedImagePath != null;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(TerraceAISpacing.base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: TerraceAISpacing.lg),

              Text(
                'Upload Your Terrace',
                style: TerraceAIText.h2,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: TerraceAISpacing.sm),

              Text(
                hasImage
                    ? 'Perfect! Ready to transform.'
                    : 'Capture your balcony or patio for a night makeover',
                style: TerraceAIText.body.copyWith(
                  color: TerraceAIColors.muted,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: TerraceAISpacing.xxl),

              // Layout: Image/Buttons + Assist Panel
              LayoutBuilder(
                builder: (context, constraints) {
                  // If wide enough, use Row
                  if (constraints.maxWidth > 800) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: hasImage ? _buildImagePreview() : _buildUploadButtons()),
                        const SizedBox(width: TerraceAISpacing.xl),
                        const SizedBox(width: 300, child: NightUploadAssist()),
                      ],
                    );
                  }

                  // Mobile: Column
                  return Column(
                    children: [
                      hasImage ? _buildImagePreview() : _buildUploadButtons(),
                      const SizedBox(height: TerraceAISpacing.xl),
                      const NightUploadAssist(),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUploadButtons() {
    return Column(
      children: [
        _buildUploadCard(
          icon: Icons.camera_alt_rounded,
          title: 'Take Night Photo',
          subtitle: 'Open camera',
          gradient: TerraceAIGradients.primaryCta,
          onTap: _isLoading ? null : () => _pickImage(ImageSource.camera),
          badge: 'BEST RESULTS',
        ),

        const SizedBox(height: TerraceAISpacing.lg),

        Row(
          children: [
            const Expanded(child: Divider(color: TerraceAIColors.line)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: TerraceAISpacing.md),
              child: Text('OR', style: TerraceAIText.small),
            ),
            const Expanded(child: Divider(color: TerraceAIColors.line)),
          ],
        ),

        const SizedBox(height: TerraceAISpacing.lg),

        _buildUploadCard(
          icon: Icons.photo_library_rounded,
          title: 'Gallery',
          subtitle: 'Select existing photo',
          gradient: LinearGradient(
            colors: [
              TerraceAIColors.surface2,
              TerraceAIColors.surface,
            ],
          ),
          onTap: _isLoading ? null : () => _pickImage(ImageSource.gallery),
        ),

        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(color: TerraceAIColors.primary),
          ),
      ],
    );
  }

  Widget _buildUploadCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Gradient gradient,
    required VoidCallback? onTap,
    String? badge,
  }) {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: TerraceAIRadii.mdRadius,
        child: Container(
          padding: const EdgeInsets.all(TerraceAISpacing.xl),
          decoration: BoxDecoration(
            borderRadius: TerraceAIRadii.mdRadius,
            border: Border.all(color: TerraceAIColors.line),
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: TerraceAIRadii.smRadius,
                ),
                child: Icon(icon, size: 28, color: TerraceAIColors.ink0),
              ),
              const SizedBox(width: TerraceAISpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(title, style: TerraceAIText.h3.copyWith(fontSize: 18)),
                        if (badge != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: TerraceAIColors.accent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              badge,
                              style: TerraceAIText.small.copyWith(
                                fontSize: 9,
                                color: TerraceAIColors.bg0,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(subtitle, style: TerraceAIText.caption),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    final imagePath = widget.controller.selectedImagePath!;

    return Column(
      children: [
        GlassCard(
          padding: EdgeInsets.zero,
          child: ClipRRect(
            borderRadius: TerraceAIRadii.mdRadius,
            child: Stack(
              children: [
                Image.file(
                  File(imagePath),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 300,
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    icon: const Icon(Icons.delete_rounded, color: TerraceAIColors.danger),
                    onPressed: _clearImage,
                    style: IconButton.styleFrom(
                      backgroundColor: TerraceAIColors.bg0.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: TerraceAISpacing.md),
        TextButton.icon(
          onPressed: () => _pickImage(ImageSource.gallery),
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('Change Photo'),
        ),
      ],
    );
  }
}
