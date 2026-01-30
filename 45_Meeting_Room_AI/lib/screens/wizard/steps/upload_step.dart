// lib/screens/wizard/steps/upload_step.dart
// Upload step with two-panel guidance

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../theme/meeting_room_theme.dart';
import '../../../theme/meeting_tokens.dart';
import '../../../widgets/glass_card.dart';
import '../../../widgets/error_toast.dart';
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
        if (mounted) {
          ErrorToast.showSuccess(context, 'Photo selected successfully!');
        }
      }
    } catch (e) {
      if (mounted) {
        ErrorToast.show(
          context,
          'Failed to select photo. Please check permissions.',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _clearImage() {
    widget.controller.setSelectedImage(null);
    if (mounted) {
      ErrorToast.showInfo(context, 'Photo cleared');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final hasImage = widget.controller.selectedImagePath != null;

        if (hasImage) {
          return _buildPreviewState();
        }

        return Column(
          children: [
            // TOP PANEL: GUIDANCE
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: MeetingTokens.surface,
                  border: Border(bottom: BorderSide(color: MeetingTokens.line)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: MeetingTokens.bg0,
                        shape: BoxShape.circle,
                        border: Border.all(color: MeetingTokens.line),
                      ),
                      child: Icon(Icons.tips_and_updates_rounded, size: 32, color: MeetingTokens.accent),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'FRAMING TIPS',
                      style: MeetingRoomText.h3.copyWith(fontSize: 16, letterSpacing: 1),
                    ),
                    const SizedBox(height: 16),
                    _buildTip(Icons.check, 'Stand in the corner to capture widest angle'),
                    _buildTip(Icons.check, 'Ensure adequate lighting'),
                    _buildTip(Icons.check, 'Keep camera level (avoid tilting)'),
                  ],
                ),
              ),
            ),

            // BOTTOM PANEL: ACTION
            Expanded(
              flex: 5,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                color: MeetingTokens.bg0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isLoading)
                       const CircularProgressIndicator()
                    else ...[
                      _buildUploadButton(
                        'CAPTURE PHOTO',
                        Icons.camera_alt_rounded,
                        () => _pickImage(ImageSource.camera),
                        primary: true,
                      ),
                      const SizedBox(height: 16),
                      _buildUploadButton(
                        'SELECT FROM GALLERY',
                        Icons.photo_library_rounded,
                        () => _pickImage(ImageSource.gallery),
                        primary: false,
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTip(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: MeetingTokens.success),
          const SizedBox(width: 8),
          Text(text, style: MeetingRoomText.small.copyWith(color: MeetingTokens.muted)),
        ],
      ),
    );
  }

  Widget _buildUploadButton(String label, IconData icon, VoidCallback onTap, {required bool primary}) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: primary ? MeetingTokens.accent : Colors.transparent,
          foregroundColor: primary ? MeetingTokens.ink0 : MeetingTokens.accent,
          elevation: 0,
          side: primary ? null : BorderSide(color: MeetingTokens.line),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(MeetingTokens.radiusMD)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewState() {
    final imagePath = widget.controller.selectedImagePath!;
    return Stack(
      children: [
        Positioned.fill(
          child: Image.file(
            File(imagePath),
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: 24,
          left: 24,
          right: 24,
          child: GlassCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: _clearImage,
                  icon: const Icon(Icons.delete_rounded, color: MeetingTokens.danger),
                ),
                Text('Photo Selected', style: MeetingRoomText.h3),
                IconButton(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.edit_rounded, color: MeetingTokens.ink0),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
