import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import '../../theme/beauty_theme.dart';
import '../../theme/beauty_tokens.dart';

class UploadStudioStep extends StatefulWidget {
  final File? selectedImage;
  final Function(File) onImageSelected;

  const UploadStudioStep({
    super.key,
    required this.selectedImage,
    required this.onImageSelected,
  });

  @override
  State<UploadStudioStep> createState() => _UploadStudioStepState();
}

class _UploadStudioStepState extends State<UploadStudioStep> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        widget.onImageSelected(File(image.path));
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upload Space',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'Photo of your current salon or empty room',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: BeautyTheme.muted),
        ),
        const SizedBox(height: 24),

        // Main Upload Area
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // 1. Image Card
                GestureDetector(
                  onTap: () => _pickImage(ImageSource.gallery),
                  child: Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(BeautyTokens.radiusL),
                      border: Border.all(
                        color: BeautyTheme.primary.withOpacity(0.3),
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                      boxShadow: BeautyTokens.shadowSoft,
                    ),
                    child: widget.selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(BeautyTokens.radiusL - 2),
                            child: Image.file(
                              widget.selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: BeautyTheme.primary.withOpacity(0.05),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.add_a_photo_outlined,
                                  size: 48,
                                  color: BeautyTheme.primary,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Tap to Upload',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: BeautyTheme.primary,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),

                const SizedBox(height: 24),

                // 2. Guidance Panel (The "Second Panel")
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BeautyTokens.liquidGlass(
                    opacity: 0.6,
                    radius: BeautyTokens.radiusM,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.lightbulb_outline, color: BeautyTheme.accent2),
                          SizedBox(width: 8),
                          Text('Pro Tips for Best Results', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildTip(Icons.check, 'Ensure good lighting (daylight is best)'),
                      _buildTip(Icons.check, 'Capture the full room width'),
                      _buildTip(Icons.close, 'Avoid blurry or dark photos'),
                      _buildTip(Icons.close, 'Avoid people in the frame if possible'),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _pickImage(ImageSource.camera),
                        icon: const Icon(Icons.camera_alt_outlined),
                        label: const Text('Camera'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.gallery),
                        icon: const Icon(Icons.photo_library_outlined),
                        label: const Text('Gallery'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTip(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: icon == Icons.check ? BeautyTheme.success : BeautyTheme.danger),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}
