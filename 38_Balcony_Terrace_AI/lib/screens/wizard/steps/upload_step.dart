import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../theme/terrace_theme.dart';
import '../../../widgets/glass_card.dart';
import '../../../widgets/error_toast.dart';
import '../wizard_controller.dart';
// import 'package:flutter_svg/flutter_svg.dart'; // Using placeholder for now

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
        ErrorToast.show(context, 'Failed to select photo.');
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
          padding: const EdgeInsets.all(TerraceSpacing.base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!hasImage) _buildNightAssistPanel(),
              const SizedBox(height: TerraceSpacing.xl),
              hasImage ? _buildPreview() : _buildActionArea(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNightAssistPanel() {
    return Container(
      padding: const EdgeInsets.all(TerraceSpacing.lg),
      decoration: BoxDecoration(
        color: TerraceColors.surface,
        borderRadius: BorderRadius.circular(TerraceTokens.radiusMedium),
        border: Border.all(color: TerraceColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, color: TerraceColors.accentAmber),
              const SizedBox(width: TerraceSpacing.sm),
              Text('Night Mode Tips', style: TerraceText.h3),
            ],
          ),
          const SizedBox(height: TerraceSpacing.md),
          _TipItem('Ensure some ambient light is visible.'),
          _TipItem('Avoid flash reflection on glass.'),
          _TipItem('Wide angle works best for balconies.'),
        ],
      ),
    );
  }

  Widget _TipItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check, size: 16, color: TerraceColors.success),
          const SizedBox(width: 8),
          Text(text, style: TerraceText.bodySmall),
        ],
      ),
    );
  }

  Widget _buildActionArea() {
    return Column(
      children: [
        _BigUploadButton(
          icon: Icons.camera_alt,
          label: 'Take Night Photo',
          onTap: () => _pickImage(ImageSource.camera),
          isPrimary: true,
        ),
        const SizedBox(height: TerraceSpacing.md),
        _BigUploadButton(
          icon: Icons.image,
          label: 'Upload from Gallery',
          onTap: () => _pickImage(ImageSource.gallery),
          isPrimary: false,
        ),
      ],
    );
  }

  Widget _buildPreview() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(TerraceTokens.radiusLarge),
          child: Image.file(
            File(widget.controller.selectedImagePath!),
            height: 400,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: TerraceSpacing.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _clearImage,
              icon: const Icon(Icons.refresh),
              label: const Text('Retake'),
              style: TextButton.styleFrom(foregroundColor: TerraceColors.danger),
            ),
          ],
        ),
      ],
    );
  }
}

class _BigUploadButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  const _BigUploadButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: isPrimary ? TerraceColors.primaryEmerald.withValues(alpha: 0.2) : TerraceColors.bg1,
          borderRadius: BorderRadius.circular(TerraceTokens.radiusLarge),
          border: Border.all(
            color: isPrimary ? TerraceColors.primaryEmerald : TerraceColors.line,
            width: isPrimary ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: isPrimary ? TerraceColors.primaryEmerald : TerraceColors.muted,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TerraceText.h3.copyWith(
                color: isPrimary ? TerraceColors.primaryEmerald : TerraceColors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
