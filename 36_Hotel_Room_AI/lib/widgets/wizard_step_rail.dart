import 'package:flutter/material.dart';
import '../theme/hotel_room_ai_theme.dart';

class WizardStepRail extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> stepLabels;
  final Function(int) onStepTap;

  const WizardStepRail({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.stepLabels,
    required this.onStepTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      color: HotelAIColors.bg1,
      child: Column(
        children: [
          const SizedBox(height: HotelAISpacing.xl),
          Expanded(
            child: ListView.separated(
              itemCount: totalSteps,
              separatorBuilder: (_, __) => _Connector(isActive: false), // Static connector
              itemBuilder: (context, index) {
                final isCompleted = index < currentStep;
                final isCurrent = index == currentStep;

                return _RailItem(
                  index: index,
                  label: stepLabels.length > index ? stepLabels[index] : '',
                  state: isCompleted
                      ? _StepState.completed
                      : isCurrent ? _StepState.current : _StepState.future,
                  onTap: () => onStepTap(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

enum _StepState { completed, current, future }

class _RailItem extends StatelessWidget {
  final int index;
  final String label;
  final _StepState state;
  final VoidCallback onTap;

  const _RailItem({
    required this.index,
    required this.label,
    required this.state,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color circleColor;
    Color iconColor;
    Color textColor;

    switch (state) {
      case _StepState.completed:
        circleColor = HotelAIColors.primary;
        iconColor = Colors.white;
        textColor = HotelAIColors.primary;
        break;
      case _StepState.current:
        circleColor = HotelAIColors.ink0;
        iconColor = Colors.white;
        textColor = HotelAIColors.ink0;
        break;
      case _StepState.future:
        circleColor = HotelAIColors.bg0;
        iconColor = HotelAIColors.muted;
        textColor = HotelAIColors.muted;
        break;
    }

    return GestureDetector(
      onTap: state == _StepState.future ? null : onTap, // Prevent skipping ahead
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: circleColor,
              shape: BoxShape.circle,
              border: state == _StepState.future
                  ? Border.all(color: HotelAIColors.line)
                  : null,
              boxShadow: state == _StepState.current
                  ? HotelAIShadows.soft
                  : null,
            ),
            child: Center(
              child: state == _StepState.completed
                  ? const Icon(Icons.check, size: 20, color: Colors.white)
                  : Text(
                      '${index + 1}',
                      style: HotelAIText.bodyMedium.copyWith(
                        color: iconColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: HotelAIText.caption.copyWith(
              color: textColor,
              fontSize: 10,
              fontWeight: state == _StepState.current
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _Connector extends StatelessWidget {
  final bool isActive;
  const _Connector({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 2,
      height: 24,
      color: isActive ? HotelAIColors.primary : HotelAIColors.line,
      margin: const EdgeInsets.symmetric(vertical: 2),
    );
  }
}
