// lib/screens/wizard/wizard_screen.dart
// Wizard screen with Vertical Rail Stepper

import 'package:flutter/material.dart';
import '../../theme/camper_theme.dart';
import '../../widgets/glass_card.dart';
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
    'Review',
    'Generate',
    'Result',
  ];

  Future<bool> _onWillPop() async {
    if (_controller.currentStep > 0) {
      // Logic to confirm exit
       _controller.resetWizard(); // For prototype speed
       return true;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CamperAIColors.soleBlack,
      body: SafeArea(
        child: Row(
          children: [
            // Vertical Rail
            WizardRailStepper(
              currentStep: _controller.currentStep,
              totalSteps: 5,
              stepTitles: _stepLabels,
            ),

            // Content Area
            Expanded(
              child: Column(
                children: [
                  // Header / Nav
                  _buildHeader(),

                  // Step Content
                  Expanded(
                    child: _steps[_controller.currentStep],
                  ),

                  // Bottom Nav (Next/Back)
                  _buildBottomNav(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Design Studio", style: CamperAIText.h3),
          IconButton(
            icon: const Icon(Icons.close, color: CamperAIColors.canvasWhite),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
     final canProceed = _controller.canProceedFromStep(_controller.currentStep);

     return Container(
       padding: const EdgeInsets.all(16),
       decoration: BoxDecoration(
         border: Border(top: BorderSide(color: CamperAIColors.line)),
       ),
       child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
           if (_controller.currentStep > 0)
             TextButton(
               onPressed: _controller.previousStep,
               child: Text("Back", style: CamperAIText.button.copyWith(color: CamperAIColors.muted)),
             )
           else
             const SizedBox(width: 60),

           if (_controller.currentStep < _steps.length - 1)
             ElevatedButton(
               onPressed: canProceed ? _controller.nextStep : null,
               child: Text("Next Step"),
             ),
         ],
       ),
     );
  }
}
