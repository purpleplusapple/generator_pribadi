import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_button.dart';
import 'wizard_controller.dart';
import 'wizard_rail_stepper.dart';
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
    setState(() {});
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
    'Gen',
    'Done',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.bg0,
      body: SafeArea(
        child: Row(
          children: [
            WizardRailStepper(
              currentStep: _controller.currentStep,
              totalSteps: 5,
              stepLabels: _stepLabels,
              onStepTapped: (index) {
                 if (index < _controller.currentStep) {
                    _controller.goToStep(index);
                 }
              },
            ),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _stepLabels[_controller.currentStep],
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: DesignTokens.ink0,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _steps[_controller.currentStep],
                  ),
                  _buildNavigationButtons(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    final canProceed = _controller.canProceedFromStep(_controller.currentStep);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DesignTokens.bg0,
        border: Border(top: BorderSide(color: DesignTokens.line.withOpacity(0.5))),
      ),
      child: Row(
        children: [
          if (!_controller.isFirstStep)
             Expanded(
               child: OutlinedButton(
                 onPressed: _controller.previousStep,
                 style: OutlinedButton.styleFrom(
                   side: const BorderSide(color: DesignTokens.line),
                   padding: const EdgeInsets.symmetric(vertical: 16),
                 ),
                 child: const Text('Back', style: TextStyle(color: DesignTokens.ink1)),
               ),
             ),
          if (!_controller.isFirstStep) const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: GradientButton(
              label: _controller.isLastStep ? 'Finish' : 'Next',
              onPressed: canProceed ? _controller.nextStep : null,
              icon: _controller.isLastStep ? Icons.check : Icons.arrow_forward,
            ),
          ),
        ],
      ),
    );
  }
}
