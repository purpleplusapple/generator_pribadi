// lib/screens/wizard/steps/upload_step.dart
// Upload step with photo selection and preview

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../theme/shoe_room_ai_theme.dart';
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

        return SingleChildScrollView(
          padding: const EdgeInsets.all(ShoeAISpacing.base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: ShoeAISpacing.lg),
              
              // Title
              Text(
                'Upload Your Shoe Room',
                style: ShoeAIText.h2,
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: ShoeAISpacing.sm),
              
              // Subtitle
              Text(
                hasImage
                    ? 'Perfect! This is your shoe room photo.'
                    : 'Take or select a photo of your current shoe room or closet',
                style: ShoeAIText.body.copyWith(
                  color: ShoeAIColors.canvasWhite.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: ShoeAISpacing.xxl),
              
              // Image preview or upload buttons
              if (hasImage)
                _buildImagePreview()
              else
                _buildUploadButtons(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUploadButtons() {
    return Column(
      children: [
        // Premium vertical card layout
        // Camera Card - Large prominent design
        _buildUploadCard(
          icon: Icons.camera_alt_rounded,
          title: 'Capture New Photo',
          subtitle: 'Open your device camera to take a fresh photo',
          gradient: ShoeAIGradients.primaryCta,
          onTap: _isLoading ? null : () => _pickImage(ImageSource.camera),
          badge: 'RECOMMENDED',
        ),
        
        const SizedBox(height: ShoeAISpacing.lg),
        
        // Divider with text
        Row(
          children: [
            const Expanded(
              child: Divider(
                color: ShoeAIColors.canvasWhite,
                thickness: 1,
                height: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: ShoeAISpacing.md),
              child: Text(
                'OR',
                style: ShoeAIText.caption.copyWith(
                  color: ShoeAIColors.canvasWhite.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),
            ),
            const Expanded(
              child: Divider(
                color: ShoeAIColors.canvasWhite,
                thickness: 1,
                height: 1,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: ShoeAISpacing.lg),
        
        // Gallery Card - Secondary option
        _buildUploadCard(
          icon: Icons.photo_library_rounded,
          title: 'Choose from Gallery',
          subtitle: 'Select an existing photo from your collection',
          gradient: LinearGradient(
            colors: [
              ShoeAIColors.leatherTan.withValues(alpha: 0.3),
              ShoeAIColors.metallicGold.withValues(alpha: 0.2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          onTap: _isLoading ? null : () => _pickImage(ImageSource.gallery),
        ),
        
        if (_isLoading) ...[
          const SizedBox(height: ShoeAISpacing.xxl),
          Column(
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(ShoeAIColors.leatherTan),
                strokeWidth: 3,
              ),
              const SizedBox(height: ShoeAISpacing.md),
              Text(
                'Preparing your photo...',
                style: ShoeAIText.caption.copyWith(
                  color: ShoeAIColors.canvasWhite.withValues(alpha: 0.7),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildUploadCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Gradient gradient,
    required VoidCallback? onTap,
    String? badge,
  }) {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: ShoeAIRadii.cardRadius,
        child: Container(
          padding: const EdgeInsets.all(ShoeAISpacing.xl),
          decoration: BoxDecoration(
            borderRadius: ShoeAIRadii.cardRadius,
            border: Border.all(
              color: ShoeAIColors.metallicGold.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Icon container with gradient
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(ShoeAISpacing.md),
                  boxShadow: [
                    BoxShadow(
                      color: ShoeAIColors.metallicGold.withValues(alpha: 0.2),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  size: 36,
                  color: ShoeAIColors.soleBlack,
                ),
              ),
              
              const SizedBox(width: ShoeAISpacing.lg),
              
              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: ShoeAIText.h3.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        if (badge != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: ShoeAISpacing.sm,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              gradient: ShoeAIGradients.accentHighlight,
                              borderRadius: BorderRadius.circular(ShoeAIRadii.chip),
                            ),
                            child: Text(
                              badge,
                              style: ShoeAIText.small.copyWith(
                                color: ShoeAIColors.soleBlack,
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: ShoeAISpacing.xs),
                    Text(
                      subtitle,
                      style: ShoeAIText.caption.copyWith(
                        color: ShoeAIColors.canvasWhite.withValues(alpha: 0.6),
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: ShoeAISpacing.sm),
              
              // Arrow icon
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 20,
                color: ShoeAIColors.canvasWhite.withValues(alpha: 0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    final imagePath = widget.controller.selectedImagePath!;

    return Column(
      children: [
        // Image preview with overlay
        GlassCard(
          padding: EdgeInsets.zero,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: ShoeAIRadii.cardRadius,
                child: Image.file(
                  File(imagePath),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 450,
                ),
              ),
              
              // Top overlay with info
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        ShoeAIColors.soleBlack.withValues(alpha: 0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(ShoeAISpacing.md),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: ShoeAIColors.metallicGold,
                        size: 24,
                      ),
                      const SizedBox(width: ShoeAISpacing.sm),
                      Expanded(
                        child: Text(
                          'Photo Ready',
                          style: ShoeAIText.h3.copyWith(
                            fontSize: 16,
                            shadows: [
                              Shadow(
                                color: ShoeAIColors.soleBlack,
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: ShoeAISpacing.lg),
        
        // Premium action buttons (vertical layout)
        _buildActionButton(
          icon: Icons.swap_horiz_rounded,
          label: 'Change Photo',
          subtitle: 'Select a different photo',
          color: ShoeAIColors.leatherTan,
          onPressed: () => _showImageSourceDialog(),
        ),
        
        const SizedBox(height: ShoeAISpacing.md),
        
        _buildActionButton(
          icon: Icons.delete_sweep_rounded,
          label: 'Remove Photo',
          subtitle: 'Start over with a new upload',
          color: ShoeAIColors.error.withValues(alpha: 0.8),
          onPressed: _clearImage,
          isDestructive: true,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required VoidCallback onPressed,
    bool isDestructive = false,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color.withValues(alpha: 0.3), width: 1.5),
        padding: const EdgeInsets.all(ShoeAISpacing.md),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ShoeAISpacing.md),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ShoeAIRadii.chip),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: ShoeAISpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: ShoeAIText.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: ShoeAIColors.canvasWhite,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: ShoeAIText.caption.copyWith(
                    color: ShoeAIColors.canvasWhite.withValues(alpha: 0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: color.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ShoeAIColors.soleBlack,
        title: Text(
          'Choose Image Source',
          style: ShoeAIText.h3,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded, color: ShoeAIColors.leatherTan),
              title: const Text('Camera'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded, color: ShoeAIColors.metallicGold),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }
}
