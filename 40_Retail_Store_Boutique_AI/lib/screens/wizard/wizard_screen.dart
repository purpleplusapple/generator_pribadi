// lib/screens/wizard/wizard_screen.dart
// Wizard screen with Rail Stepper

import 'package:flutter/material.dart';
import '../../theme/boutique_theme.dart';
import '../../widgets/wizard_rail_stepper.dart';
import 'wizard_controller.dart';
import 'steps/upload_step.dart';
import 'steps/style_boutique_step.dart';
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
    StyleBoutiqueStep(controller: _controller),
    ReviewEditStep(controller: _controller),
    PreviewGenerateStep(controller: _controller),
    ResultStep(controller: _controller),
  ];

  final List<String> _stepLabels = const [
    'Upload',
    'Style',
    'Review',
    'Generate',
    'Result',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BoutiqueColors.bg0,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Main Content with Rail
            Expanded(
              child: Row(
                children: [
                  // Rail Stepper
                  WizardRailStepper(
                    currentStep: _controller.currentStep,
                    totalSteps: 5,
                    stepLabels: _stepLabels,
                  ),

                  // Step Content
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: _steps[_controller.currentStep],
                        ),
                        _buildFooter(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: BoutiqueColors.line)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: BoutiqueColors.ink1),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          Text("Design Studio", style: BoutiqueText.h3),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: BoutiqueColors.surface2,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.token, size: 14, color: BoutiqueColors.primary),
                const SizedBox(width: 6),
                Text("PRO", style: BoutiqueText.small.copyWith(color: BoutiqueColors.primary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    final canProceed = _controller.canProceedFromStep(_controller.currentStep);
    final isLast = _controller.isLastStep;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BoutiqueColors.surface,
        border: Border(top: BorderSide(color: BoutiqueColors.line)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_controller.currentStep > 0)
            TextButton(
              onPressed: _controller.previousStep,
              child: Text("Back", style: BoutiqueText.button.copyWith(color: BoutiqueColors.muted)),
            )
          else
            const SizedBox(width: 48), // Spacer

          ElevatedButton(
            onPressed: canProceed ? _controller.nextStep : null,
            child: Text(isLast ? "FINISH" : "NEXT STEP"),
          ),
        ],
      ),
    );
  }
}
