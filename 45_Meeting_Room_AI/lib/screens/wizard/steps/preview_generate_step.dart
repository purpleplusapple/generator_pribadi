// lib/screens/wizard/steps/preview_generate_step.dart
// Preview/Generate step with final summary and generation trigger

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../../theme/meeting_room_theme.dart';
import '../../../theme/meeting_tokens.dart';
import '../../../widgets/glass_card.dart';
import '../../../widgets/gradient_button.dart';
import '../../../widgets/loading_overlay.dart';
import '../../../widgets/error_toast.dart';
import '../../../widgets/premium_gate_dialog.dart';
import '../../../services/meeting_result_storage.dart';
import '../../../services/meeting_history_repository.dart';
import '../../../services/meeting_prompt_builder.dart';
import '../../../services/replicate_nano_banana_service_multi.dart';
import '../../../services/premium_gate_service.dart';
import '../../../model/image_result_data.dart';
import '../../../src/mypaywall.dart';
import '../wizard_controller.dart';

class PreviewGenerateStep extends StatefulWidget {
  const PreviewGenerateStep({
    super.key,
    required this.controller,
  });

  final WizardController controller;

  @override
  State<PreviewGenerateStep> createState() => _PreviewGenerateStepState();
}

class _PreviewGenerateStepState extends State<PreviewGenerateStep> {
  bool _isGenerating = false;
  String _generationStage = 'Initializing Protocol...';
  final MeetingResultStorage _storage = MeetingResultStorage();
  final MeetingHistoryRepository _history = MeetingHistoryRepository();
  final MeetingPromptBuilder _promptBuilder = MeetingPromptBuilder();
  final ReplicateNanoBananaService _replicateService = ReplicateNanoBananaService();
  final PremiumGateService _premiumGate = PremiumGateService();

  @override
  void dispose() {
    _replicateService.dispose();
    super.dispose();
  }

  Future<void> _ensureSaved() async {
    try {
      final id = await _storage.saveResult(widget.controller.config);
      await _history.addToHistory(id);
    } catch (e) {
      debugPrint('Failed to save result: $e');
    }
  }

  Future<void> _generateRedesign() async {
    // 1. Check quota
    final canGenerate = await _premiumGate.canGenerate();
    if (!canGenerate && mounted) {
      await PremiumGateDialog.show(
        context,
        onUpgrade: () async {
          Navigator.of(context).pop();
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CustomCarPaywall(),
              fullscreenDialog: true,
            ),
          );
          final hasPremium = await _premiumGate.hasPremium();
          if (hasPremium && mounted) {
            ErrorToast.showSuccess(context, 'Access Granted.');
          }
        },
      );
      return;
    }

    setState(() {
      _isGenerating = true;
      _generationStage = 'Uploading Blueprint...';
    });

    try {
      final imagePath = widget.controller.selectedImagePath;
      if (imagePath == null) throw Exception('No blueprint selected');

      final File imageFile = File(imagePath);
      final Uint8List imageBytes = await imageFile.readAsBytes();

      setState(() => _generationStage = 'Analyzing Architecture...');
      final prompt = _promptBuilder.buildPrompt(widget.controller.config);
      debugPrint('Prompt: $prompt');

      setState(() => _generationStage = 'Rendering Meeting Room...');
      final imageUrl = await _replicateService.generateExteriorRedesign(
        images: [imageBytes],
        prompt: prompt,
        onStageChanged: (stage) {
          if (mounted) setState(() => _generationStage = stage);
        },
      );

      if (imageUrl == null) throw Exception('Render failed');

      setState(() => _generationStage = 'Downloading Render...');
      final generatedBytes = await _replicateService.downloadBytes(imageUrl);
      if (generatedBytes == null) throw Exception('Download failed');

      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final savedPath = '${directory.path}/meeting_$timestamp.jpg';
      await File(savedPath).writeAsBytes(generatedBytes);

      final resultData = ImageResultData(
        generatedImagePath: savedPath,
        prompt: prompt,
        generatedAt: DateTime.now(),
        modelVersion: 'nano-banana', // Or whatever model is used
        status: GenerationStatus.completed,
      );
      widget.controller.setResultData(resultData);

      if (mounted) {
        await _premiumGate.incrementGenerationCount();
        await _ensureSaved();

        ErrorToast.showSuccess(context, 'Render Complete.');
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) widget.controller.nextStep();
      }
    } catch (e) {
      if (mounted) ErrorToast.show(context, 'Generation Error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
          _generationStage = 'Ready';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final hasImage = widget.controller.selectedImagePath != null;
        final hasStyle = widget.controller.styleSelection != null;

        return Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: MeetingTokens.surface,
                        shape: BoxShape.circle,
                        border: Border.all(color: MeetingTokens.accent, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: MeetingTokens.accent.withValues(alpha: 0.3),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(Icons.bolt_rounded, size: 48, color: MeetingTokens.accent),
                    ),
                    const SizedBox(height: 32),
                    Text('INITIATE RENDER', style: MeetingRoomText.h2),
                    const SizedBox(height: 16),
                    Text(
                      'AI Model ready to process inputs.\nReview configuration before executing.',
                      textAlign: TextAlign.center,
                      style: MeetingRoomText.body.copyWith(color: MeetingTokens.muted),
                    ),
                    const SizedBox(height: 48),

                    if (hasImage && hasStyle)
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: GradientButton(
                          label: 'GENERATE ROOM',
                          icon: Icons.play_arrow_rounded,
                          onPressed: _isGenerating ? null : _generateRedesign,
                        ),
                      )
                    else
                      Text('Incomplete Configuration', style: TextStyle(color: MeetingTokens.danger)),
                  ],
                ),
              ),
            ),

            LoadingOverlay(
              isVisible: _isGenerating,
              message: _generationStage,
            ),
          ],
        );
      },
    );
  }
}
