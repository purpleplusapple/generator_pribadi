// lib/screens/wizard/steps/result_step.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../theme/mini_bar_theme.dart';
import '../../../../theme/design_tokens.dart';
import '../wizard_controller.dart';

class ResultStep extends StatefulWidget {
  final WizardController controller;
  const ResultStep({super.key, required this.controller});

  @override
  State<ResultStep> createState() => _ResultStepState();
}

class _ResultStepState extends State<ResultStep> {
  bool _showOriginal = false;

  Future<void> _saveToGallery() async {
    final path = widget.controller.resultData?.generatedImagePath;
    if (path == null) return;
    try {
      final res = await ImageGallerySaver.saveFile(path);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved to Gallery')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to save')));
    }
  }

  Future<void> _shareImage() async {
    final path = widget.controller.resultData?.generatedImagePath;
    if (path == null) return;
    await Share.shareXFiles([XFile(path)], text: 'My Mini Bar Design');
  }

  @override
  Widget build(BuildContext context) {
    final originalPath = widget.controller.config.originalImagePath;
    final generatedPath = widget.controller.resultData?.generatedImagePath;

    // Safety check
    if (generatedPath == null) return const Center(child: Text('No result generated'));

    return Column(
      children: [
        // Main Image Area with Toggle
        Expanded(
          flex: 3,
          child: GestureDetector(
            onLongPressStart: (_) => setState(() => _showOriginal = true),
            onLongPressEnd: (_) => setState(() => _showOriginal = false),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(MiniBarRadii.k18),
                  child: Image.file(
                    File(_showOriginal ? originalPath! : generatedPath),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                Positioned(
                  bottom: 16, right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.touch_app, size: 16, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(_showOriginal ? 'Original' : 'Hold to Compare', style: const TextStyle(color: Colors.white, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Notes Panel
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: MiniBarColors.surface,
              borderRadius: BorderRadius.circular(MiniBarRadii.k18),
              border: Border.all(color: MiniBarColors.line),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Bar Setup Notes', style: MiniBarText.h4),
                    Row(
                      children: [
                        IconButton(icon: const Icon(Icons.share), onPressed: _shareImage),
                        IconButton(icon: const Icon(Icons.download), onPressed: _saveToGallery),
                      ],
                    ),
                  ],
                ),
                const Divider(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildNoteRow('Style', widget.controller.config.selectedStyleId ?? 'Custom'),
                        ...widget.controller.config.controlValues.entries.map(
                          (e) => _buildNoteRow(e.key, e.value.toString())
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
    );
  }

  Widget _buildNoteRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label.toUpperCase(), style: MiniBarText.small.copyWith(fontSize: 10, fontWeight: FontWeight.bold)),
          Text(value, style: MiniBarText.bodyMedium),
        ],
      ),
    );
  }
}
