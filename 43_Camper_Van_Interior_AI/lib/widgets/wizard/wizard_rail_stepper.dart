import 'package:flutter/material.dart';
import '../../theme/camper_tokens.dart';

class WizardRailStepper extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> stepLabels;
  final Function(int) onStepTapped;

  const WizardRailStepper({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.stepLabels,
    required this.onStepTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      color: CamperTokens.bg1.withValues(alpha: 0.5),
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: List.generate(totalSteps, (index) {
          final isActive = index == currentStep;
          final isCompleted = index < currentStep;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                // Only allow tapping previous steps or current
                if (index <= currentStep) onStepTapped(index);
              },
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive
                        ? CamperTokens.primary
                        : isCompleted
                          ? CamperTokens.primarySoft
                          : CamperTokens.surface,
                      border: Border.all(
                        color: isActive
                          ? CamperTokens.primary
                          : isCompleted
                            ? CamperTokens.primary
                            : CamperTokens.line,
                      ),
                      boxShadow: isActive ? [
                        BoxShadow(
                          color: CamperTokens.primary.withValues(alpha: 0.4),
                          blurRadius: 8,
                        )
                      ] : null,
                    ),
                    child: Center(
                      child: isCompleted
                        ? const Icon(Icons.check, size: 16, color: CamperTokens.ink1)
                        : Text(
                            "${index + 1}",
                            style: TextStyle(
                              color: isActive ? Colors.black : CamperTokens.muted,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    stepLabels[index],
                    style: TextStyle(
                      fontSize: 10,
                      color: isActive ? CamperTokens.ink0 : CamperTokens.muted,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (index < totalSteps - 1)
                    Expanded(
                      child: Container(
                        width: 2,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        color: isCompleted ? CamperTokens.primary.withValues(alpha: 0.5) : CamperTokens.line,
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
