import 'package:flutter/material.dart';
import '../theme/guest_theme.dart';

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
      width: 72,
      color: GuestAIColors.warmLinen,
      child: Column(
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: steps.length,
              separatorBuilder: (_, __) => const SizedBox(height: 32),
              itemBuilder: (context, index) {
                final isSelected = index == currentStep;
                final isCompleted = index < currentStep;

                return GestureDetector(
                  onTap: () {
                    if (index <= currentStep) {
                       onStepTapped(index);
                    }
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isSelected ? GuestAIColors.brass : (isCompleted ? GuestAIColors.deepTeal : Colors.transparent),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected || isCompleted ? Colors.transparent : GuestAIColors.line,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: isCompleted
                              ? const Icon(Icons.check, color: Colors.white, size: 16)
                              : Text(
                                  "${index + 1}",
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : GuestAIColors.muted,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        steps[index],
                        style: GuestAIText.small.copyWith(
                          fontSize: 10,
                          color: isSelected ? GuestAIColors.inkTitle : GuestAIColors.muted,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
