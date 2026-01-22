// lib/screens/wizard/wizard_screen.dart
// Vertical Rail Wizard Layout
// Option A: Boutique Linen

import 'package:flutter/material.dart';
import '../../theme/hotel_room_ai_theme.dart';
import '../../widgets/wizard_step_rail.dart';
import 'wizard_controller.dart';
import 'steps/upload_step.dart';
import 'steps/style_step.dart'; // Will rename later
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
    setState(() {});
  }

  List<Widget> get _steps => [
    UploadStep(controller: _controller),
    StyleStep(controller: _controller),
    ReviewEditStep(controller: _controller),
    PreviewGenerateStep(controller: _controller),
    ResultStep(controller: _controller),
  ];

  final List<String> _stepLabels = const [
    'Upload',
    'Style',
    'Edit',
    'Generate',
    'Result',
  ];

  @override
  Widget build(BuildContext context) {
    // Determine if we should show the rail (hide on result step if needed, but let's keep it for consistency or hide it for full immersion)
    // The prompt says "Vertical step rail".

    return Scaffold(
      backgroundColor: HotelAIColors.bg0,
      body: SafeArea(
        child: Row(
          children: [
            // Left Rail
            WizardStepRail(
              currentStep: _controller.currentStep,
              totalSteps: _steps.length,
              stepLabels: _stepLabels,
              onStepTap: (index) {
                // Only allow going back or to completed steps
                if (index < _controller.currentStep) {
                  // Jump to step logic if controller supports it, or just ignore for now
                  // The controller might only have next/prev.
                  // Let's implement jump if we can, or just loop back.
                  while (_controller.currentStep > index) {
                    _controller.previousStep();
                  }
                }
              },
            ),

            // Vertical Divider
            Container(width: 1, color: HotelAIColors.line),

            // Main Content Area
            Expanded(
              child: Column(
                children: [
                  // Top Header (Title of current step)
                  Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(horizontal: HotelAISpacing.lg),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: HotelAIColors.line)),
                      color: HotelAIColors.bg1,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _stepLabels[_controller.currentStep],
                          style: HotelAIText.h3,
                        ),
                        // Action / Next button
                        _buildHeaderAction(),
                      ],
                    ),
                  ),

                  // Step Content
                  Expanded(
                    child: _steps[_controller.currentStep],
                  ),

                  // Mobile Bottom Bar (optional, if rail is hidden on mobile, but we are enforcing rail)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderAction() {
    final canProceed = _controller.canProceedFromStep(_controller.currentStep);
    final isLast = _controller.isLastStep;

    return TextButton(
      onPressed: canProceed ? _controller.nextStep : null,
      child: Row(
        children: [
          Text(
            isLast ? 'Finish' : 'Next',
            style: HotelAIText.button.copyWith(
              color: canProceed ? HotelAIColors.primary : HotelAIColors.muted,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            isLast ? Icons.check : Icons.arrow_forward,
            size: 16,
            color: canProceed ? HotelAIColors.primary : HotelAIColors.muted,
          ),
        ],
      ),
    );
  }
}
