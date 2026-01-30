import 'dart:io';
import 'package:flutter/material.dart';
import '../../theme/guest_theme.dart';
import 'wizard_controller.dart';
import '../../widgets/gradient_button.dart';

class GuestResultScreen extends StatefulWidget {
  final WizardController controller;
  const GuestResultScreen({super.key, required this.controller});

  @override
  State<GuestResultScreen> createState() => _GuestResultScreenState();
}

class _GuestResultScreenState extends State<GuestResultScreen> {
  bool _showOriginal = false;

  @override
  Widget build(BuildContext context) {
    final resultData = widget.controller.resultData;
    final generatedPath = resultData?.generatedImagePath;
    final originalPath = widget.controller.selectedImagePath;

    final displayPath = _showOriginal ? originalPath : (generatedPath ?? originalPath);

    return Column(
      children: [
        // Image Area
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (displayPath != null)
                Image.file(File(displayPath), fit: BoxFit.cover)
              else
                const Center(child: Text("No image")),

              // Compare Toggle (Pill)
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    onTapDown: (_) => setState(() => _showOriginal = true),
                    onTapUp: (_) => setState(() => _showOriginal = false),
                    onTapCancel: () => setState(() => _showOriginal = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: GuestAIColors.pureWhite,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.compare_arrows, color: GuestAIColors.brass),
                          const SizedBox(width: 8),
                          Text(
                            _showOriginal ? "Original" : "Hold to Compare",
                            style: GuestAIText.button.copyWith(color: GuestAIColors.inkTitle),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Hospitality Notes & Actions
        Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: GuestAIColors.warmLinen,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Hospitality Notes", style: GuestAIText.h2),
              const SizedBox(height: 16),
              _buildNotesPanel(),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => widget.controller.resetWizard(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: GuestAIColors.inkTitle,
                        side: const BorderSide(color: GuestAIColors.line),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text("New Room"),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GradientButton(
                      label: "Save & Share",
                      onPressed: () {
                        // Implement save/share logic
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotesPanel() {
    final config = widget.controller.config;
    // Extract key traits for display
    final items = [
      "Style: ${config.selectedStyleId ?? 'Custom'}",
      "Lighting: ${config.getControlValue('lighting_warmth') ?? 'Standard'}",
      "Bedding: ${config.getControlValue('bedding_tone') ?? 'Standard'}",
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((t) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: GuestAIColors.pureWhite,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: GuestAIColors.line),
        ),
        child: Text(t, style: GuestAIText.small),
      )).toList(),
    );
  }
}
