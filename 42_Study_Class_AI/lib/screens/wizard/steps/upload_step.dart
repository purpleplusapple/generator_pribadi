import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../theme/app_theme.dart';
import '../../widgets/upload_two_panel_guidance.dart';
import '../wizard_controller.dart';

class UploadStep extends StatelessWidget {
  final WizardController controller;

  const UploadStep({super.key, required this.controller});

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        controller.setSelectedImage(image.path);
        controller.nextStep();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Upload Study Space', style: StudyAIText.h2),
          const SizedBox(height: 8),
          Text(
            'We will redesign your room while keeping the layout intact.',
            style: StudyAIText.bodyMedium.copyWith(color: StudyAIColors.muted),
          ),
          const Spacer(),
          UploadTwoPanelGuidance(
            onUpload: () => _pickImage(context),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
