import 'package:flutter/material.dart';
import 'dart:io';
import '../../../theme/clinic_theme.dart';
import '../../../widgets/clinical_card.dart';
import '../wizard_controller.dart';

class ReviewEditStep extends StatefulWidget {
  const ReviewEditStep({super.key, required this.controller});
  final WizardController controller;

  @override
  State<ReviewEditStep> createState() => _ReviewEditStepState();
}

class _ReviewEditStepState extends State<ReviewEditStep> {
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _notesController.text = widget.controller.reviewNotes ?? '';
    _notesController.addListener(() {
      widget.controller.setReviewNotes(_notesController.text);
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(ClinicSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Review & Generate', style: ClinicText.h2),
          const SizedBox(height: ClinicSpacing.base),

          if (widget.controller.selectedImagePath != null)
            _buildImagePreview(),

          const SizedBox(height: ClinicSpacing.lg),

          _buildSummarySection(),

          const SizedBox(height: ClinicSpacing.lg),

          Text('Additional Requirements', style: ClinicText.h3),
          const SizedBox(height: ClinicSpacing.sm),
          TextField(
            controller: _notesController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'E.g., "Add a sink in the corner", "Use warm lighting"',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: ClinicRadius.mediumRadius,
          child: Image.file(
            File(widget.controller.selectedImagePath!),
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: ClinicRadius.smallRadius,
              boxShadow: ClinicShadows.card,
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, size: 16, color: ClinicColors.success),
                const SizedBox(width: 4),
                Text('Image Ready', style: ClinicText.small),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummarySection() {
    return ClinicalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Design Configuration', style: ClinicText.h3),
          const SizedBox(height: ClinicSpacing.md),
          ...widget.controller.styleSelections.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Icon(Icons.arrow_right, color: ClinicColors.primary),
                  Text('${entry.key}: ', style: ClinicText.bodySemiBold),
                  Text(entry.value, style: ClinicText.body),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
