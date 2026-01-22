import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';
import '../../../theme/beauty_salon_ai_theme.dart';
import '../../../widgets/glass_card.dart'; // Used for overlay details
import '../../../widgets/before_after_pill_toggle.dart'; // New component
import '../../../widgets/error_toast.dart';
import '../wizard_controller.dart';

class ResultStep extends StatefulWidget {
  const ResultStep({
    super.key,
    required this.controller,
  });

  final WizardController controller;

  @override
  State<ResultStep> createState() => _ResultStepState();
}

class _ResultStepState extends State<ResultStep> {
  bool _showAfter = true; // Default to showing result

  Future<void> _saveToGallery() async {
    final path = _getCurrentImagePath();
    if (path == null) return;

    try {
      final result = await ImageGallerySaver.saveFile(path);
      if (mounted) {
        if (result['isSuccess'] == true) {
          ErrorToast.showSuccess(context, 'Saved to gallery!');
        } else {
          ErrorToast.show(context, 'Failed to save');
        }
      }
    } catch (e) {
      if (mounted) ErrorToast.show(context, 'Error saving image');
    }
  }

  Future<void> _shareImage() async {
    final path = _getCurrentImagePath();
    if (path == null) return;

    try {
      await Share.shareXFiles([XFile(path)], text: 'Check out my salon design!');
    } catch (e) {
      // Share cancelled or failed
    }
  }

  String? _getCurrentImagePath() {
    if (_showAfter) {
      return widget.controller.resultData?.generatedImagePath;
    } else {
      return widget.controller.selectedImagePath;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BeautyAIColors.bg0,
      body: Stack(
        children: [
          // 1. Hero Image (Full screen background style)
          Positioned.fill(
            bottom: 200, // Leave room for panel
            child: _buildHeroImage(),
          ),

          // 2. Top Action Bar (Glass)
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Pill Toggle
                BeforeAfterPillToggle(
                  isAfter: _showAfter,
                  onToggle: (val) => setState(() => _showAfter = val),
                ),
                // Action Buttons
                Row(
                  children: [
                    _buildGlassIconButton(Icons.save_alt_rounded, _saveToGallery),
                    const SizedBox(width: 8),
                    _buildGlassIconButton(Icons.share_rounded, _shareImage),
                  ],
                ),
              ],
            ),
          ),

          // 3. Detail Panel (Bottom Sheet style)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 220,
            child: Container(
              padding: const EdgeInsets.all(BeautyAISpacing.lg),
              decoration: BoxDecoration(
                color: BeautyAIColors.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: BeautyAIShadows.floating,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: BeautyAIColors.line,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Transformation Complete',
                    style: BeautyAIText.h2,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your salon design is ready using the selected styles.',
                    style: BeautyAIText.body.copyWith(color: BeautyAIColors.muted),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        widget.controller.resetWizard();
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      child: const Text('Design Another Space'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage() {
    final path = _getCurrentImagePath();
    if (path == null) {
      return Container(
        color: BeautyAIColors.bg0,
        child: Center(child: Text('No image', style: BeautyAIText.caption)),
      );
    }
    return Image.file(File(path), fit: BoxFit.cover);
  }

  Widget _buildGlassIconButton(IconData icon, VoidCallback onTap) {
    return Container(
      height: 48,
      width: 48,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2), // Glass
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white), // Contrast against image
        onPressed: onTap,
      ),
    );
  }
}
