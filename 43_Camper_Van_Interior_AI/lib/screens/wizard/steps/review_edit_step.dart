// lib/screens/wizard/steps/review_edit_step.dart
// Review step: Add notes and verify choices before generation

import 'package:flutter/material.dart';
import '../../../theme/camper_theme.dart';
import '../../../widgets/glass_card.dart';
import '../../../widgets/gradient_button.dart';
import '../wizard_controller.dart';

class ReviewEditStep extends StatefulWidget {
  const ReviewEditStep({
    super.key,
    required this.controller,
  });

  final WizardController controller;

  @override
  State<ReviewEditStep> createState() => _ReviewEditStepState();
}

class _ReviewEditStepState extends State<ReviewEditStep> {
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: widget.controller.reviewNotes);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(CamperAISpacing.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("Refine Your Vision", style: CamperAIText.h2, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text("Add specific instructions for the AI.",
            style: CamperAIText.body.copyWith(color: CamperAIColors.muted), textAlign: TextAlign.center),

          const SizedBox(height: 24),

          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Special Instructions", style: CamperAIText.h3),
                const SizedBox(height: 8),
                Text(
                  "E.g., 'Add a skylight above the bed', 'Make the cabinets teal', 'Include a dog bed'.",
                  style: CamperAIText.caption,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _notesController,
                  maxLines: 5,
                  style: CamperAIText.body,
                  onChanged: (val) => widget.controller.setReviewNotes(val),
                  decoration: InputDecoration(
                    hintText: "Type your requests here...",
                    filled: true,
                    fillColor: CamperAIColors.soleBlack.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: CamperAIColors.line),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: CamperAIColors.leatherTan),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => widget.controller.goToStep(1), // Back to Style
                  child: const Text("Edit Style"),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GradientButton(
                  label: "Continue to Preview",
                  onPressed: widget.controller.nextStep,
                  icon: Icons.arrow_forward,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
