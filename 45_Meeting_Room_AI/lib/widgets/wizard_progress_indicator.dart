// lib/widgets/wizard_progress_indicator.dart
// Visual step indicator for wizard flow

import 'package:flutter/material.dart';
import '../theme/meeting_room_theme.dart';

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
        horizontal: MeetingAISpacing.base,
        vertical: MeetingAISpacing.sm,
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
                        color: MeetingAIColors.canvasWhite.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    // Progress fill
                    FractionallySizedBox(
                      widthFactor: (currentStep + 1) / totalSteps,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          gradient: MeetingAIGradients.primaryCta,
                          borderRadius: BorderRadius.circular(3),
                          boxShadow: MeetingAIShadows.goldGlow(opacity: 0.4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: MeetingAISpacing.md),
              // Percentage
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: MeetingAISpacing.sm,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  gradient: MeetingAIGradients.accentHighlight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${((currentStep + 1) / totalSteps * 100).toInt()}%',
                  style: MeetingAIText.small.copyWith(
                    color: MeetingAIColors.soleBlack,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: MeetingAISpacing.md),

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
          duration: MeetingAIMotion.standard,
          curve: MeetingAIMotion.emphasizedEasing,
          width: isCurrent ? 36 : 32,
          height: isCurrent ? 36 : 32,
          decoration: BoxDecoration(
            gradient: isCompleted || isCurrent
                ? MeetingAIGradients.primaryCta
                : null,
            color: isCompleted || isCurrent
                ? null
                : MeetingAIColors.canvasWhite.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(
              color: isCurrent
                  ? MeetingAIColors.metallicGold
                  : Colors.transparent,
              width: 2,
            ),
            boxShadow: isCurrent
                ? MeetingAIShadows.goldGlow(opacity: 0.6)
                : null,
          ),
          child: Center(
            child: isCompleted
                ? Icon(
                    Icons.check_rounded,
                    color: MeetingAIColors.soleBlack,
                    size: 18,
                  )
                : Text(
                    '$stepNumber',
                    style: MeetingAIText.small.copyWith(
                      fontSize: 13,
                      color: isCurrent || isCompleted
                          ? MeetingAIColors.soleBlack
                          : MeetingAIColors.canvasWhite.withValues(alpha: 0.5),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),

        if (label.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            label,
            style: MeetingAIText.small.copyWith(
              fontSize: 10,
              color: isCurrent
                  ? MeetingAIColors.canvasWhite
                  : MeetingAIColors.canvasWhite.withValues(alpha: 0.6),
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
