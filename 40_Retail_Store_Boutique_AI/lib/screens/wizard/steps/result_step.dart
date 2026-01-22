// lib/screens/wizard/steps/result_step.dart
// Result step with Before/After toggle and Zones details

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';
import '../../../theme/boutique_theme.dart';
import '../../../widgets/glass_card.dart';
import '../../../widgets/error_toast.dart';
import '../wizard_controller.dart';

class ResultStep extends StatefulWidget {
  const ResultStep({super.key, required this.controller});
  final WizardController controller;

  @override
  State<ResultStep> createState() => _ResultStepState();
}

class _ResultStepState extends State<ResultStep> {
  bool _showAfter = true;

  void _saveToGallery() async {
    final path = _showAfter
        ? widget.controller.resultData?.generatedImagePath
        : widget.controller.selectedImagePath;

    if (path == null) return;

    try {
      final res = await ImageGallerySaver.saveFile(path);
      if (mounted) ErrorToast.showSuccess(context, res['isSuccess'] ? 'Saved!' : 'Failed to save');
    } catch (e) {
      if (mounted) ErrorToast.show(context, 'Error saving image');
    }
  }

  void _shareImage() async {
    final path = widget.controller.resultData?.generatedImagePath;
    if (path == null) return;
    Share.shareXFiles([XFile(path)], text: 'My Boutique Redesign');
  }

  @override
  Widget build(BuildContext context) {
    final original = widget.controller.selectedImagePath;
    final generated = widget.controller.resultData?.generatedImagePath;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Before/After View
          if (generated != null && original != null)
             _buildBeforeAfterViewer(original, generated),

          const SizedBox(height: 24),

          // Detail Panel
          const _ZonesDetailPanel(),

          const SizedBox(height: 24),

          // Action Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionIcon(Icons.save_alt, "Save", _saveToGallery),
              _buildActionIcon(Icons.share, "Share", _shareImage),
              _buildActionIcon(Icons.refresh, "Regenerate", () => widget.controller.goToStep(1)), // Go back to style
            ],
          ),

          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              widget.controller.resetWizard();
              Navigator.pop(context); // Close wizard
            },
            child: const Text("CLOSE DESIGN STUDIO"),
          ),
        ],
      ),
    );
  }

  Widget _buildBeforeAfterViewer(String original, String generated) {
    return Column(
      children: [
        // Toggle Switch
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: BoutiqueColors.surface,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: BoutiqueColors.line),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildToggleOption("Before", !_showAfter),
              _buildToggleOption("After", _showAfter),
            ],
          ),
        ),

        // Image Area
        GestureDetector(
          onTap: () => setState(() => _showAfter = !_showAfter),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: ClipRRect(
              key: ValueKey(_showAfter),
              borderRadius: BorderRadius.circular(20),
              child: Image.file(
                File(_showAfter ? generated : original),
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text("Tap image to switch view", style: BoutiqueText.caption),
      ],
    );
  }

  Widget _buildToggleOption(String label, bool isActive) {
    return GestureDetector(
      onTap: () => setState(() => _showAfter = label == "After"),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? BoutiqueColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          label,
          style: BoutiqueText.small.copyWith(
            color: isActive ? BoutiqueColors.bg0 : BoutiqueColors.ink1,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildActionIcon(IconData icon, String label, VoidCallback onTap) {
    return Column(
      children: [
        IconButton(
          onPressed: onTap,
          icon: Icon(icon, color: BoutiqueColors.ink0),
          style: IconButton.styleFrom(
            backgroundColor: BoutiqueColors.surface,
            padding: const EdgeInsets.all(12),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: BoutiqueText.caption),
      ],
    );
  }
}

class _ZonesDetailPanel extends StatelessWidget {
  const _ZonesDetailPanel();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Store Analysis", style: BoutiqueText.h3),
          const SizedBox(height: 16),
          _buildDetailRow("Lighting", "Warm Accent added", Icons.lightbulb_outline),
          Divider(color: BoutiqueColors.line.withValues(alpha: 0.5)),
          _buildDetailRow("Materials", "Black Marble & Gold", Icons.texture),
          Divider(color: BoutiqueColors.line.withValues(alpha: 0.5)),
          _buildDetailRow("Displays", "Optimization suggested", Icons.storefront),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: BoutiqueColors.muted),
          const SizedBox(width: 12),
          Text(label, style: BoutiqueText.bodyMedium.copyWith(color: BoutiqueColors.muted)),
          const Spacer(),
          Text(value, style: BoutiqueText.bodyMedium.copyWith(color: BoutiqueColors.ink0)),
        ],
      ),
    );
  }
}
