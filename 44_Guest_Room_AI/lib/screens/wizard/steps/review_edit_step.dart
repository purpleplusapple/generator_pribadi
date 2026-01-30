// lib/screens/wizard/steps/review_edit_step.dart
// Review step with selections summary and notes input

import 'dart:io';
import 'package:flutter/material.dart';
import '../../../theme/guest_room_ai_theme.dart';
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
          padding: const EdgeInsets.all(GuestAISpacing.base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: GuestAISpacing.lg),

              // Title
              Text(
                'Review Your Choices',
                style: GuestAIText.h2,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: GuestAISpacing.sm),

              // Subtitle
              Text(
                'Everything looks good? Let\'s generate your redesign!',
                style: GuestAIText.body.copyWith(
                  color: GuestAIColors.canvasWhite.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: GuestAISpacing.xxl),

              // Original Photo Section
              _buildPhotoSection(imagePath),

              const SizedBox(height: GuestAISpacing.base),

              // Style Selections Section
              _buildStyleSelectionsSection(selections),

              const SizedBox(height: GuestAISpacing.base),

              // Notes Section
              _buildNotesSection(),

              const SizedBox(height: GuestAISpacing.xxl),
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
                style: GuestAIText.h3.copyWith(fontSize: 18),
              ),
              TextButton.icon(
                onPressed: () => _jumpToStep(0),
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: const Text('Change'),
                style: TextButton.styleFrom(
                  foregroundColor: GuestAIColors.leatherTan,
                ),
              ),
            ],
          ),

          const SizedBox(height: GuestAISpacing.md),

          if (imagePath != null)
            ClipRRect(
              borderRadius: GuestAIRadii.chipRadius,
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
                color: GuestAIColors.canvasWhite.withValues(alpha: 0.05),
                borderRadius: GuestAIRadii.chipRadius,
              ),
              child: Center(
                child: Text(
                  'No photo selected',
                  style: GuestAIText.caption,
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
                style: GuestAIText.h3.copyWith(fontSize: 18),
              ),
              TextButton.icon(
                onPressed: () => _jumpToStep(1),
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: const Text('Edit'),
                style: TextButton.styleFrom(
                  foregroundColor: GuestAIColors.leatherTan,
                ),
              ),
            ],
          ),

          const SizedBox(height: GuestAISpacing.md),

          if (selections.isEmpty)
            Text(
              'No style selections made',
              style: GuestAIText.caption,
            )
          else
            ...selections.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: GuestAISpacing.sm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '•  ',
                      style: GuestAIText.body.copyWith(
                        color: GuestAIColors.leatherTan,
                      ),
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${entry.key}: ',
                              style: GuestAIText.bodyMedium.copyWith(
                                color: GuestAIColors.canvasWhite.withValues(
                                  alpha: 0.7,
                                ),
                              ),
                            ),
                            TextSpan(
                              text: entry.value,
                              style: GuestAIText.bodyMedium.copyWith(
                                color: GuestAIColors.canvasWhite,
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
            style: GuestAIText.h3.copyWith(fontSize: 18),
          ),

          const SizedBox(height: GuestAISpacing.sm),

          Text(
            'Add any specific instructions or preferences',
            style: GuestAIText.caption,
          ),

          const SizedBox(height: GuestAISpacing.md),

          TextField(
            controller: _notesController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'e.g., "Keep existing appliances", "Add more storage"...',
              hintStyle: GuestAIText.body.copyWith(
                color: GuestAIColors.canvasWhite.withValues(alpha: 0.3),
              ),
            ),
            style: GuestAIText.body,
          ),
        ],
      ),
    );
  }
}
