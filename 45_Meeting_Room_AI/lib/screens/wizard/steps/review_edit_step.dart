// lib/screens/wizard/steps/review_edit_step.dart
// Review step with selections summary and notes input

import 'dart:io';
import 'package:flutter/material.dart';
import '../../../theme/meeting_room_theme.dart';
import '../../../theme/meeting_tokens.dart';
import '../../../widgets/glass_card.dart';
import '../../../data/meeting_style_repository.dart';
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
        final selection = widget.controller.styleSelection;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Text(
                'FINAL BRIEF CHECK',
                style: MeetingRoomText.h3.copyWith(letterSpacing: 1),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Photo
              _buildPhotoSection(imagePath),
              const SizedBox(height: 16),

              // Style
              _buildStyleSection(selection),
              const SizedBox(height: 16),

              // Notes
              _buildNotesSection(),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPhotoSection(String? imagePath) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MeetingTokens.surface,
        borderRadius: BorderRadius.circular(MeetingTokens.radiusLG),
        border: Border.all(color: MeetingTokens.line),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('SOURCE ROOM', style: MeetingRoomText.caption),
              GestureDetector(
                onTap: () => _jumpToStep(0),
                child: Text('CHANGE', style: TextStyle(color: MeetingTokens.accent, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (imagePath != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(MeetingTokens.radiusMD),
              child: Image.file(File(imagePath), height: 180, width: double.infinity, fit: BoxFit.cover),
            )
          else
            Container(height: 180, color: MeetingTokens.bg1, child: const Center(child: Text('No Image'))),
        ],
      ),
    );
  }

  Widget _buildStyleSection(dynamic selection) {
    if (selection == null) return const SizedBox.shrink();

    final styleId = selection.styleId;
    final style = MeetingStyleRepository.getById(styleId);
    final controls = selection.controlValues as Map<String, dynamic>;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MeetingTokens.surface,
        borderRadius: BorderRadius.circular(MeetingTokens.radiusLG),
        border: Border.all(color: MeetingTokens.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('STYLE CONFIGURATION', style: MeetingRoomText.caption),
              GestureDetector(
                onTap: () => _jumpToStep(1),
                child: Text('EDIT', style: TextStyle(color: MeetingTokens.accent, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(style.name.toUpperCase(), style: MeetingRoomText.h3),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: controls.entries.map((e) {
               if (e.key == 'note' || e.key == 'custom_prompt' || e.key == 'negative_prompt') return const SizedBox.shrink();
               return Container(
                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                 decoration: BoxDecoration(
                   color: MeetingTokens.bg1,
                   borderRadius: BorderRadius.circular(8),
                   border: Border.all(color: MeetingTokens.line),
                 ),
                 child: Text(
                   '${e.key}: ${e.value}',
                   style: MeetingRoomText.small.copyWith(color: MeetingTokens.muted),
                 ),
               );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ADDITIONAL INSTRUCTIONS', style: MeetingRoomText.caption),
        const SizedBox(height: 8),
        TextField(
          controller: _notesController,
          maxLines: 3,
          style: MeetingRoomText.body,
          decoration: InputDecoration(
            hintText: 'E.g., Keep the windows, remove ceiling fan...',
            filled: true,
            fillColor: MeetingTokens.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(MeetingTokens.radiusMD),
              borderSide: BorderSide(color: MeetingTokens.line),
            ),
          ),
        ),
      ],
    );
  }
}
