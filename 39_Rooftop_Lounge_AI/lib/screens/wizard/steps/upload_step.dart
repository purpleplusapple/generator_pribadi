import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/glass_card.dart';
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
        imageQuality: 85,
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
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildAssistPanel(),
              const SizedBox(height: 24),
              _buildPreviewPanel(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAssistPanel() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.nightlight_round, color: DesignTokens.accent),
              const SizedBox(width: 8),
              Text(
                'Night Photo Assist',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: DesignTokens.ink0,
                  fontFamily: 'DM Serif Display',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTip('Avoid low-light blur', Icons.blur_off),
          const SizedBox(height: 8),
          _buildTip('Shoot wide angle if possible', Icons.panorama_wide_angle),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildUploadButton(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onTap: () => _pickImage(ImageSource.camera),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildUploadButton(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  onTap: () => _pickImage(ImageSource.gallery),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewPanel() {
    final hasImage = widget.controller.selectedImagePath != null;

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Preview', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: DesignTokens.ink0)),
          const SizedBox(height: 16),
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              color: DesignTokens.bg0,
              borderRadius: BorderRadius.circular(DesignTokens.radiusM),
              border: Border.all(color: DesignTokens.line.withOpacity(0.5)),
            ),
            child: hasImage
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                    child: Image.file(File(widget.controller.selectedImagePath!), fit: BoxFit.cover),
                  )
                : Center(
                    child: Icon(Icons.image_search, size: 48, color: DesignTokens.ink1.withOpacity(0.3)),
                  ),
          ),
          if (hasImage) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                _buildHelperChip('Brighten'),
                _buildHelperChip('Keep Night'),
                _buildHelperChip('Add Bokeh'),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: _clearImage,
                icon: const Icon(Icons.delete, color: DesignTokens.danger, size: 18),
                label: const Text('Remove', style: TextStyle(color: DesignTokens.danger)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTip(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: DesignTokens.ink1),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(color: DesignTokens.ink1, fontSize: 13)),
      ],
    );
  }

  Widget _buildUploadButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: DesignTokens.surface,
          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
          border: Border.all(color: DesignTokens.line),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: DesignTokens.primary, size: 28),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(color: DesignTokens.ink0, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildHelperChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: DesignTokens.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: DesignTokens.primary.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(color: DesignTokens.primary, fontSize: 12),
      ),
    );
  }
}
