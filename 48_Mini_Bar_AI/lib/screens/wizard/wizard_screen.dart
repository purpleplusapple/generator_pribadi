// lib/screens/wizard/wizard_screen.dart
import 'package:flutter/material.dart';
import '../../theme/mini_bar_theme.dart';
import '../../theme/design_tokens.dart';
import '../../widgets/wizard_rail_stepper.dart';
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

  // NOTE: StyleLaundryStep will be refactored to StyleMoodboardStep in content
  List<Widget> get _steps => [
    UploadStep(controller: _controller),
    StyleLaundryStep(controller: _controller),
    ReviewEditStep(controller: _controller),
    PreviewGenerateStep(controller: _controller),
    ResultStep(controller: _controller),
  ];

  Future<bool> _onWillPop() async {
    if (_controller.currentStep > 0) {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: MiniBarColors.surface,
          title: Text('Exit Lounge Wizard?', style: MiniBarText.h3),
          content: Text('Your bar design progress will be discarded.', style: MiniBarText.body),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Stay')),
            TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Exit')),
          ],
        ),
      );
      return result ?? false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () async {
            if (await _onWillPop()) _controller.resetWizard();
          },
        ),
        title: Text('Design Your Bar', style: MiniBarText.h3),
      ),
      body: Row(
        children: [
          // Left Rail Stepper
          WizardRailStepper(
            currentStep: _controller.currentStep,
            totalSteps: 5,
          ),

          // Right Content Panel
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _steps[_controller.currentStep],
                  ),
                ),

                // Navigation Area
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: MiniBarColors.surface,
                    border: const Border(top: BorderSide(color: MiniBarColors.line)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_controller.currentStep > 0)
                        OutlinedButton(
                          onPressed: _controller.previousStep,
                          child: const Text('Back'),
                        )
                      else
                        const SizedBox(width: 80), // Spacer

                      ElevatedButton(
                        onPressed: _controller.canProceedFromStep(_controller.currentStep)
                            ? _controller.nextStep
                            : null,
                        child: Text(_controller.isLastStep ? 'Finish' : 'Next Step'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
