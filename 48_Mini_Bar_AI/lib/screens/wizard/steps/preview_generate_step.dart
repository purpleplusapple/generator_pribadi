// lib/screens/wizard/steps/preview_generate_step.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../theme/mini_bar_theme.dart';
import '../../../../theme/design_tokens.dart';
import '../../../../widgets/loading_overlay.dart';
import '../../../../widgets/premium_gate_dialog.dart';
import '../../../../widgets/error_toast.dart';
import '../../../../services/mini_bar_result_storage.dart';
import '../../../../services/mini_bar_prompt_builder.dart';
import '../../../../services/replicate_nano_banana_service_multi.dart';
import '../../../../services/premium_gate_service.dart';
import '../../../../model/image_result_data.dart';
import '../../../../src/mypaywall.dart';
import '../wizard_controller.dart';

class PreviewGenerateStep extends StatefulWidget {
  final WizardController controller;
  const PreviewGenerateStep({super.key, required this.controller});

  @override
  State<PreviewGenerateStep> createState() => _PreviewGenerateStepState();
}

class _PreviewGenerateStepState extends State<PreviewGenerateStep> {
  bool _isGenerating = false;
  String _stage = 'Initializing...';
  final _storage = MiniBarResultStorage();
  final _promptBuilder = MiniBarPromptBuilder();
  final _replicate = ReplicateNanoBananaService();
  final _gate = PremiumGateService();

  Future<void> _generate() async {
    final canGen = await _gate.canGenerate();
    if (!canGen && mounted) {
      await PremiumGateDialog.show(context, onUpgrade: () async {
        Navigator.pop(context);
        await Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomCarPaywall()));
        if (await _gate.hasPremium() && mounted) ErrorToast.showSuccess(context, 'Premium Active');
      });
      return;
    }

    setState(() { _isGenerating = true; _stage = 'Preparing Cocktail...'; });

    try {
      final path = widget.controller.config.originalImagePath;
      if (path == null) throw Exception('No image');

      final bytes = await File(path).readAsBytes();

      setState(() => _stage = 'Mixing Ingredients (Building Prompt)...');
      final prompt = _promptBuilder.buildPrompt(widget.controller.config);

      setState(() => _stage = 'Pouring (Generating AI)...');
      final url = await _replicate.generateExteriorRedesign(
        images: [bytes], prompt: prompt,
        onStageChanged: (s) => setState(() => _stage = s),
      );

      if (url == null) throw Exception('Failed to generate');

      setState(() => _stage = 'Garnishing (Downloading)...');
      final genBytes = await _replicate.downloadBytes(url);
      if (genBytes == null) throw Exception('Download failed');

      final dir = await getApplicationDocumentsDirectory();
      final savedPath = '${dir.path}/minibar_${DateTime.now().millisecondsSinceEpoch}.jpg';
      await File(savedPath).writeAsBytes(genBytes);

      final result = ImageResultData(
        generatedImagePath: savedPath,
        prompt: prompt,
        generatedAt: DateTime.now(),
        modelVersion: 'nano-banana',
        status: GenerationStatus.completed,
      );

      widget.controller.setResult(result);
      await _gate.incrementGenerationCount();
      await _storage.saveResult(widget.controller.config);

      if (mounted) widget.controller.nextStep();

    } catch (e) {
      if (mounted) ErrorToast.show(context, 'Error: $e');
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.auto_fix_high, size: 48, color: MiniBarColors.primary),
            const SizedBox(height: 24),
            Text('Ready to Pour?', style: MiniBarText.h2),
            const SizedBox(height: 8),
            Text('We will design your mini bar based on your moodboard.', textAlign: TextAlign.center, style: MiniBarText.body),
            const SizedBox(height: 48),
            Center(
              child: ElevatedButton(
                onPressed: _isGenerating ? null : _generate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: MiniBarColors.primary,
                  foregroundColor: MiniBarColors.bg0,
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
                  textStyle: MiniBarText.h4,
                ),
                child: const Text('Generate Design'),
              ),
            ),
          ],
        ),
        if (_isGenerating) LoadingOverlay(isVisible: true, message: _stage),
      ],
    );
  }
}
