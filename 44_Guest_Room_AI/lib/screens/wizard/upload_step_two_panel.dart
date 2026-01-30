import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../theme/guest_theme.dart';
import '../../widgets/gradient_button.dart';
import 'wizard_controller.dart';

class UploadStepTwoPanel extends StatefulWidget {
  final WizardController controller;

  const UploadStepTwoPanel({super.key, required this.controller});

  @override
  State<UploadStepTwoPanel> createState() => _UploadStepTwoPanelState();
}

class _UploadStepTwoPanelState extends State<UploadStepTwoPanel> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 2048,
        maxHeight: 2048,
      );
      if (image != null) {
        widget.controller.setSelectedImage(image.path);
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top Panel: Action Area (Flex 2)
        Expanded(
          flex: 2,
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: GuestAIColors.pureWhite,
              borderRadius: BorderRadius.circular(GuestAIRadii.large),
              border: Border.all(color: GuestAIColors.line),
            ),
            child: widget.controller.selectedImagePath != null
                ? _buildImagePreview(widget.controller.selectedImagePath!)
                : _buildUploadPlaceholder(),
          ),
        ),

        // Bottom Panel: Guidance (Flex 1)
        Expanded(
          flex: 1,
          child: Container(
            color: GuestAIColors.warmLinen,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Text("Photo Tips", style: GuestAIText.h3),
                ),
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildGuidanceCard("Good: Corner View", "Show two walls & floor", true),
                      _buildGuidanceCard("Bad: Too Dark", "Open curtains/turn on lights", false),
                      _buildGuidanceCard("Good: Eye Level", "Shoot from standing height", true),
                      _buildGuidanceCard("Bad: Cluttered", "Remove clothes piles first", false),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_a_photo_outlined, size: 64, color: GuestAIColors.brass),
        const SizedBox(height: 16),
        Text("Upload Your Room", style: GuestAIText.h2),
        Text("Take a photo of the guest room", style: GuestAIText.body.copyWith(color: GuestAIColors.muted)),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GradientButton(
              label: "Camera",
              icon: Icons.camera_alt,
              onPressed: () => _pickImage(ImageSource.camera),
            ),
            const SizedBox(width: 16),
            OutlinedButton.icon(
              onPressed: () => _pickImage(ImageSource.gallery),
              icon: const Icon(Icons.photo_library),
              label: const Text("Gallery"),
              style: OutlinedButton.styleFrom(
                foregroundColor: GuestAIColors.inkTitle,
                side: const BorderSide(color: GuestAIColors.line),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImagePreview(String path) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(GuestAIRadii.large),
          child: Image.file(File(path), fit: BoxFit.cover),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            backgroundColor: GuestAIColors.pureWhite,
            mini: true,
            onPressed: () => widget.controller.setSelectedImage(null),
            child: const Icon(Icons.delete, color: GuestAIColors.error),
          ),
        )
      ],
    );
  }

  Widget _buildGuidanceCard(String title, String subtitle, bool isGood) {
    return Container(
      width: 160,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: GuestAIColors.pureWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isGood ? GuestAIColors.success : GuestAIColors.error, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isGood ? Icons.check_circle : Icons.cancel,
            color: isGood ? GuestAIColors.success : GuestAIColors.error,
          ),
          const SizedBox(height: 8),
          Text(title, style: GuestAIText.bodyMedium),
          const SizedBox(height: 4),
          Text(subtitle, style: GuestAIText.small),
        ],
      ),
    );
  }
}
