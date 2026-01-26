import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/glass_card.dart';
import '../../../widgets/gradient_button.dart';
import '../../../widgets/error_toast.dart';
import '../../../widgets/image_comparison_slider.dart';
import '../wizard_controller.dart';

class ResultStep extends StatefulWidget {
  const ResultStep({super.key, required this.controller});
  final WizardController controller;

  @override
  State<ResultStep> createState() => _ResultStepState();
}

class _ResultStepState extends State<ResultStep> {
  bool _showComparison = false;

  Future<void> _saveToGallery() async {
    final resultData = widget.controller.resultData;
    final imagePath = resultData?.generatedImagePath;
    if (imagePath == null) return;
    try {
      final result = await ImageGallerySaver.saveFile(imagePath);
      if (mounted) {
        if (result['isSuccess'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved to gallery!')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to save')));
        }
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error saving image')));
    }
  }

  Future<void> _shareImage() async {
    final resultData = widget.controller.resultData;
    final imagePath = resultData?.generatedImagePath;
    if (imagePath == null) return;
    await Share.shareXFiles([XFile(imagePath)], text: 'Check out my Small Apartment Studio AI redesign!');
  }

  void _tryAgain() {
    widget.controller.resetWizard();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final resultData = widget.controller.resultData;
        final generatedPath = resultData?.generatedImagePath;
        final originalPath = widget.controller.selectedImagePath;

        if (generatedPath == null) return const Center(child: Text('No result data', style: TextStyle(color: DesignTokens.ink0)));

        return Stack(
          children: [
            // Full screen image or comparison
            Positioned.fill(
              child: _showComparison && originalPath != null
                  ? ImageComparisonSlider(beforeImagePath: originalPath, afterImagePath: generatedPath)
                  : Image.file(File(generatedPath), fit: BoxFit.cover),
            ),

            // UI Overlays
            SafeArea(
              child: Column(
                children: [
                  // Top Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 48), // Spacer
                        if (originalPath != null)
                          GestureDetector(
                            onTap: () => setState(() => _showComparison = !_showComparison),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: DesignTokens.surface.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Icon(_showComparison ? Icons.check_circle : Icons.compare_arrows, color: DesignTokens.primary, size: 16),
                                  const SizedBox(width: 8),
                                  Text(_showComparison ? 'View Result' : 'Compare', style: const TextStyle(color: DesignTokens.ink0)),
                                ],
                              ),
                            ),
                          ),
                        CircleAvatar(
                          backgroundColor: DesignTokens.surface.withOpacity(0.5),
                          child: IconButton(
                            icon: const Icon(Icons.close, color: DesignTokens.ink0),
                            onPressed: () => widget.controller.resetWizard(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Bottom Panel
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          DesignTokens.bg0.withOpacity(0.95),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildSceneControls(),
                        const SizedBox(height: 24),
                        _buildActions(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSceneControls() {
    return GlassCard(
      fillOpacity: 0.1,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.tune, color: DesignTokens.primary, size: 16),
              const SizedBox(width: 8),
              Text('Scene Vibe', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: DesignTokens.ink1)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildControlItem('Warmth', Icons.wb_sunny_outlined, true),
              _buildControlItem('Neon', Icons.blur_on, false),
              _buildControlItem('Greenery', Icons.park_outlined, false),
              _buildControlItem('Fog', Icons.cloud_outlined, false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlItem(String label, IconData icon, bool isActive) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
             color: isActive ? DesignTokens.primary.withOpacity(0.2) : Colors.transparent,
             shape: BoxShape.circle,
             border: isActive ? Border.all(color: DesignTokens.primary) : null,
          ),
          child: Icon(icon, color: isActive ? DesignTokens.primary : DesignTokens.ink1.withOpacity(0.5), size: 20),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: isActive ? DesignTokens.primary : DesignTokens.ink1.withOpacity(0.5), fontSize: 10)),
      ],
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionBtn(Icons.save_alt, 'Save', _saveToGallery),
        _buildActionBtn(Icons.share, 'Share', _shareImage),
        _buildActionBtn(Icons.refresh, 'Regen', _tryAgain),
      ],
    );
  }

  Widget _buildActionBtn(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: DesignTokens.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: DesignTokens.line.withOpacity(0.5)),
            ),
            child: Icon(icon, color: DesignTokens.ink0),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: DesignTokens.ink0, fontSize: 12)),
        ],
      ),
    );
  }
}
