import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../theme/camper_tokens.dart';
import '../widgets/upload_two_panel.dart';
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
      }
    } catch (e) {
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text("Failed to pick image")),
       );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final imagePath = widget.controller.selectedImagePath;
        final selectedImage = imagePath != null ? File(imagePath) : null;

        return Column(
          children: [
             Expanded(
               child: UploadTwoPanelGuidance(
                 selectedImage: selectedImage,
                 onPickImage: () => _pickImage(ImageSource.gallery),
                 onTakePhoto: () => _pickImage(ImageSource.camera),
               ),
             ),
             Padding(
               padding: const EdgeInsets.all(16),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.end,
                 children: [
                   if (selectedImage != null)
                     ElevatedButton(
                       onPressed: widget.controller.nextStep,
                       style: ElevatedButton.styleFrom(
                         backgroundColor: CamperTokens.primary,
                         foregroundColor: Colors.black,
                         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                       ),
                       child: const Row(
                         children: [
                           Text("Continue to Style", style: TextStyle(fontWeight: FontWeight.bold)),
                           SizedBox(width: 8),
                           Icon(Icons.arrow_forward)
                         ],
                       ),
                     )
                 ],
               ),
             )
          ],
        );
      },
    );
  }
}
