import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/moodboard_style_grid.dart';
import '../../widgets/style_control_sheet.dart';
import '../../data/study_styles_data.dart';
import '../../model/study_style.dart';
import '../wizard_controller.dart';

class StyleStep extends StatelessWidget {
  final WizardController controller;

  const StyleStep({super.key, required this.controller});

  void _showControlSheet(BuildContext context, StudyStyle style) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StyleControlSheet(
        style: style,
        initialValues: controller.config.controlValues,
        onApply: (values) {
          controller.setStyle(style.id, values);
          controller.nextStep(); // Move to result after applying
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select Style', style: StudyAIText.h2),
              Text(
                'Choose a vibe to customize.',
                style: StudyAIText.bodyMedium.copyWith(color: StudyAIColors.muted),
              ),
            ],
          ),
        ),
        Expanded(
          child: MoodboardStyleGrid(
            styles: studyStyles,
            selectedStyleId: controller.selectedStyleId,
            onStyleSelected: (style) => _showControlSheet(context, style),
          ),
        ),
      ],
    );
  }
}
