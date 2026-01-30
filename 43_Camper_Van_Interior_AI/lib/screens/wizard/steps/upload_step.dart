// lib/screens/wizard/steps/upload_step.dart
// Upload step using Two-panel layout

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../wizard_controller.dart';
import '../widgets/upload_two_panel.dart';
import '../../../widgets/error_toast.dart';

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

  // Note: Two-panel UI handles loading state visually by not showing spinners but just transitions
  // but if we wanted, we could add overlay. For now, simplistic.

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 85,
      );

      if (image != null) {
        widget.controller.setSelectedImage(image.path);
        // Auto advance if needed, or let user click next.
        // For two-panel, often picking image is the "Action" that enables Next.
        if (mounted) {
           ErrorToast.showSuccess(context, 'Photo selected!');
           // Optional: widget.controller.nextStep();
        }
      }
    } catch (e) {
      if (mounted) {
        ErrorToast.show(context, 'Failed to select photo.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // If image is selected, show preview or confirmation
    // The TwoPanel widget is designed for "Empty State" guidance + upload.
    // If image exists, we might show a different view or the same view with "Change" option.
    // For this prototype, if image exists, we can show a simple "Continue" or "Change" UI.

    if (widget.controller.selectedImagePath != null) {
      return _buildImageSelectedState();
    }

    return UploadTwoPanelGuidance(
      onGalleryTap: () => _pickImage(ImageSource.gallery),
      onCameraTap: () => _pickImage(ImageSource.camera),
    );
  }

  Widget _buildImageSelectedState() {
     // Reusing the logic from the old one but simpler
     return Center(
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
            // Preview
            Container(
               height: 300,
               margin: const EdgeInsets.all(20),
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(20),
                 image: DecorationImage(
                   image: FileImage(File(widget.controller.selectedImagePath!)),
                   fit: BoxFit.cover,
                 )
               ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  child: const Text("Change Photo"),
                ),
              ],
            )
         ],
       ),
     );
  }
}
// Import required for File
import 'dart:io';
