// lib/screens/wizard/wizard_screen.dart
// Vertical Rail Wizard

import 'package:flutter/material.dart';
import '../../theme/meeting_room_theme.dart';
import '../../theme/meeting_tokens.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_button.dart';
import 'wizard_controller.dart';
import 'steps/upload_step.dart';
import 'steps/style_laundry_step.dart';
import 'steps/review_edit_step.dart';
import 'steps/preview_generate_step.dart';
import 'steps/result_step.dart';

class WizardScreen extends StatefulWidget {
  const WizardScreen({super.key});

  @override
  State<WizardScreen> createState() => _WizardScreenState();
}

class _WizardScreenState extends State<WizardScreen> {
  late final WizardController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WizardController();
    _controller.addListener(_onControllerUpdate);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    super.dispose();
  }

  void _onControllerUpdate() {
    setState(() {}); // Rebuild when controller changes
  }

  List<Widget> get _steps => [
    UploadStep(controller: _controller),
    StyleLaundryStep(controller: _controller),
    ReviewEditStep(controller: _controller),
    PreviewGenerateStep(controller: _controller),
    ResultStep(controller: _controller),
  ];

  final List<String> _stepLabels = const [
    'Upload',
    'Style',
    'Review',
    'Create',
    'Result',
  ];

  final List<IconData> _stepIcons = const [
    Icons.upload_file_rounded,
    Icons.style_rounded,
    Icons.rate_review_rounded,
    Icons.auto_awesome_rounded,
    Icons.check_circle_rounded,
  ];

  Future<bool> _onWillPop() async {
    if (_controller.currentStep > 0) {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: MeetingTokens.surface,
          title: Text('Exit Wizard?', style: MeetingRoomText.h3),
          content: Text('Progress will be lost.', style: MeetingRoomText.body),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Exit'),
            ),
          ],
        ),
      );
      return result ?? false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _controller.currentStep == 0,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop && _controller.currentStep > 0) {
          final shouldPop = await _onWillPop();
          if (shouldPop && context.mounted) {
            _controller.resetWizard();
          }
        }
      },
      child: Scaffold(
        backgroundColor: MeetingTokens.bg0,
        body: SafeArea(
          child: Row(
            children: [
              // RAIL STEPPER
              _buildRail(),

              // CONTENT
              Expanded(
                child: Column(
                  children: [
                    // Header
                    _buildHeader(),

                    // Step Content
                    Expanded(
                      child: _steps[_controller.currentStep],
                    ),

                    // Validation & Navigation
                    _buildFooter(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _stepLabels[_controller.currentStep].toUpperCase(),
            style: MeetingRoomText.h3,
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async {
              if (await _onWillPop()) Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRail() {
    return Container(
      width: 70,
      decoration: BoxDecoration(
        color: MeetingTokens.surface,
        border: Border(right: BorderSide(color: MeetingTokens.line.withValues(alpha: 0.5))),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Icon(Icons.meeting_room_rounded, color: MeetingTokens.accent, size: 28),
          const SizedBox(height: 40),
          Expanded(
            child: ListView.separated(
              itemCount: _stepLabels.length,
              separatorBuilder: (c, i) => Container(
                width: 2,
                height: 20,
                color: (i < _controller.currentStep) ? MeetingTokens.primary : MeetingTokens.line,
              ),
              itemBuilder: (context, index) {
                final isCurrent = index == _controller.currentStep;
                final isCompleted = index < _controller.currentStep;

                return Column(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isCurrent ? MeetingTokens.accent : (isCompleted ? MeetingTokens.primary : Colors.transparent),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isCurrent ? MeetingTokens.accent : MeetingTokens.line,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          _stepIcons[index],
                          size: 18,
                          color: (isCurrent || isCompleted) ? MeetingTokens.bg0 : MeetingTokens.muted,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _stepLabels[index],
                      style: TextStyle(
                        fontSize: 9,
                        color: isCurrent ? MeetingTokens.accent : MeetingTokens.muted,
                        fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    final message = _controller.getValidationMessage(_controller.currentStep);
    final canProceed = _controller.canProceedFromStep(_controller.currentStep);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MeetingTokens.surface.withValues(alpha: 0.5),
        border: Border(top: BorderSide(color: MeetingTokens.line.withValues(alpha: 0.5))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
           if (message != null)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: MeetingTokens.danger.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: MeetingTokens.danger.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: MeetingTokens.danger),
                  const SizedBox(width: 8),
                  Expanded(child: Text(message, style: MeetingRoomText.small)),
                ],
              ),
            ),

          Row(
            children: [
               if (!_controller.isFirstStep)
                Expanded(
                  child: OutlinedButton(
                    onPressed: _controller.previousStep,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: MeetingTokens.line),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text('BACK', style: MeetingRoomText.button.copyWith(color: MeetingTokens.ink0)),
                  ),
                ),
              if (!_controller.isFirstStep) const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: GradientButton(
                  label: _controller.isLastStep ? 'FINISH' : 'NEXT',
                  onPressed: canProceed ? _controller.nextStep : null,
                  icon: _controller.isLastStep ? Icons.check : Icons.arrow_forward,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
