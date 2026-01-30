import 'package:flutter/material.dart';
import '../../../theme/camper_tokens.dart';
import '../wizard_controller.dart';
import '../../../model/image_result_data.dart'; // Ensure this model exists or use placeholder

class PreviewGenerateStep extends StatefulWidget {
  final WizardController controller;
  const PreviewGenerateStep({super.key, required this.controller});

  @override
  State<PreviewGenerateStep> createState() => _PreviewGenerateStepState();
}

class _PreviewGenerateStepState extends State<PreviewGenerateStep> {
  @override
  void initState() {
    super.initState();
    // Simulate generation
    Future.delayed(const Duration(seconds: 3), () {
       if (mounted) {
         // Mock result
         // In real app, call API here.
         widget.controller.setResultData(ImageResultData(
           generatedImagePath: widget.controller.selectedImagePath!, // For now, reuse original as result for mock
           prompt: "Mock prompt"
         ));
         widget.controller.nextStep();
       }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: CamperTokens.primary),
          const SizedBox(height: 24),
          Text("Designing your van...", style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          const Text("Analyzing geometry and applying style...", style: TextStyle(color: CamperTokens.muted)),
        ],
      ),
    );
  }
}
