import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

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
      width: 72,
      color: DesignTokens.bg1.withOpacity(0.5),
      child: Column(
        children: [
          const SizedBox(height: 16),
          IconButton(
            icon: const Icon(Icons.close, color: DesignTokens.ink1),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              itemCount: totalSteps,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (_, __) => _buildConnector(),
              itemBuilder: (context, index) {
                return _buildStepItem(context, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnector() {
    return Center(
      child: Container(
        width: 1,
        height: 24,
        color: DesignTokens.line.withOpacity(0.5),
        margin: const EdgeInsets.symmetric(vertical: 2),
      ),
    );
  }

  Widget _buildStepItem(BuildContext context, int index) {
    final isSelected = index == currentStep;
    final isCompleted = index < currentStep;

    return GestureDetector(
      onTap: () {
        if (isCompleted) onStepTapped(index);
      },
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isSelected ? DesignTokens.primary : (isCompleted ? DesignTokens.surface : Colors.transparent),
              border: Border.all(
                color: isSelected ? DesignTokens.primary : (isCompleted ? DesignTokens.primary : DesignTokens.line.withOpacity(0.5)),
              ),
              shape: BoxShape.circle,
              boxShadow: isSelected ? [
                BoxShadow(color: DesignTokens.primary.withOpacity(0.4), blurRadius: 12)
              ] : null,
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, color: DesignTokens.ink0, size: 20)
                  : Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: isSelected ? DesignTokens.bg0 : DesignTokens.ink1,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            stepLabels[index],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 9,
              color: isSelected ? DesignTokens.primary : DesignTokens.ink1.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
