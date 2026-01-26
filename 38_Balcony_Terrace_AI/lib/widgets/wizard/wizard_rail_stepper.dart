import 'package:flutter/material.dart';
import '../../theme/design_tokens.dart';

class WizardRailStepper extends StatelessWidget {
  final int currentStep;
  final List<String> steps;
  final Function(int) onStepTapped;

  const WizardRailStepper({
    super.key,
    required this.currentStep,
    required this.steps,
    required this.onStepTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      color: DesignTokens.bg1,
      child: Column(
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: steps.length,
              separatorBuilder: (context, index) => _StepConnector(
                isActive: index < currentStep,
              ),
              itemBuilder: (context, index) {
                return _StepItem(
                  index: index,
                  label: steps[index],
                  isActive: index <= currentStep,
                  isCompleted: index < currentStep,
                  onTap: () => onStepTapped(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final int index;
  final String label;
  final bool isActive;
  final bool isCompleted;
  final VoidCallback onTap;

  const _StepItem({
    required this.index,
    required this.label,
    required this.isActive,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color circleColor = DesignTokens.surface2;
    Color textColor = DesignTokens.muted;
    Color borderColor = DesignTokens.line;

    if (isCompleted) {
      circleColor = DesignTokens.primary;
      textColor = DesignTokens.primary;
      borderColor = DesignTokens.primary;
    } else if (isActive) {
      circleColor = DesignTokens.bg0;
      textColor = DesignTokens.ink0;
      borderColor = DesignTokens.accent;
    }

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: circleColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: borderColor,
                width: 2,
              ),
              boxShadow: isActive && !isCompleted ? DesignTokens.shadowGlowAmber : [],
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, size: 16, color: DesignTokens.bg0)
                  : Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: isActive && !isCompleted ? DesignTokens.ink0 : DesignTokens.muted,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _StepConnector extends StatelessWidget {
  final bool isActive;

  const _StepConnector({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Center(
        child: Container(
          width: 2,
          color: isActive ? DesignTokens.primary : DesignTokens.line,
        ),
      ),
    );
  }
}
