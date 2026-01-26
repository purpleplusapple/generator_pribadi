// lib/screens/wizard/steps/review_edit_step.dart
// Review step with selections summary and notes input

import 'dart:io';
import 'package:flutter/material.dart';
import '../../../theme/boutique_theme.dart';
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
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Review & Notes", style: BoutiqueText.h2),
              const SizedBox(height: 24),

              _buildPhotoSection(imagePath),
              const SizedBox(height: 16),
              _buildStyleSection(selections),
              const SizedBox(height: 16),
              _buildNotesSection(),
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
              Text("Boutique Snapshot", style: BoutiqueText.h3),
              TextButton(
                onPressed: () => _jumpToStep(0),
                child: const Text("Edit"),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (imagePath != null)
             ClipRRect(
               borderRadius: BorderRadius.circular(16),
               child: Image.file(File(imagePath), height: 180, width: double.infinity, fit: BoxFit.cover),
             )
          else
            Text("No photo selected", style: BoutiqueText.caption),
        ],
      ),
    );
  }

  Widget _buildStyleSection(Map<String, String> selections) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Design Vibe", style: BoutiqueText.h3),
              TextButton(
                onPressed: () => _jumpToStep(1),
                child: const Text("Edit"),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (selections.isEmpty)
             Text("No vibe selected", style: BoutiqueText.caption)
          else
             ...selections.entries.map((e) => Padding(
               padding: const EdgeInsets.only(bottom: 8),
               child: Row(
                 children: [
                   Container(
                     padding: const EdgeInsets.all(4),
                     decoration: const BoxDecoration(color: BoutiqueColors.primary, shape: BoxShape.circle),
                   ),
                   const SizedBox(width: 8),
                   Text(e.key, style: BoutiqueText.bodyMedium.copyWith(color: BoutiqueColors.muted)),
                   const SizedBox(width: 8),
                   Text(e.value, style: BoutiqueText.bodyMedium.copyWith(color: BoutiqueColors.ink0)),
                 ],
               ),
             )),
        ],
      ),
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Design Instructions", style: BoutiqueText.h3),
        const SizedBox(height: 8),
        TextField(
          controller: _notesController,
          maxLines: 4,
          style: BoutiqueText.body,
          decoration: const InputDecoration(
            hintText: "E.g. Focus on lighting for jewelry displays...",
          ),
        ),
      ],
    );
  }
}
