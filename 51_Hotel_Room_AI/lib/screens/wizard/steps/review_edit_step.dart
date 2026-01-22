// lib/screens/wizard/steps/review_edit_step.dart
// Review step
// Option A: Boutique Linen

import 'dart:io';
import 'package:flutter/material.dart';
import '../../../theme/hotel_room_ai_theme.dart';
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

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final imagePath = widget.controller.selectedImagePath;
        final selections = widget.controller.styleSelections;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(HotelAISpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Review Config", style: HotelAIText.h2),
              const SizedBox(height: 8),
              Text(
                "Confirm details before we start the design engine.",
                style: HotelAIText.body.copyWith(color: HotelAIColors.muted),
              ),
              const SizedBox(height: 24),

              // 1. Photo
              _SectionCard(
                title: "Room Photo",
                onEdit: () => widget.controller.goToStep(0),
                child: imagePath != null
                    ? ClipRRect(
                        borderRadius: HotelAIRadii.mediumRadius,
                        child: Image.file(File(imagePath), height: 180, width: double.infinity, fit: BoxFit.cover),
                      )
                    : const Text("No photo selected"),
              ),

              const SizedBox(height: 16),

              // 2. Styles
              _SectionCard(
                title: "Aesthetic",
                onEdit: () => widget.controller.goToStep(1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: selections.entries.map((e) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Icon(Icons.check, size: 16, color: HotelAIColors.primary),
                          const SizedBox(width: 8),
                          Text("${e.key}: ", style: TextStyle(color: HotelAIColors.muted)),
                          Text(e.value, style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 16),

              // 3. Notes
              _SectionCard(
                title: "Designer Notes",
                child: TextField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "E.g. keep the flooring, brighten the lights...",
                    border: OutlineInputBorder(
                      borderRadius: HotelAIRadii.mediumRadius,
                      borderSide: BorderSide(color: HotelAIColors.line),
                    ),
                    filled: true,
                    fillColor: HotelAIColors.bg0,
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback? onEdit;

  const _SectionCard({required this.title, required this.child, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HotelAIColors.bg1,
        borderRadius: HotelAIRadii.mediumRadius,
        boxShadow: HotelAIShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: HotelAIText.h3),
              if (onEdit != null)
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 20, color: HotelAIColors.primary),
                  onPressed: onEdit,
                ),
            ],
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
