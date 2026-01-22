import 'package:flutter/material.dart';
import '../../theme/beauty_salon_ai_theme.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/segmented_wizard_stepper.dart';
import '../../services/premium_gate_service.dart';
import 'wizard_controller.dart';
import 'steps/upload_step.dart';
import 'steps/style_selection_step.dart';
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
  int _quota = 0;

  @override
  void initState() {
    super.initState();
    _controller = WizardController();
    _controller.addListener(_onControllerUpdate);
    _loadQuota();
  }

  Future<void> _loadQuota() async {
    final remaining = await PremiumGateService().getRemainingGenerations();
    if (mounted) setState(() => _quota = remaining);
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
    StyleSelectionStep(controller: _controller),
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
          backgroundColor: BeautyAIColors.surface,
          title: Text('Exit Design?', style: BeautyAIText.h3),
          content: Text('Your progress will be lost.', style: BeautyAIText.body),
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
        backgroundColor: BeautyAIColors.bg0,
        appBar: AppBar(
          toolbarHeight: 56,
          title: Text('Design Wizard', style: BeautyAIText.h3),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () async {
              if (await _onWillPop()) {
                if (mounted) Navigator.of(context).pop();
              }
            },
          ),
          actions: [
            // Quota Chip
            if (_quota != -1) // -1 usually means unlimited
              Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: BeautyAIColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: BeautyAIColors.primary.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.bolt_rounded, size: 14, color: BeautyAIColors.primary),
                    const SizedBox(width: 4),
                    Text(
                      '$_quota',
                      style: BeautyAIText.caption.copyWith(
                        color: BeautyAIColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              // New Segmented Stepper
              SegmentedWizardStepper(
                currentStep: _controller.currentStep,
                totalSteps: _stepLabels.length,
                steps: _stepLabels,
              ),

              // Step Content
              Expanded(
                child: _steps[_controller.currentStep],
              ),

              // Bottom Bar with Navigation
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: BeautyAIColors.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      if (!_controller.isFirstStep)
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: TextButton(
                            onPressed: _controller.previousStep,
                            child: Text('Back', style: BeautyAIText.button.copyWith(color: BeautyAIColors.muted)),
                          ),
                        ),
                      Expanded(
                        child: GradientButton(
                          label: _controller.isLastStep ? 'Finish' : 'Continue',
                          onPressed: _controller.canProceedFromStep(_controller.currentStep)
                              ? _controller.nextStep
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
