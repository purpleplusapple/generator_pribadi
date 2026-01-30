// lib/screens/wizard/steps/upload_step.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../theme/mini_bar_theme.dart';
import '../../../../theme/design_tokens.dart';
import '../wizard_controller.dart';

class UploadStep extends StatefulWidget {
  final WizardController controller;
  const UploadStep({super.key, required this.controller});

  @override
  State<UploadStep> createState() => _UploadStepState();
}

class _UploadStepState extends State<UploadStep> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) widget.controller.setImage(image.path);
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = widget.controller.config.originalImagePath != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        Text(hasImage ? 'Analysis Ready' : 'Capture Your Corner', style: MiniBarText.h2),
        const SizedBox(height: 8),
        Text('We will transform this space into a luxury bar.', style: MiniBarText.body.copyWith(color: MiniBarColors.muted)),
        const SizedBox(height: 24),

        // Split Layout (Guidance + Action)
        Expanded(
          child: hasImage ? _buildPreview() : _buildGuidanceAndUpload(),
        ),
      ],
    );
  }

  Widget _buildGuidanceAndUpload() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Guidance Panel
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: MiniBarColors.surface2.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(MiniBarRadii.k18),
              border: Border.all(color: MiniBarColors.line.withValues(alpha: 0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pro Tips for Best Results', style: MiniBarText.h4.copyWith(color: MiniBarColors.primary)),
                const SizedBox(height: 12),
                _buildTip(Icons.light_mode, 'Ensure room is well-lit'),
                _buildTip(Icons.cleaning_services, 'Clear clutter from corner'),
                _buildTip(Icons.crop_free, 'Capture floor to ceiling'),
                const SizedBox(height: 16),
                Center(
                  child: SvgPicture.asset(
                    'assets/onboarding/onboard_1.svg',
                    height: 100,
                    placeholderBuilder: (_) => const Icon(Icons.image, size: 60, color: MiniBarColors.muted),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Action Panel
          Row(
            children: [
              Expanded(
                child: _buildUploadCard(
                  'Camera', Icons.camera_alt,
                  () => _pickImage(ImageSource.camera)
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildUploadCard(
                  'Gallery', Icons.photo_library,
                  () => _pickImage(ImageSource.gallery)
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTip(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: MiniBarColors.muted),
          const SizedBox(width: 8),
          Text(text, style: MiniBarText.small),
        ],
      ),
    );
  }

  Widget _buildUploadCard(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: MiniBarColors.surface,
          borderRadius: BorderRadius.circular(MiniBarRadii.k18),
          border: Border.all(color: MiniBarColors.primary.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: MiniBarColors.primary),
            const SizedBox(height: 8),
            Text(label, style: MiniBarText.button.copyWith(color: MiniBarColors.ink0)),
          ],
        ),
      ),
    );
  }

  Widget _buildPreview() {
    return Column(
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(MiniBarRadii.k18),
              image: DecorationImage(
                image: FileImage(File(widget.controller.config.originalImagePath!)),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: () => widget.controller.setImage(null),
              icon: const Icon(Icons.refresh),
              label: const Text('Retake'),
            ),
          ],
        ),
      ],
    );
  }
}
