import 'package:flutter/material.dart';
import '../theme/terrace_theme.dart';

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
      color: TerraceAIColors.surface.withValues(alpha: 0.3),
      child: Column(
        children: [
          const SizedBox(height: TerraceAISpacing.xl),
          // Back Button / Exit
          IconButton(
            icon: const Icon(Icons.close_rounded),
            color: TerraceAIColors.muted,
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          const SizedBox(height: TerraceAISpacing.xxl),

          // Steps
          Expanded(
            child: ListView.separated(
              itemCount: totalSteps,
              separatorBuilder: (_, __) => const SizedBox(height: 32),
              itemBuilder: (context, index) {
                return _buildStepIcon(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIcon(int index) {
    final isCurrent = index == currentStep;
    final isCompleted = index < currentStep;

    return GestureDetector(
      onTap: isCompleted ? () => onStepTapped(index) : null,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCurrent
                  ? TerraceAIColors.primary
                  : isCompleted
                      ? TerraceAIColors.primarySoft
                      : Colors.transparent,
              border: Border.all(
                color: isCurrent
                    ? TerraceAIColors.primary
                    : isCompleted
                        ? TerraceAIColors.primary
                        : TerraceAIColors.line,
                width: 2,
              ),
              boxShadow: isCurrent ? TerraceAIShadows.emeraldGlow() : null,
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, color: TerraceAIColors.bg0, size: 20)
                  : Text(
                      '${index + 1}',
                      style: TerraceAIText.bodyMedium.copyWith(
                        color: isCurrent
                            ? TerraceAIColors.bg0
                            : TerraceAIColors.muted,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            stepLabels[index],
            style: TerraceAIText.small.copyWith(
              fontSize: 10,
              color: isCurrent ? TerraceAIColors.ink0 : TerraceAIColors.muted,
              fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
