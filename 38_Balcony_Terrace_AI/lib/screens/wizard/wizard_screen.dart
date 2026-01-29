// lib/screens/wizard/wizard_screen.dart
// Wizard screen with Vertical Rail Stepper

import 'package:flutter/material.dart';
import '../../theme/terrace_theme.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/wizard_rail_stepper.dart'; // New Rail
import 'wizard_controller.dart';
import 'steps/upload_step.dart';
import 'steps/style_terrace_step.dart'; // Was laundry
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
    StyleTerraceStep(controller: _controller), // Updated class name required in file too
    ReviewEditStep(controller: _controller),
    PreviewGenerateStep(controller: _controller),
    ResultStep(controller: _controller),
  ];

  final List<String> _stepLabels = const [
    'Upload',
    'Style',
    'Review',
    'Generate',
    'Done',
  ];

  Future<bool> _onWillPop() async {
    if (_controller.currentStep > 0) {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: TerraceAIColors.surface,
          title: Text('Exit Wizard?', style: TerraceAIText.h3),
          content: Text(
            'Your progress will be lost. Are you sure you want to exit?',
            style: TerraceAIText.body,
          ),
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
        backgroundColor: TerraceAIColors.bg0,
        body: SafeArea(
          child: Row(
            children: [
              // Left Rail
              WizardRailStepper(
                currentStep: _controller.currentStep,
                totalSteps: 5,
                stepLabels: _stepLabels,
                onStepTapped: (index) {
                   // Only allow going back to completed steps
                   if (index < _controller.currentStep) {
                     _controller.goToStep(index);
                   }
                },
              ),

              // Main Content Area
              Expanded(
                child: Column(
                  children: [
                    // Step Content
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(TerraceAIRadii.lg),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: TerraceAIColors.bg0,
                            image: const DecorationImage(
                              image: AssetImage('assets/icon.jpg'), // Placeholder for bokeh or pattern
                              fit: BoxFit.cover,
                              opacity: 0.05,
                            ),
                          ),
                          child: _steps[_controller.currentStep],
                        ),
                      ),
                    ),

                    // Validation Message
                    if (_controller.getValidationMessage(_controller.currentStep) != null)
                      _buildValidationMessage(),

                    // Bottom Action Bar (if needed, or steps handle their own)
                    // The original design had buttons outside steps.
                    // Let's keep them here for consistency across steps, but style them for the rail layout.
                    _buildNavigationButtons(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildValidationMessage() {
    final message = _controller.getValidationMessage(_controller.currentStep);
    if (message == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: TerraceAISpacing.base,
        vertical: TerraceAISpacing.sm,
      ),
      padding: const EdgeInsets.all(TerraceAISpacing.md),
      decoration: BoxDecoration(
        color: TerraceAIColors.warning.withValues(alpha: 0.1),
        borderRadius: TerraceAIRadii.smRadius,
        border: Border.all(color: TerraceAIColors.warning.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: TerraceAIColors.warning, size: 20),
          const SizedBox(width: TerraceAISpacing.sm),
          Expanded(
            child: Text(
              message,
              style: TerraceAIText.caption.copyWith(color: TerraceAIColors.ink0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    final canProceed = _controller.canProceedFromStep(_controller.currentStep);

    return Container(
      padding: const EdgeInsets.all(TerraceAISpacing.base),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: TerraceAIColors.line)),
        color: TerraceAIColors.bg1,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Next button
          GradientButton(
            label: _controller.isLastStep ? 'Finish' : 'Next Step',
            onPressed: canProceed ? _controller.nextStep : null,
            icon: _controller.isLastStep ? Icons.check : Icons.arrow_forward_rounded,
          ),
        ],
      ),
    );
  }
}
