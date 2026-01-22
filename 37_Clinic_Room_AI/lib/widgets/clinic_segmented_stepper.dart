import 'package:flutter/material.dart';
import '../theme/clinic_theme.dart';

class ClinicSegmentedStepper extends StatelessWidget {
  const ClinicSegmentedStepper({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.stepLabels,
  });

  final int currentStep;
  final int totalSteps;
  final List<String> stepLabels;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: ClinicSpacing.base),
      child: Column(
        children: [
          // Labels Row
          Row(
            children: List.generate(totalSteps, (index) {
              final isSelected = index == currentStep;
              final isCompleted = index < currentStep;

              return Expanded(
                child: Center(
                  child: Text(
                    stepLabels[index],
                    style: isSelected
                        ? ClinicText.captionMedium.copyWith(color: ClinicColors.primary, fontWeight: FontWeight.bold)
                        : isCompleted
                            ? ClinicText.caption.copyWith(color: ClinicColors.ink1)
                            : ClinicText.caption.copyWith(color: ClinicColors.ink2.withValues(alpha: 0.5)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          // Progress Line
          Stack(
            children: [
              // Background Line
              Container(
                height: 4,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ClinicColors.line,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Active Indicator
              AnimatedFractionallySizedBox(
                duration: ClinicMotion.standard,
                curve: ClinicMotion.emphasizedEasing,
                widthFactor: (currentStep + 1) / totalSteps,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: ClinicColors.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
