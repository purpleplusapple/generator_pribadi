import 'package:flutter/material.dart';
import '../../theme/terrace_theme.dart';

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
      width: 70,
      color: TerraceColors.bg0,
      child: Column(
        children: [
          const SizedBox(height: TerraceSpacing.xl),
          // Back button area usually here, but handled by Scaffold app bar or custom back
          Expanded(
            child: ListView.separated(
              itemCount: steps.length,
              separatorBuilder: (_, __) => _StepConnector(isActive: false), // Connector logic inside builder better
              itemBuilder: (context, index) {
                final bool isActive = index == currentStep;
                final bool isCompleted = index < currentStep;

                return Column(
                  children: [
                    if (index > 0)
                      _StepConnector(isActive: index <= currentStep),
                    _StepItem(
                      index: index + 1,
                      label: steps[index],
                      isActive: isActive,
                      isCompleted: isCompleted,
                    ),
                  ],
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

  const _StepItem({
    required this.index,
    required this.label,
    required this.isActive,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    Color color = TerraceColors.laceGray.withValues(alpha: 0.3);
    if (isActive) color = TerraceColors.metallicGold;
    if (isCompleted) color = TerraceColors.success;

    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? TerraceColors.metallicGold.withValues(alpha: 0.2) : Colors.transparent,
            border: Border.all(
              color: color,
              width: 2,
            ),
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, size: 16, color: TerraceColors.success)
                : Text(
                    '$index',
                    style: TextStyle(
                      color: isActive ? TerraceColors.metallicGold : TerraceColors.laceGray,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isActive ? TerraceColors.canvasWhite : TerraceColors.laceGray,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _StepConnector extends StatelessWidget {
  final bool isActive;

  const _StepConnector({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 2,
      height: 20,
      color: isActive ? TerraceColors.success : TerraceColors.laceGray.withValues(alpha: 0.2),
      margin: const EdgeInsets.symmetric(vertical: 4),
    );
  }
}
