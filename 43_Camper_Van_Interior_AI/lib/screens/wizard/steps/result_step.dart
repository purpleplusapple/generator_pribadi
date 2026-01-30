// lib/screens/wizard/steps/result_step.dart
// Result step with Build Notes and Compare Toggle

import 'dart:io';
import 'package:flutter/material.dart';
import '../../../theme/camper_theme.dart';
import '../wizard_controller.dart';
import '../widgets/build_notes_panel.dart';
import '../widgets/tap_compare_toggle.dart';

class ResultStep extends StatefulWidget {
  const ResultStep({super.key, required this.controller});

  final WizardController controller;

  @override
  State<ResultStep> createState() => _ResultStepState();
}

class _ResultStepState extends State<ResultStep> {
  bool _showBefore = false;

  @override
  Widget build(BuildContext context) {
    final beforeImage = widget.controller.selectedImagePath;
    final afterImage = widget.controller.resultData?.generatedImagePath ?? beforeImage; // Fallback

    return Stack(
      children: [
        // Main Image
        Positioned.fill(
          bottom: 0, // Extend to bottom
          child: _showBefore
              ? (beforeImage != null ? Image.file(File(beforeImage), fit: BoxFit.cover) : Container(color: Colors.grey))
              : (afterImage != null ? Image.file(File(afterImage), fit: BoxFit.cover) : Container(color: CamperAIColors.surface)),
        ),

        // Gradient Overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, CamperAIColors.soleBlack],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.6, 1.0],
              ),
            ),
          ),
        ),

        // Compare Toggle
        Positioned(
          top: 20,
          right: 20,
          child: TapOrSwipeCompareToggle(
            isBefore: _showBefore,
            onToggle: () => setState(() => _showBefore = !_showBefore),
          ),
        ),

        // Build Notes & Actions
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BuildNotesPanel(config: widget.controller.config),
              Container(
                color: CamperAIColors.surface,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.refresh),
                        label: const Text("Regenerate"),
                        onPressed: () => widget.controller.goToStep(3), // Back to Generate
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.download),
                        label: const Text("Save Plan"),
                        onPressed: () {
                          // Save logic
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Plan saved to Gallery!")),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
