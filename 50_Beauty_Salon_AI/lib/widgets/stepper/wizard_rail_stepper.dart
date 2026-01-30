import 'package:flutter/material.dart';
import '../../theme/beauty_theme.dart';
import '../../theme/beauty_tokens.dart';

class WizardRailStepper extends StatelessWidget {
  final int currentStep;
  final List<String> steps;

  const WizardRailStepper({
    super.key,
    required this.currentStep,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      color: BeautyTheme.bg0,
      child: Column(
        children: [
          const SizedBox(height: 60), // SafeArea padding
          Expanded(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: steps.length,
              itemBuilder: (context, index) {
                final isActive = index == currentStep;
                final isCompleted = index < currentStep;

                return _RailStep(
                  index: index + 1,
                  label: steps[index],
                  isActive: isActive,
                  isCompleted: isCompleted,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RailStep extends StatelessWidget {
  final int index;
  final String label;
  final bool isActive;
  final bool isCompleted;

  const _RailStep({
    required this.index,
    required this.label,
    required this.isActive,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isActive
                  ? BeautyTheme.primary
                  : isCompleted ? BeautyTheme.success : Colors.transparent,
              border: Border.all(
                color: isActive || isCompleted ? Colors.transparent : BeautyTheme.line,
                width: 2,
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : Text(
                      '$index',
                      style: TextStyle(
                        color: isActive ? Colors.white : BeautyTheme.muted,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive ? BeautyTheme.ink0 : BeautyTheme.muted,
            ),
          ),
          if (isActive)
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 2,
              height: 24,
              color: BeautyTheme.primary.withOpacity(0.3),
            ),
        ],
      ),
    );
  }
}
