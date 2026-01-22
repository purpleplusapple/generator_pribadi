import 'package:flutter/material.dart';
import '../theme/beauty_salon_ai_theme.dart';

class SegmentedWizardStepper extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> steps;

  const SegmentedWizardStepper({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: BeautyAISpacing.lg),
      margin: const EdgeInsets.only(bottom: BeautyAISpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step ${currentStep + 1} of $totalSteps',
            style: BeautyAIText.caption.copyWith(letterSpacing: 1.0),
          ),
          const SizedBox(height: 4),
          Text(
            steps[currentStep],
            style: BeautyAIText.h2,
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(totalSteps, (index) {
              final isActive = index <= currentStep;
              final isCurrent = index == currentStep;
              return Expanded(
                child: AnimatedContainer(
                  duration: BeautyAIMotion.standard,
                  height: 4,
                  margin: EdgeInsets.only(right: index < totalSteps - 1 ? 4 : 0),
                  decoration: BoxDecoration(
                    color: isActive ? BeautyAIColors.primary : BeautyAIColors.line,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: isCurrent
                      ? [BoxShadow(color: BeautyAIColors.primary.withValues(alpha: 0.3), blurRadius: 4, offset: const Offset(0, 2))]
                      : null,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
