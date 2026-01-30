// lib/screens/wizard/wizard_screen.dart
// Wizard screen with Vertical Rail Stepper

import 'package:flutter/material.dart';
import '../../theme/camper_tokens.dart';
import '../../widgets/wizard/wizard_rail_stepper.dart';
import 'wizard_controller.dart';
import 'steps/upload_step.dart';
import 'steps/style_step.dart';
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
    StyleStep(controller: _controller),
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

  Future<bool> _onWillPop() async {
    if (_controller.currentStep > 0) {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: CamperTokens.surface,
          title: const Text('Exit Build?'),
          content: const Text('Your layout progress will be lost.'),
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
        backgroundColor: Colors.transparent, // Handled by RootShell background
        body: SafeArea(
          child: Row(
            children: [
              // Vertical Rail (Left)
              WizardRailStepper(
                currentStep: _controller.currentStep,
                totalSteps: 5,
                stepLabels: _stepLabels,
                onStepTapped: (index) {
                   // Optional: Allow jump back
                   if (index < _controller.currentStep) {
                     // For MVP, just allow stepping back
                   }
                },
              ),

              // Content Area
              Expanded(
                child: Column(
                  children: [
                    // Top Bar (Exit)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () async {
                              if (await _onWillPop()) {
                                _controller.resetWizard();
                              }
                            },
                          ),
                        ],
                      ),
                    ),

                    // Step Content
                    Expanded(
                      child: _steps[_controller.currentStep],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
