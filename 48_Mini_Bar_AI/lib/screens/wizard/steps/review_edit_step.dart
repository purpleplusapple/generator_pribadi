// lib/screens/wizard/steps/review_edit_step.dart
import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../theme/mini_bar_theme.dart';
import '../../../../theme/design_tokens.dart';
import '../wizard_controller.dart';

class ReviewEditStep extends StatefulWidget {
  final WizardController controller;
  const ReviewEditStep({super.key, required this.controller});

  @override
  State<ReviewEditStep> createState() => _ReviewEditStepState();
}

class _ReviewEditStepState extends State<ReviewEditStep> {
  @override
  Widget build(BuildContext context) {
    final config = widget.controller.config;
    final path = config.originalImagePath;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Review Manifesto', style: MiniBarText.h2),
          const SizedBox(height: 24),

          // Photo
          if (path != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(MiniBarRadii.k18),
              child: Stack(
                children: [
                  Image.file(File(path), height: 200, width: double.infinity, fit: BoxFit.cover),
                  Positioned(
                    bottom: 8, right: 8,
                    child: IconButton.filled(
                      onPressed: () => widget.controller.goToStep(0),
                      icon: const Icon(Icons.edit),
                    ),
                  )
                ],
              ),
            ),

          const SizedBox(height: 24),

          // Specs
          Container(
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
                    Text('Specification', style: MiniBarText.h4),
                    IconButton(onPressed: () => widget.controller.goToStep(1), icon: const Icon(Icons.tune, size: 16)),
                  ],
                ),
                const Divider(),
                _buildRow('Style', config.selectedStyleId ?? 'Custom'),
                ...config.controlValues.entries.map((e) => _buildRow(e.key, e.value.toString())),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: MiniBarText.small.copyWith(color: MiniBarColors.muted)),
          Text(val, style: MiniBarText.bodyMedium),
        ],
      ),
    );
  }
}
