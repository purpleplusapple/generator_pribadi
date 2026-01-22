// lib/screens/wizard/steps/upload_step.dart
// Upload step with Two-Panel Layout
// Option A: Boutique Linen

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../theme/hotel_room_ai_theme.dart';
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
        imageQuality: 90,
      );
      if (image != null) {
        widget.controller.setSelectedImage(image.path);
        if (mounted) ErrorToast.showSuccess(context, 'Room photo uploaded');
      }
    } catch (e) {
      if (mounted) ErrorToast.show(context, 'Failed to select photo');
    } finally {
      if (mounted) setState(() => _isLoading = false);
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

        return Column(
          children: [
            // Panel 1: Action / Tips (Top)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(HotelAISpacing.lg),
              decoration: BoxDecoration(
                color: HotelAIColors.bg1,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                boxShadow: HotelAIShadows.soft,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("1. Upload Room", style: HotelAIText.h2),
                  const SizedBox(height: 8),
                  Text(
                    hasImage
                        ? "Photo analyzing complete."
                        : "For best results, ensure the room is well-lit and angle is wide.",
                    style: HotelAIText.body.copyWith(color: HotelAIColors.muted),
                  ),
                  const SizedBox(height: 24),

                  if (!hasImage)
                    Row(
                      children: [
                        Expanded(
                          child: _UploadButton(
                            icon: Icons.camera_alt_outlined,
                            label: "Camera",
                            onTap: () => _pickImage(ImageSource.camera),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _UploadButton(
                            icon: Icons.image_outlined,
                            label: "Gallery",
                            onTap: () => _pickImage(ImageSource.gallery),
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _pickImage(ImageSource.gallery),
                            icon: const Icon(Icons.refresh, size: 18),
                            label: const Text("Replace"),
                          ),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          onPressed: _clearImage,
                          icon: const Icon(Icons.delete_outline, color: HotelAIColors.error),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            // Panel 2: Preview / Checklist (Bottom)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(HotelAISpacing.lg),
                child: hasImage
                    ? _buildPreview(widget.controller.selectedImagePath!)
                    : _buildChecklist(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildChecklist() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Good Example", style: HotelAIText.h3),
        const SizedBox(height: 16),
        _ChecklistItem(label: "Show floor and ceiling corners"),
        _ChecklistItem(label: "Remove clutter from floor"),
        _ChecklistItem(label: "Avoid people or pets in frame"),
        _ChecklistItem(label: "Straight angle (not tilted)"),
        const Spacer(),
        Center(
          child: Icon(
            Icons.add_a_photo_outlined,
            size: 64,
            color: HotelAIColors.muted.withValues(alpha: 0.2),
          ),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildPreview(String path) {
    return ClipRRect(
      borderRadius: HotelAIRadii.mediumRadius,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.file(File(path), fit: BoxFit.cover),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(12),
              color: Colors.black54,
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    "Image quality: Good",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UploadButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _UploadButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: HotelAIRadii.mediumRadius,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          border: Border.all(color: HotelAIColors.line),
          borderRadius: HotelAIRadii.mediumRadius,
          color: HotelAIColors.bg0,
        ),
        child: Column(
          children: [
            Icon(icon, color: HotelAIColors.primary, size: 32),
            const SizedBox(height: 8),
            Text(label, style: HotelAIText.button),
          ],
        ),
      ),
    );
  }
}

class _ChecklistItem extends StatelessWidget {
  final String label;
  const _ChecklistItem({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(Icons.check, size: 16, color: HotelAIColors.primary),
          const SizedBox(width: 12),
          Text(label, style: HotelAIText.body),
        ],
      ),
    );
  }
}
