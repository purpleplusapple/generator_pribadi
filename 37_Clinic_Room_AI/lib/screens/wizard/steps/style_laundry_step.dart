import 'package:flutter/material.dart';
import '../../../theme/clinic_theme.dart';
import '../../../widgets/clinical_card.dart';
import '../wizard_controller.dart';

class StyleLaundryStep extends StatelessWidget {
  const StyleLaundryStep({super.key, required this.controller});
  final WizardController controller;

  static const Map<String, List<String>> _options = {
    'Clinical Vibe': [
      'Minimal Sterile',
      'Warm Reassuring',
      'Premium Boutique',
      'Kids Friendly',
      'Modern Tech',
    ],
    'Room Function': [
      'Exam Room',
      'Waiting Area',
      'Dental Suite',
      'Physiotherapy',
      'Lab Corner',
      'Consultation Office',
    ],
    'Lighting Mood': [
      'Bright Cool (Medical)',
      'Natural Warm',
      'Soft Ambient',
      'Focused Task',
    ],
  };

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(ClinicSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Design Direction',
                style: ClinicText.h2,
              ),
              const SizedBox(height: 8),
              Text(
                'Select the intended function and aesthetic for your clinic space.',
                style: ClinicText.body.copyWith(color: ClinicColors.ink2),
              ),
              const SizedBox(height: ClinicSpacing.xl),

              ..._options.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: ClinicSpacing.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(entry.key, style: ClinicText.h3.copyWith(fontSize: 16)),
                      const SizedBox(height: ClinicSpacing.md),
                      Wrap(
                        spacing: 8,
                        runSpacing: 12,
                        children: entry.value.map((option) {
                          final isSelected = controller.styleSelections[entry.key] == option;
                          return ChoiceChip(
                            label: Text(option),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                controller.setStyleSelection(entry.key, option);
                              } else {
                                // Optional: Allow deselect? The controller logic might need it.
                                // For now we assume toggle behavior if controller supports it,
                                // or just allow selection.
                                controller.removeStyleSelection(entry.key);
                              }
                            },
                            selectedColor: ClinicColors.primarySoft,
                            backgroundColor: Colors.white,
                            labelStyle: ClinicText.small.copyWith(
                              color: isSelected ? ClinicColors.primary : ClinicColors.ink1,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                            side: BorderSide(
                              color: isSelected ? ClinicColors.primary : ClinicColors.line,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: ClinicRadius.mediumRadius,
                            ),
                            showCheckmark: false,
                            avatar: isSelected
                                ? Icon(Icons.check, size: 16, color: ClinicColors.primary)
                                : null,
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
