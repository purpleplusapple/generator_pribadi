// lib/screens/wizard/wizard_screen.dart
// Main Wizard Screen with Vertical Rail

import 'package:flutter/material.dart';
import '../../theme/barber_theme.dart';
import 'wizard_controller.dart';
import '../../widgets/vertical_rail_stepper.dart';
import 'steps/barber_upload_step.dart';
import 'steps/barber_style_step.dart';
import 'steps/barber_result_step.dart';

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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BarberTheme.bg0,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            return Column(
              children: [
                // Top Bar (Back + Title)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      if (_controller.currentStep > 0)
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: _controller.previousStep,
                        ),
                      const Spacer(),
                      Text(
                        _getStepTitle(_controller.currentStep),
                        style: BarberTheme.themeData.textTheme.titleMedium,
                      ),
                      const Spacer(),
                      // Close button (reset)
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                           // Navigate back to home or reset
                           // Using RootShell logic, usually tabs handle this, but if we want to reset:
                           _controller.resetWizard();
                        },
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Rail
                      VerticalRailStepper(
                        currentStep: _controller.currentStep,
                        steps: const ["Upload", "Style", "Result"],
                        onStepTapped: (index) {
                           // Only allow tapping back or if accessible
                           if (index < _controller.currentStep) {
                             _controller.goToStep(index);
                           }
                        },
                      ),

                      // Content Area
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 16, 16),
                          decoration: BoxDecoration(
                            color: BarberTheme.bg1,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: BarberTheme.line.withOpacity(0.5)),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: _buildStepContent(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom Action Bar
                if (_controller.currentStep < 2)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: BarberTheme.bg0,
                      border: Border(top: BorderSide(color: BarberTheme.line)),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _controller.canProceedFromStep(_controller.currentStep)
                            ? _controller.nextStep
                            : null,
                        child: Text(_controller.currentStep == 1 ? "Generate Design" : "Next Step"),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_controller.currentStep) {
      case 0:
        return BarberUploadStep(controller: _controller);
      case 1:
        return BarberStyleStep(controller: _controller);
      case 2:
        return BarberResultStep(controller: _controller);
      default:
        return const SizedBox();
    }
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 0: return "Upload Photo";
      case 1: return "Select Style";
      case 2: return "Your Design";
      default: return "";
    }
  }
}
