import 'dart:io';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/result_notes_panel.dart';
import '../../widgets/tap_or_swipe_compare_toggle.dart';
import '../wizard_controller.dart';
import '../../model/image_result_data.dart';
// import '../../services/replicate_nano_banana_service_multi.dart'; // Will interact via controller or logic

class ResultStep extends StatefulWidget {
  final WizardController controller;

  const ResultStep({super.key, required this.controller});

  @override
  State<ResultStep> createState() => _ResultStepState();
}

class _ResultStepState extends State<ResultStep> {
  bool _isAfter = true;
  bool _isLoading = true;
  String? _error;
  String? _generatedImageUrl;

  @override
  void initState() {
    super.initState();
    _startGeneration();
  }

  Future<void> _startGeneration() async {
    // Simulate generation for UI demo if no service connected yet
    // In real app, call service here
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 3));

    // Check if we have result in controller (if logic was moved there)
    // or just mock it for now as per "Clone... Reuse logic"
    // Since I haven't updated the service yet, I'll simulate success or use the existing service if accessible

    // For now, assume success and use original image as placeholder if generation not hooked up
    setState(() {
      _isLoading = false;
      // _generatedImageUrl = ...
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: StudyAIColors.primary),
            const SizedBox(height: 16),
            Text('Generating your study space...', style: StudyAIText.body),
            Text('Applying style...', style: StudyAIText.bodySmall),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Text(_error!, style: StudyAIText.body.copyWith(color: StudyAIColors.danger)),
      );
    }

    final originalPath = widget.controller.selectedImagePath;

    return Column(
      children: [
        // Action Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Result', style: StudyAIText.h2),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),

        // Image Area
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (originalPath != null)
                Image.file(
                  File(originalPath),
                  fit: BoxFit.cover,
                  color: _isAfter ? Colors.black.withValues(alpha: 0.8) : null, // Darken if "After" to simulate change if no real image
                  colorBlendMode: _isAfter ? BlendMode.darken : BlendMode.dst,
                ),

              if (_isAfter)
                Center(child: Text('AI Generated Image Here', style: StudyAIText.h3)),

              // Compare Toggle
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: TapOrSwipeCompareToggle(
                    isAfter: _isAfter,
                    onToggle: () => setState(() => _isAfter = !_isAfter),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Notes Panel
        const ResultNotesPanel(),
      ],
    );
  }
}
