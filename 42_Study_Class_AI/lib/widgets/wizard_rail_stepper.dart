import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class WizardRailStepper extends StatelessWidget {
  final int currentStep;
  final Function(int) onStepTapped;

  const WizardRailStepper({
    super.key,
    required this.currentStep,
    required this.onStepTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      color: StudyAIColors.bg1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStep(0, Icons.upload_file, 'Upload'),
          _buildDivider(0),
          _buildStep(1, Icons.style, 'Style'),
          _buildDivider(1),
          _buildStep(2, Icons.auto_awesome, 'Result'),
        ],
      ),
    );
  }

  Widget _buildStep(int step, IconData icon, String label) {
    final isActive = step == currentStep;
    final isCompleted = step < currentStep;

    return GestureDetector(
      onTap: () => onStepTapped(step),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isActive ? StudyAIColors.primary : (isCompleted ? StudyAIColors.success : StudyAIColors.surface),
                shape: BoxShape.circle,
                boxShadow: isActive ? [
                  BoxShadow(
                    color: StudyAIColors.primary.withValues(alpha: 0.4),
                    blurRadius: 12,
                  )
                ] : [],
              ),
              child: Icon(
                isCompleted ? Icons.check : icon,
                color: isActive ? StudyAIColors.bg0 : StudyAIColors.muted,
                size: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isActive ? StudyAIColors.primary : StudyAIColors.muted,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(int step) {
    final isCompleted = step < currentStep;
    return Container(
      width: 2,
      height: 30,
      color: isCompleted ? StudyAIColors.success : StudyAIColors.line,
    );
  }
}
