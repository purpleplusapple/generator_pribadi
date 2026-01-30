// lib/screens/wizard/wizard_screen.dart
// Wizard screen with 5-step progress indicator and navigation

import 'package:flutter/material.dart';
import '../../theme/guest_room_ai_theme.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/wizard_progress_indicator.dart';
import 'wizard_controller.dart';
import 'steps/upload_step.dart';
import 'steps/style_guest_step.dart';
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
    StyleGuestStep(controller: _controller),
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
      // Show confirmation dialog
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: GuestAIColors.soleBlack,
          title: Text(
            'Exit Wizard?',
            style: GuestAIText.h3,
          ),
          content: Text(
            'Your progress will be lost. Are you sure you want to exit?',
            style: GuestAIText.body,
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
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          toolbarHeight: 48, // Reduced from default 56
          title: const Text('Design Wizard'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed:() async {
              if (await _onWillPop()) {
                _controller.resetWizard();
              }
            },
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // New visual progress indicator
              WizardProgressIndicator(
                currentStep: _controller.currentStep,
                totalSteps: 5,
                stepLabels: _stepLabels,
              ),

              // Current step content
              Expanded(
                child: _steps[_controller.currentStep],
              ),

              // Validation message (if any)
              if (_controller.getValidationMessage(_controller.currentStep) != null)
                _buildValidationMessage(),

              // Navigation buttons
              _buildNavigationButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(GuestAISpacing.base),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(
          horizontal: GuestAISpacing.lg,
          vertical: GuestAISpacing.md,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (index) {
            return Expanded(
              child: Row(
                children: [
                  _buildStepCircle(index),
                  if (index < 4) _buildConnector(index),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildStepCircle(int index) {
    final isCurrent = index == _controller.currentStep;
    final isCompleted = index < _controller.currentStep;

    Color color;
    Widget child;

    if (isCompleted) {
      color = GuestAIColors.metallicGold;
      child = const Icon(Icons.check, color: Colors.white, size: 16);
    } else if (isCurrent) {
      color = GuestAIColors.leatherTan;
      child = Text(
        '${index + 1}',
        style: GuestAIText.caption.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      );
    } else {
      color = GuestAIColors.canvasWhite.withValues(alpha: 0.2);
      child = Text(
        '${index + 1}',
        style: GuestAIText.caption.copyWith(
          color: GuestAIColors.canvasWhite.withValues(alpha: 0.5),
          fontWeight: FontWeight.w600,
        ),
      );
    }

    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: isCurrent
                ? Border.all(
                    color: GuestAIColors.leatherTan.withValues(alpha: 0.3),
                    width: 3,
                  )
                : null,
          ),
          child: Center(child: child),
        ),
        const SizedBox(height: 6),
        Text(
          _stepLabels[index],
          style: GuestAIText.small.copyWith(
            color: isCurrent
                ? GuestAIColors.leatherTan
                : isCompleted
                    ? GuestAIColors.metallicGold
                    : GuestAIColors.canvasWhite.withValues(alpha: 0.5),
            fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildConnector(int index) {
    final isCompleted = index < _controller.currentStep;

    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 24),
        color: isCompleted
            ? GuestAIColors.metallicGold
            : GuestAIColors.canvasWhite.withValues(alpha: 0.2),
      ),
    );
  }

  Widget _buildValidationMessage() {
    final message = _controller.getValidationMessage(_controller.currentStep);
    if (message == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: GuestAISpacing.base,
        vertical: GuestAISpacing.sm,
      ),
      child: GlassCard(
        padding: const EdgeInsets.all(GuestAISpacing.md),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: GuestAIColors.warning,
              size: 20,
            ),
            const SizedBox(width: GuestAISpacing.sm),
            Expanded(
              child: Text(
                message,
                style: GuestAIText.caption.copyWith(
                  color: GuestAIColors.canvasWhite,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    final canProceed = _controller.canProceedFromStep(_controller.currentStep);

    return Padding(
      padding: const EdgeInsets.all(GuestAISpacing.base),
      child: Row(
        children: [
          // Back button
          if (!_controller.isFirstStep) ...[
            Expanded(
              child: OutlinedButton(
                onPressed: _controller.previousStep,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: GuestAIColors.canvasWhite.withValues(alpha: 0.3),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: GuestAISpacing.base,
                  ),
                ),
                child: Text(
                  'Back',
                  style: GuestAIText.button.copyWith(
                    color: GuestAIColors.canvasWhite,
                  ),
                ),
              ),
            ),
            const SizedBox(width: GuestAISpacing.md),
          ],

          // Next button
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
