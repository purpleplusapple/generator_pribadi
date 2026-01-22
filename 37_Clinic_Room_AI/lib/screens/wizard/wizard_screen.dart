import 'package:flutter/material.dart';
import '../../theme/clinic_theme.dart';
import '../../widgets/clinic_segmented_stepper.dart';
import '../../widgets/primary_button.dart';
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
    'Generate',
    'Done',
  ];

  Future<bool> _onWillPop() async {
    if (_controller.currentStep > 0) {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Exit Wizard?', style: ClinicText.h3),
          content: Text(
            'Your progress will be lost. Are you sure?',
            style: ClinicText.body,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: ClinicColors.danger),
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
    // If we are on result step, we might want to hide nav bar or change behavior
    // But for now keeping consistent.

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
        backgroundColor: ClinicColors.bg0,
        appBar: AppBar(
          title: Text(
            _controller.currentStep == 4 ? 'Analysis Complete' : 'Clinic Design Wizard',
            style: ClinicText.h3.copyWith(fontSize: 18),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async {
              if (await _onWillPop()) {
                _controller.resetWizard();
              }
            },
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              if (_controller.currentStep < 4) // Hide stepper on Result
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: ClinicSpacing.base),
                  child: ClinicSegmentedStepper(
                    currentStep: _controller.currentStep,
                    totalSteps: 5,
                    stepLabels: _stepLabels,
                  ),
                ),

              Expanded(
                child: _steps[_controller.currentStep],
              ),

              if (_controller.getValidationMessage(_controller.currentStep) != null)
                _buildValidationMessage(),

              if (_controller.currentStep < 4)
                _buildNavigationButtons(),
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
      margin: const EdgeInsets.symmetric(horizontal: ClinicSpacing.lg, vertical: ClinicSpacing.sm),
      padding: const EdgeInsets.all(ClinicSpacing.md),
      decoration: BoxDecoration(
        color: ClinicColors.warning.withValues(alpha: 0.1),
        borderRadius: ClinicRadius.smallRadius,
        border: Border.all(color: ClinicColors.warning.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: ClinicColors.warning, size: 20),
          const SizedBox(width: ClinicSpacing.sm),
          Expanded(
            child: Text(message, style: ClinicText.caption),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    final canProceed = _controller.canProceedFromStep(_controller.currentStep);

    return Container(
      padding: const EdgeInsets.all(ClinicSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: ClinicColors.line)),
      ),
      child: Row(
        children: [
          if (!_controller.isFirstStep) ...[
            Expanded(
              child: OutlinedButton(
                onPressed: _controller.previousStep,
                child: const Text('Back'),
              ),
            ),
            const SizedBox(width: ClinicSpacing.base),
          ],
          Expanded(
            flex: 2,
            child: PrimaryButton(
              label: _controller.isLastStep ? 'Finish' : 'Next Step',
              onPressed: canProceed ? _controller.nextStep : null,
              icon: _controller.isLastStep ? Icons.check : Icons.arrow_forward,
            ),
          ),
        ],
      ),
    );
  }
}
