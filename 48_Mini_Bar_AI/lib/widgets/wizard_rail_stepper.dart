// lib/widgets/wizard_rail_stepper.dart
import 'package:flutter/material.dart';
import '../theme/mini_bar_theme.dart';
import '../theme/design_tokens.dart';

class WizardRailStepper extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const WizardRailStepper({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      color: MiniBarColors.surface,
      child: Column(
        children: [
          const SizedBox(height: 24),
          ...List.generate(totalSteps, (index) {
             bool isActive = index == currentStep;
             bool isCompleted = index < currentStep;

             return Expanded(
               child: Column(
                 children: [
                   // Connector Line Top
                   if (index > 0)
                     Expanded(child: Container(width: 2, color: isCompleted ? MiniBarColors.primary : MiniBarColors.line)),

                   // Circle
                   Container(
                     width: 32,
                     height: 32,
                     decoration: BoxDecoration(
                       shape: BoxShape.circle,
                       color: isActive ? MiniBarColors.primary : (isCompleted ? MiniBarColors.primary.withValues(alpha: 0.2) : Colors.transparent),
                       border: Border.all(color: isActive || isCompleted ? MiniBarColors.primary : MiniBarColors.line, width: 2),
                     ),
                     alignment: Alignment.center,
                     child: isCompleted
                       ? Icon(Icons.check, size: 16, color: MiniBarColors.primary)
                       : Text('${index + 1}', style: TextStyle(color: isActive ? MiniBarColors.bg0 : MiniBarColors.muted, fontWeight: FontWeight.bold)),
                   ),

                   // Connector Line Bottom
                   if (index < totalSteps - 1)
                     Expanded(child: Container(width: 2, color: index < currentStep ? MiniBarColors.primary : MiniBarColors.line)),
                 ],
               ),
             );
          }),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
