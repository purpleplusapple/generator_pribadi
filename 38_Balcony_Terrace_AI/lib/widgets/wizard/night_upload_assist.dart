import 'dart:io';
import 'package:flutter/material.dart';
import '../../theme/design_tokens.dart';
import '../../theme/terrace_theme.dart';
import 'package:image_picker/image_picker.dart';

class NightUploadAssistPanel extends StatefulWidget {
  final Function(File) onImageSelected;
  final VoidCallback onNext;

  const NightUploadAssistPanel({
    super.key,
    required this.onImageSelected,
    required this.onNext,
  });

  @override
  State<NightUploadAssistPanel> createState() => _NightUploadAssistPanelState();
}

class _NightUploadAssistPanelState extends State<NightUploadAssistPanel> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      widget.onImageSelected(_image!);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_image != null) {
      return _buildPreviewState();
    }
    return _buildInstructionState();
  }

  Widget _buildInstructionState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Capture Your Space',
          style: terraceTheme.textTheme.headlineMedium?.copyWith(color: DesignTokens.ink0),
        ),
        const SizedBox(height: 8),
        const Text(
          'For best night mode results, follow these tips:',
          style: TextStyle(color: DesignTokens.muted),
        ),
        const SizedBox(height: 24),
        _buildTip(Icons.photo_camera, 'Use Wide Angle', 'Capture the whole floor and railing.'),
        _buildTip(Icons.flash_off, 'Avoid Flash Glare', 'Use natural ambient light if possible.'),
        _buildTip(Icons.nightlight_round, 'Night or Dusk', 'Best results with evening photos.'),

        const Spacer(),

        ElevatedButton.icon(
          onPressed: () => _pickImage(ImageSource.gallery),
          icon: const Icon(Icons.photo_library),
          label: const Text('Upload from Gallery'),
          style: ElevatedButton.styleFrom(
            backgroundColor: DesignTokens.surface2,
            foregroundColor: DesignTokens.ink0,
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () => _pickImage(ImageSource.camera),
          icon: const Icon(Icons.camera_alt),
          label: const Text('Take Night Photo'),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildPreviewState() {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: DesignTokens.primary, width: 2),
              image: DecorationImage(
                image: FileImage(_image!),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 16,
                  right: 16,
                  child: IconButton(
                    onPressed: () => setState(() => _image = null),
                    icon: const Icon(Icons.close, color: Colors.white),
                    style: IconButton.styleFrom(backgroundColor: Colors.black54),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.check_circle, color: DesignTokens.success, size: 16),
                        SizedBox(width: 8),
                        Text('Photo Ready', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: widget.onNext,
            child: const Text('Continue to Style'),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildTip(IconData icon, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: DesignTokens.surface2,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: DesignTokens.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: DesignTokens.ink0, fontWeight: FontWeight.bold)),
                Text(desc, style: const TextStyle(color: DesignTokens.muted, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
