import 'package:flutter/material.dart';
import '../../theme/guest_theme.dart';
import '../../widgets/wizard_rail_stepper.dart';
import 'wizard_controller.dart';
import 'upload_step_two_panel.dart';
import 'steps/style_guest_step.dart';
import 'guest_result_screen.dart';

class GuestWizardScreen extends StatefulWidget {
  const GuestWizardScreen({super.key});

  @override
  State<GuestWizardScreen> createState() => _GuestWizardScreenState();
}

class _GuestWizardScreenState extends State<GuestWizardScreen> {
  final WizardController _controller = WizardController();
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerChange);
  }

  void _onControllerChange() {
    if (mounted) {
      if (_pageController.hasClients) {
        _pageController.jumpToPage(_controller.currentStep);
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChange);
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GuestAIColors.warmLinen,
      body: SafeArea(
        child: Row(
          children: [
            // Left Rail
            WizardRailStepper(
              currentStep: _controller.currentStep,
              steps: const ["Upload", "Style", "Review", "Preview", "Result"],
              onStepTapped: (index) {
                // Only allow going back or to current
                if (index <= _controller.currentStep) {
                  _controller.goToStep(index);
                }
              },
            ),

            // Vertical Divider
            Container(width: 1, color: GuestAIColors.line),

            // Main Content Area
            Expanded(
              child: Column(
                children: [
                  // Top Bar (Back + Title)
                  Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        if (_controller.currentStep == 0)
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.of(context).pop(),
                          )
                        else
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: _controller.previousStep,
                          ),
                        const SizedBox(width: 8),
                        Text(
                          _getStepTitle(_controller.currentStep),
                          style: GuestAIText.h3,
                        ),
                        const Spacer(),
                        if (_controller.currentStep < 4) // Not Result
                          TextButton(
                            onPressed: _canProceed() ? _controller.nextStep : null,
                            child: Text(
                              "Next",
                              style: GuestAIText.button.copyWith(
                                color: _canProceed() ? GuestAIColors.brass : GuestAIColors.muted,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Step Content
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        UploadStepTwoPanel(controller: _controller),
                        StyleGuestStep(controller: _controller),
                        _buildPlaceholderStep("Review Options"),
                        _buildPlaceholderStep("Generating Preview..."),
                        GuestResultScreen(controller: _controller),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStepTitle(int step) {
    switch(step) {
      case 0: return "Upload Room";
      case 1: return "Choose Style";
      case 2: return "Review";
      case 3: return "Generating";
      case 4: return "Your Design";
      default: return "";
    }
  }

  bool _canProceed() {
    return _controller.canProceedFromStep(_controller.currentStep);
  }

  Widget _buildPlaceholderStep(String title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: GuestAIText.h2),
          const SizedBox(height: 16),
          const CircularProgressIndicator(),
        ],
      ),
    );
  }
}
