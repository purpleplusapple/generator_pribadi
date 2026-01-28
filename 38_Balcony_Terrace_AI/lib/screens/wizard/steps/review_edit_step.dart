// lib/screens/wizard/steps/review_edit_step.dart
// Review step with selections summary and notes input

import 'dart:io';
import 'package:flutter/material.dart';
import '../../../theme/balcony_terrace_ai_theme.dart';
import '../../../widgets/glass_card.dart';
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
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(
      text: widget.controller.reviewNotes ?? '',
    );
    _notesController.addListener(_onNotesChanged);
  }

  @override
  void dispose() {
    _notesController.removeListener(_onNotesChanged);
    _notesController.dispose();
    super.dispose();
  }

  void _onNotesChanged() {
    widget.controller.setReviewNotes(_notesController.text);
  }

  void _jumpToStep(int step) {
    widget.controller.goToStep(step);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final imagePath = widget.controller.selectedImagePath;
        final selections = widget.controller.styleSelections;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(TerraceAISpacing.base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: TerraceAISpacing.lg),

              // Title
              Text(
                'Review Your Choices',
                style: TerraceAIText.h2,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: TerraceAISpacing.sm),

              // Subtitle
              Text(
                'Everything looks good? Let\'s generate your redesign!',
                style: TerraceAIText.body.copyWith(
                  color: TerraceAIColors.canvasWhite.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: TerraceAISpacing.xxl),

              // Original Photo Section
              _buildPhotoSection(imagePath),

              const SizedBox(height: TerraceAISpacing.base),

              // Style Selections Section
              _buildStyleSelectionsSection(selections),

              const SizedBox(height: TerraceAISpacing.base),

              // Notes Section
              _buildNotesSection(),

              const SizedBox(height: TerraceAISpacing.xxl),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPhotoSection(String? imagePath) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Original Photo',
                style: TerraceAIText.h3.copyWith(fontSize: 18),
              ),
              TextButton.icon(
                onPressed: () => _jumpToStep(0),
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: const Text('Change'),
                style: TextButton.styleFrom(
                  foregroundColor: TerraceAIColors.leatherTan,
                ),
              ),
            ],
          ),

          const SizedBox(height: TerraceAISpacing.md),

          if (imagePath != null)
            ClipRRect(
              borderRadius: TerraceAIRadii.chipRadius,
              child: Image.file(
                File(imagePath),
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            )
          else
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: TerraceAIColors.canvasWhite.withValues(alpha: 0.05),
                borderRadius: TerraceAIRadii.chipRadius,
              ),
              child: Center(
                child: Text(
                  'No photo selected',
                  style: TerraceAIText.caption,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStyleSelectionsSection(Map<String, String> selections) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Style Selections',
                style: TerraceAIText.h3.copyWith(fontSize: 18),
              ),
              TextButton.icon(
                onPressed: () => _jumpToStep(1),
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: const Text('Edit'),
                style: TextButton.styleFrom(
                  foregroundColor: TerraceAIColors.leatherTan,
                ),
              ),
            ],
          ),

          const SizedBox(height: TerraceAISpacing.md),

          if (selections.isEmpty)
            Text(
              'No style selections made',
              style: TerraceAIText.caption,
            )
          else
            ...selections.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: TerraceAISpacing.sm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '•  ',
                      style: TerraceAIText.body.copyWith(
                        color: TerraceAIColors.leatherTan,
                      ),
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${entry.key}: ',
                              style: TerraceAIText.bodyMedium.copyWith(
                                color: TerraceAIColors.canvasWhite.withValues(
                                  alpha: 0.7,
                                ),
                              ),
                            ),
                            TextSpan(
                              text: entry.value,
                              style: TerraceAIText.bodyMedium.copyWith(
                                color: TerraceAIColors.canvasWhite,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildNotesSection() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Additional Notes (Optional)',
            style: TerraceAIText.h3.copyWith(fontSize: 18),
          ),

          const SizedBox(height: TerraceAISpacing.sm),

          Text(
            'Add any specific instructions or preferences',
            style: TerraceAIText.caption,
          ),

          const SizedBox(height: TerraceAISpacing.md),

          TextField(
            controller: _notesController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'e.g., "Keep existing appliances", "Add more storage"...',
              hintStyle: TerraceAIText.body.copyWith(
                color: TerraceAIColors.canvasWhite.withValues(alpha: 0.3),
              ),
            ),
            style: TerraceAIText.body,
          ),
        ],
      ),
    );
  }
}
