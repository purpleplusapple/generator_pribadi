import 'package:flutter/material.dart';
import '../../theme/apartment_tokens.dart';
import '../../widgets/gradient_button.dart';
import 'wizard_controller.dart';
import 'steps/upload_step.dart';
import 'steps/style_apartment_step.dart';
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
    StyleApartmentStep(controller: _controller),
    ReviewEditStep(controller: _controller),
    PreviewGenerateStep(controller: _controller),
    ResultStep(controller: _controller),
  ];

  final List<String> _stepLabels = const [
    '1. Upload',
    '2. Style',
    '3. Review',
    '4. Gen',
    '5. Done',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ApartmentTokens.bg0,
      appBar: AppBar(
        backgroundColor: ApartmentTokens.bg0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: ApartmentTokens.ink0),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'New Studio Project',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: ApartmentTokens.ink0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildHorizontalStepper(),
          Expanded(
            child: _steps[_controller.currentStep],
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildHorizontalStepper() {
    return Container(
      height: 60,
      width: double.infinity,
      color: ApartmentTokens.bg0,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Line
          Positioned(
            left: 40,
            right: 40,
            top: 20,
            child: Container(
              height: 2,
              color: ApartmentTokens.line,
            ),
          ),
           Positioned(
            left: 40,
            right: 40,
            top: 20,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final stepWidth = constraints.maxWidth / (_stepLabels.length - 1);
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 2,
                    width: stepWidth * _controller.currentStep,
                    color: ApartmentTokens.primary,
                  ),
                );
              }
            ),
          ),
          // Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_stepLabels.length, (index) {
              final isActive = index <= _controller.currentStep;
              final isCurrent = index == _controller.currentStep;

              return Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                         if (index < _controller.currentStep) {
                            _controller.goToStep(index);
                         }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: isCurrent ? 16 : 12,
                        height: isCurrent ? 16 : 12,
                        decoration: BoxDecoration(
                          color: isActive ? ApartmentTokens.primary : ApartmentTokens.surface,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isActive ? ApartmentTokens.primary : ApartmentTokens.line,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _stepLabels[index].split('. ')[1],
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                        color: isActive ? ApartmentTokens.ink0 : ApartmentTokens.muted,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    final canProceed = _controller.canProceedFromStep(_controller.currentStep);

    return Container(
      padding: const EdgeInsets.all(ApartmentTokens.s16),
      decoration: const BoxDecoration(
        color: ApartmentTokens.surface,
        border: Border(top: BorderSide(color: ApartmentTokens.line)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (!_controller.isFirstStep)
              TextButton(
                onPressed: _controller.previousStep,
                child: const Text('Back', style: TextStyle(color: ApartmentTokens.ink1)),
              ),
            const Spacer(),
            ElevatedButton(
              onPressed: canProceed ? _controller.nextStep : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: ApartmentTokens.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ApartmentTokens.rMax),
                ),
              ),
              child: Text(_controller.isLastStep ? 'Finish' : 'Next Step'),
            ),
          ],
        ),
      ),
    );
  }
}
