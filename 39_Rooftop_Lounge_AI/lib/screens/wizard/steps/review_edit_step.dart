import 'dart:io';
import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
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
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Review Project',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontFamily: 'DM Serif Display', color: DesignTokens.ink0),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Ready to transform your rooftop?',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: DesignTokens.ink1),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              _buildPhotoSection(imagePath),
              const SizedBox(height: 16),
              _buildStyleSelectionsSection(selections),
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
              Text('Original Scene', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: DesignTokens.ink0)),
              TextButton.icon(
                onPressed: () => _jumpToStep(0),
                icon: const Icon(Icons.edit, size: 16, color: DesignTokens.primary),
                label: const Text('Change', style: TextStyle(color: DesignTokens.primary)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (imagePath != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(DesignTokens.radiusM),
              child: Image.file(
                File(imagePath),
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            )
          else
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: DesignTokens.bg1,
                borderRadius: BorderRadius.circular(DesignTokens.radiusM),
              ),
              child: const Center(child: Text('No photo selected', style: TextStyle(color: DesignTokens.ink1))),
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
               Text('Design Vibe', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: DesignTokens.ink0)),
               TextButton.icon(
                onPressed: () => _jumpToStep(1),
                icon: const Icon(Icons.edit, size: 16, color: DesignTokens.primary),
                label: const Text('Edit', style: TextStyle(color: DesignTokens.primary)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (selections.isEmpty)
             const Text('No selections made', style: TextStyle(color: DesignTokens.ink1))
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: selections.entries.map((entry) {
                return Chip(
                  backgroundColor: DesignTokens.surface,
                  label: Text('${entry.key}: ${entry.value}', style: const TextStyle(color: DesignTokens.ink0, fontSize: 12)),
                  side: BorderSide(color: DesignTokens.line.withOpacity(0.5)),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildNotesSection() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Notes (Optional)', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: DesignTokens.ink0)),
          const SizedBox(height: 12),
          TextField(
            controller: _notesController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Add details (e.g. "Add a fire pit")',
              hintStyle: TextStyle(color: DesignTokens.ink1.withOpacity(0.5)),
              filled: true,
              fillColor: DesignTokens.bg0,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
            style: const TextStyle(color: DesignTokens.ink0),
          ),
        ],
      ),
    );
  }
}
