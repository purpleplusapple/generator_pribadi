import 'package:flutter/material.dart';
import '../../theme/camper_theme.dart';

class WizardRailStepper extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> stepTitles;

  const WizardRailStepper({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.stepTitles,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      color: CamperAIColors.surface,
      child: Column(
        children: [
          const SizedBox(height: 40),
          ...List.generate(totalSteps, (index) => _buildStep(index)),
        ],
      ),
    );
  }

  Widget _buildStep(int index) {
    final isActive = index == currentStep;
    final isCompleted = index < currentStep;

    return Expanded(
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isActive
                  ? CamperAIColors.leatherTan
                  : isCompleted
                      ? CamperAIColors.success
                      : CamperAIColors.laceGray.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, color: CamperAIColors.soleBlack)
                  : Text(
                      "${index + 1}",
                      style: TextStyle(
                        color: isActive
                            ? CamperAIColors.soleBlack
                            : CamperAIColors.canvasWhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          RotatedBox(
            quarterTurns: 3,
            child: Text(
              stepTitles[index],
              style: isActive
                  ? CamperAIText.bodyMedium.copyWith(color: CamperAIColors.leatherTan)
                  : CamperAIText.caption,
            ),
          ),
          if (index < totalSteps - 1)
            Expanded(
              child: Container(
                width: 2,
                color: isCompleted
                    ? CamperAIColors.success
                    : CamperAIColors.laceGray.withOpacity(0.1),
              ),
            ),
        ],
      ),
    );
  }
}
