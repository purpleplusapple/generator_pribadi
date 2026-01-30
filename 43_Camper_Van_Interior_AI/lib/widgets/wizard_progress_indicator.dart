// lib/widgets/wizard_progress_indicator.dart
// Visual step indicator for wizard flow

import 'package:flutter/material.dart';
import '../theme/camper_van_ai_theme.dart';

class WizardProgressIndicator extends StatelessWidget {
  const WizardProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.stepLabels = const [],
  });

  final int currentStep;
  final int totalSteps;
  final List<String> stepLabels;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: CamperAISpacing.base,
        vertical: CamperAISpacing.sm,
      ),
      child: Column(
        children: [
          // Progress bar with percentage
          Row(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    // Background track
                    Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: CamperAIColors.canvasWhite.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    // Progress fill
                    FractionallySizedBox(
                      widthFactor: (currentStep + 1) / totalSteps,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          gradient: CamperAIGradients.primaryCta,
                          borderRadius: BorderRadius.circular(3),
                          boxShadow: CamperAIShadows.goldGlow(opacity: 0.4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: CamperAISpacing.md),
              // Percentage
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: CamperAISpacing.sm,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  gradient: CamperAIGradients.accentHighlight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${((currentStep + 1) / totalSteps * 100).toInt()}%',
                  style: CamperAIText.small.copyWith(
                    color: CamperAIColors.soleBlack,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: CamperAISpacing.md),

          // Step circles with labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(totalSteps, (index) {
              final isCompleted = index < currentStep;
              final isCurrent = index == currentStep;
              final label = index < stepLabels.length ? stepLabels[index] : '';

              return Expanded(
                child: _buildStepCircle(
                  index + 1,
                  label,
                  isCompleted: isCompleted,
                  isCurrent: isCurrent,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCircle(int stepNumber, String label, {
    required bool isCompleted,
    required bool isCurrent,
  }) {
    return Column(
      children: [
        // Circle with number/check
        AnimatedContainer(
          duration: CamperAIMotion.standard,
          curve: CamperAIMotion.emphasizedEasing,
          width: isCurrent ? 36 : 32,
          height: isCurrent ? 36 : 32,
          decoration: BoxDecoration(
            gradient: isCompleted || isCurrent
                ? CamperAIGradients.primaryCta
                : null,
            color: isCompleted || isCurrent
                ? null
                : CamperAIColors.canvasWhite.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(
              color: isCurrent
                  ? CamperAIColors.metallicGold
                  : Colors.transparent,
              width: 2,
            ),
            boxShadow: isCurrent
                ? CamperAIShadows.goldGlow(opacity: 0.6)
                : null,
          ),
          child: Center(
            child: isCompleted
                ? Icon(
                    Icons.check_rounded,
                    color: CamperAIColors.soleBlack,
                    size: 18,
                  )
                : Text(
                    '$stepNumber',
                    style: CamperAIText.small.copyWith(
                      fontSize: 13,
                      color: isCurrent || isCompleted
                          ? CamperAIColors.soleBlack
                          : CamperAIColors.canvasWhite.withValues(alpha: 0.5),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),

        if (label.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            label,
            style: CamperAIText.small.copyWith(
              fontSize: 10,
              color: isCurrent
                  ? CamperAIColors.canvasWhite
                  : CamperAIColors.canvasWhite.withValues(alpha: 0.6),
              fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}
