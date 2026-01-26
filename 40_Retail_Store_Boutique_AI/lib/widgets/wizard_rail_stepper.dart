import 'package:flutter/material.dart';
import 'package:retail_store_boutique_ai/theme/boutique_theme.dart';

class WizardRailStepper extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> stepLabels;

  const WizardRailStepper({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.stepLabels,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      color: BoutiqueColors.surface,
      child: Column(
        children: [
           const SizedBox(height: 16),
           Expanded(
             child: ListView.builder(
               itemCount: totalSteps,
               itemBuilder: (context, index) {
                 final isActive = index == currentStep;
                 final isCompleted = index < currentStep;

                 return Column(
                   children: [
                     _buildStepCircle(index, isActive, isCompleted),
                     if (index < totalSteps - 1)
                       _buildConnector(isCompleted),
                   ],
                 );
               },
             ),
           ),
        ],
      ),
    );
  }

  Widget _buildStepCircle(int index, bool isActive, bool isCompleted) {
    Color color = BoutiqueColors.surface2;
    Color iconColor = BoutiqueColors.ink1.withValues(alpha: 0.3);

    if (isCompleted) {
      color = BoutiqueColors.success;
      iconColor = BoutiqueColors.bg0;
    } else if (isActive) {
      color = BoutiqueColors.primary;
      iconColor = BoutiqueColors.bg0;
    }

    return Container(
      width: 40,
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: isActive ? Border.all(color: BoutiqueColors.primary.withValues(alpha: 0.3), width: 4) : null,
      ),
      child: Center(
        child: isCompleted
           ? Icon(Icons.check, size: 20, color: iconColor)
           : Text("${index + 1}", style: BoutiqueText.bodySemiBold.copyWith(color: iconColor)),
      ),
    );
  }

  Widget _buildConnector(bool isCompleted) {
    return Container(
      width: 2,
      height: 24,
      color: isCompleted ? BoutiqueColors.success.withValues(alpha: 0.5) : BoutiqueColors.line,
    );
  }
}
