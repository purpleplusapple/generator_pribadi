import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../theme/clinic_theme.dart';
import '../../../widgets/clinical_card.dart';
import '../wizard_controller.dart';

class UploadStep extends StatefulWidget {
  const UploadStep({super.key, required this.controller});
  final WizardController controller;

  @override
  State<UploadStep> createState() => _UploadStepState();
}

class _UploadStepState extends State<UploadStep> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      widget.controller.setSelectedImage(image.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Panel 1: Upload Area
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(ClinicSpacing.lg),
            child: widget.controller.selectedImagePath != null
                ? _buildImagePreview()
                : _buildUploadPlaceholder(),
          ),
        ),

        // Panel 2: Checklist
        Expanded(
          flex: 4,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(ClinicSpacing.lg),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.checklist_rtl_rounded, color: ClinicColors.primary),
                      const SizedBox(width: 8),
                      Text('Pre-Flight Checklist', style: ClinicText.h3),
                    ],
                  ),
                  const SizedBox(height: ClinicSpacing.base),
                  _buildChecklistItem('Ensure room is well-lit (500+ lux preferred).'),
                  _buildChecklistItem('Clear movable clutter for better accuracy.'),
                  _buildChecklistItem('Capture from a wide angle corner view.'),
                  _buildChecklistItem('Avoid people or patients in the frame.'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadPlaceholder() {
    return ClinicalCard(
      onTap: () => _showImageSourceDialog(),
      backgroundColor: ClinicColors.bg0,
      borderColor: ClinicColors.primary.withValues(alpha: 0.3),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: ClinicColors.primarySoft,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add_a_photo_outlined, size: 40, color: ClinicColors.primary),
            ),
            const SizedBox(height: ClinicSpacing.lg),
            Text('Upload Room Photo', style: ClinicText.h3),
            const SizedBox(height: 8),
            Text(
              'Tap to capture or select from gallery',
              style: ClinicText.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: ClinicRadius.mediumRadius,
          child: Image.file(
            File(widget.controller.selectedImagePath!),
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: FloatingActionButton.small(
            backgroundColor: Colors.white,
            onPressed: () => widget.controller.setSelectedImage(null),
            child: const Icon(Icons.close, color: ClinicColors.danger),
          ),
        ),
      ],
    );
  }

  Widget _buildChecklistItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: ClinicSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline, size: 20, color: ClinicColors.success),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: ClinicText.bodyMedium.copyWith(color: ClinicColors.ink1)),
          ),
        ],
      ),
    );
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(ClinicSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: ClinicColors.ink1),
              title: Text('Camera', style: ClinicText.bodySemiBold),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: ClinicColors.ink1),
              title: Text('Gallery', style: ClinicText.bodySemiBold),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }
}
