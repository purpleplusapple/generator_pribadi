import 'package:flutter/material.dart';
import '../theme/barber_theme.dart';

class VerticalRailStepper extends StatelessWidget {
  final int currentStep;
  final List<String> steps;
  final Function(int) onStepTapped;

  const VerticalRailStepper({
    super.key,
    required this.currentStep,
    required this.steps,
    required this.onStepTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      color: BarberTheme.bg1,
      child: Column(
        children: [
          const SizedBox(height: 24),
          for (int i = 0; i < steps.length; i++)
            _StepItem(
              index: i,
              label: steps[i],
              isActive: i == currentStep,
              isCompleted: i < currentStep,
              isLast: i == steps.length - 1,
              onTap: () => onStepTapped(i),
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
  final bool isLast;
  final VoidCallback onTap;

  const _StepItem({
    required this.index,
    required this.label,
    required this.isActive,
    required this.isCompleted,
    required this.isLast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive
                  ? BarberTheme.primary
                  : (isCompleted ? BarberTheme.surface2 : Colors.transparent),
              border: Border.all(
                color: isActive || isCompleted ? BarberTheme.primary : BarberTheme.muted,
                width: 2,
              ),
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, size: 16, color: BarberTheme.ink0)
                  : Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: isActive ? BarberTheme.bg0 : BarberTheme.muted,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: isActive ? BarberTheme.primary : BarberTheme.muted,
              fontSize: 10,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          if (!isLast)
            Container(
              width: 2,
              height: 40,
              margin: const EdgeInsets.symmetric(vertical: 8),
              color: isCompleted ? BarberTheme.primary.withOpacity(0.5) : BarberTheme.surface2,
            ),
        ],
      ),
    );
  }
}
