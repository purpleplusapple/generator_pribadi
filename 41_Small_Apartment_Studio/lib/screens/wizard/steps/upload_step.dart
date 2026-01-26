import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../theme/apartment_tokens.dart';
import '../wizard_controller.dart';

class UploadStep extends StatefulWidget {
  const UploadStep({super.key, required this.controller});
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
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to select photo')),
      );
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

        return SingleChildScrollView(
          padding: const EdgeInsets.all(ApartmentTokens.s16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Text(
                'Capture your Space',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ApartmentTokens.ink0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'For best results, show the whole room.',
                style: TextStyle(color: ApartmentTokens.ink1),
              ),
              const SizedBox(height: ApartmentTokens.s24),

              // Upload Area
              if (!hasImage)
                _buildUploadButtons()
              else
                _buildImagePreview(widget.controller.selectedImagePath!),

              const SizedBox(height: ApartmentTokens.s24),

              // Tips Panel
              _buildTipsPanel(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUploadButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            icon: Icons.camera_enhance,
            label: 'Take Photo',
            color: ApartmentTokens.primary,
            onTap: () => _pickImage(ImageSource.camera),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildActionButton(
            icon: Icons.collections,
            label: 'Upload',
            color: ApartmentTokens.accent,
            onTap: () => _pickImage(ImageSource.gallery),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: ApartmentTokens.surface,
          borderRadius: BorderRadius.circular(ApartmentTokens.r16),
          border: Border.all(color: ApartmentTokens.line),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ApartmentTokens.ink0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview(String path) {
    return Column(
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(ApartmentTokens.r16),
              child: Image.file(
                File(path),
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                onPressed: _clearImage,
                style: IconButton.styleFrom(backgroundColor: Colors.black54),
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildChip('Prefer brighter'),
            _buildChip('Keep natural'),
            _buildChip('Add mirrors'),
          ],
        ),
      ],
    );
  }

  Widget _buildChip(String label) {
    return Chip(
      label: Text(label),
      backgroundColor: ApartmentTokens.primarySoft,
      labelStyle: const TextStyle(color: ApartmentTokens.primary, fontWeight: FontWeight.bold),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  Widget _buildTipsPanel() {
    return Container(
      padding: const EdgeInsets.all(ApartmentTokens.s16),
      decoration: BoxDecoration(
        color: ApartmentTokens.surface,
        borderRadius: BorderRadius.circular(ApartmentTokens.r16),
        border: Border.all(color: ApartmentTokens.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.tips_and_updates, color: ApartmentTokens.accent, size: 20),
              SizedBox(width: 8),
              Text(
                'Studio Tips',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: ApartmentTokens.ink0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTipRow('Stand in the corner to capture maximum depth.'),
          _buildTipRow('Ensure the window is visible for light estimation.'),
          _buildTipRow('Declutter small items for cleaner results.'),
        ],
      ),
    );
  }

  Widget _buildTipRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•', style: TextStyle(color: ApartmentTokens.muted)),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(color: ApartmentTokens.ink1))),
        ],
      ),
    );
  }
}
