import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/wizard_rail_stepper.dart';
import 'wizard_controller.dart';
import 'steps/upload_step.dart';
import 'steps/style_step.dart';
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

  Future<bool> _onWillPop() async {
    if (_controller.currentStep > 0) {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: StudyAIColors.surface,
          title: Text('Exit Wizard?', style: StudyAIText.h3),
          content: Text('Your progress will be lost.', style: StudyAIText.body),
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
        backgroundColor: Colors.transparent, // Background from RootShell
        appBar: AppBar(
          toolbarHeight: 0, // Hide standard app bar, use custom or none
          backgroundColor: Colors.transparent,
          systemOverlayStyle: null, // Keep status bar
        ),
        body: SafeArea(
          child: Row(
            children: [
              // Left Rail
              WizardRailStepper(
                currentStep: _controller.currentStep,
                onStepTapped: (step) {
                  // Only allow going back or to current
                  if (step < _controller.currentStep) {
                    _controller.setStep(step);
                  }
                },
              ),

              // Content
              Expanded(
                child: Column(
                  children: [
                    // Top Bar (Close)
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () async {
                          if (await _onWillPop()) {
                            _controller.resetWizard();
                            if (context.mounted) Navigator.pop(context); // If pushed
                          }
                        },
                      ),
                    ),

                    // Main Content
                    Expanded(
                      child: _buildStepContent(),
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

  Widget _buildStepContent() {
    switch (_controller.currentStep) {
      case 0:
        return UploadStep(controller: _controller);
      case 1:
        return StyleStep(controller: _controller);
      case 2:
        return ResultStep(controller: _controller);
      default:
        return const SizedBox.shrink();
    }
  }
}
