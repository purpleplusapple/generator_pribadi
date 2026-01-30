import 'package:flutter/material.dart';
import '../../theme/storage_theme.dart';

class WizardRailStepper extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> stepNames;

  const WizardRailStepper({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.stepNames,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      color: StorageColors.bg1,
      child: Column(
        children: [
          const SizedBox(height: 60),
          Expanded(
            child: ListView.builder(
              itemCount: totalSteps,
              itemBuilder: (context, index) {
                final isActive = index == currentStep;
                final isCompleted = index < currentStep;

                return Column(
                  children: [
                    // Dot
                    Container(
                      width: isActive ? 24 : 16,
                      height: isActive ? 24 : 16,
                      decoration: BoxDecoration(
                        color: isActive
                            ? StorageColors.primaryLime
                            : (isCompleted ? StorageColors.success : StorageColors.surface2),
                        shape: BoxShape.circle,
                        border: isActive
                            ? Border.all(color: StorageColors.primaryLime.withValues(alpha: 0.3), width: 4)
                            : null,
                      ),
                      child: isCompleted
                          ? const Icon(Icons.check, size: 10, color: Colors.black)
                          : null,
                    ),

                    // Line
                    if (index < totalSteps - 1)
                      Container(
                        width: 2,
                        height: 40,
                        color: isCompleted ? StorageColors.success : StorageColors.line,
                      ),

                    // Label (Vertical rotated or icon)
                    // For rail, we usually just show icons or keep it minimal
                  ],
                );
              },
            ),
          ),

          // Current Step Name Rotated
          RotatedBox(
            quarterTurns: 3,
            child: Text(
              stepNames[currentStep].toUpperCase(),
              style: TextStyle(
                color: StorageColors.muted,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
