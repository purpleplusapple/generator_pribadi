// lib/screens/wizard/steps/preview_generate_step.dart
// Generate step with Boutique Styling

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../../theme/boutique_theme.dart';
import '../../../widgets/glass_card.dart';
import '../../../widgets/loading_overlay.dart';
import '../../../widgets/error_toast.dart';
import '../../../widgets/premium_gate_dialog.dart';
import '../../../services/shoe_result_storage.dart';
import '../../../services/laundry_history_repository.dart';
import '../../../services/laundry_prompt_builder.dart';
import '../../../services/replicate_nano_banana_service_multi.dart';
import '../../../services/premium_gate_service.dart';
import '../../../model/image_result_data.dart';
import '../../../src/mypaywall.dart';
import '../wizard_controller.dart';

class PreviewGenerateStep extends StatefulWidget {
  const PreviewGenerateStep({super.key, required this.controller});
  final WizardController controller;

  @override
  State<PreviewGenerateStep> createState() => _PreviewGenerateStepState();
}

class _PreviewGenerateStepState extends State<PreviewGenerateStep> {
  bool _isGenerating = false;
  String _generationStage = 'Curating...';
  final LaundryResultStorage _storage = LaundryResultStorage();
  final LaundryHistoryRepository _history = LaundryHistoryRepository();
  final LaundryPromptBuilder _promptBuilder = LaundryPromptBuilder();
  final ReplicateNanoBananaService _replicateService = ReplicateNanoBananaService();
  final PremiumGateService _premiumGate = PremiumGateService();

  Future<void> _generate() async {
     final canGenerate = await _premiumGate.canGenerate();
    if (!canGenerate && mounted) {
      await PremiumGateDialog.show(context, onUpgrade: () async {
          Navigator.pop(context);
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomCarPaywall(), fullscreenDialog: true));
      });
      return;
    }

    setState(() { _isGenerating = true; _generationStage = "Curating boutique elements..."; });

    try {
      final imagePath = widget.controller.selectedImagePath!;
      final File imageFile = File(imagePath);
      final Uint8List imageBytes = await imageFile.readAsBytes();
      final prompt = _promptBuilder.buildPrompt(widget.controller.config);

      final imageUrl = await _replicateService.generateExteriorRedesign(
        images: [imageBytes],
        prompt: prompt,
        onStageChanged: (stage) => mounted ? setState(() => _generationStage = stage) : null,
      );

      if (imageUrl == null) throw Exception("Generation failed");

      setState(() => _generationStage = "Finalizing snapshot...");
      final generatedBytes = await _replicateService.downloadBytes(imageUrl);

      final directory = await getApplicationDocumentsDirectory();
      final savedPath = '${directory.path}/boutique_${DateTime.now().millisecondsSinceEpoch}.jpg';
      await File(savedPath).writeAsBytes(generatedBytes!);

      final resultData = ImageResultData(
        generatedImagePath: savedPath,
        prompt: prompt,
        generatedAt: DateTime.now(),
        modelVersion: 'boutique-v1',
        status: GenerationStatus.completed,
      );
      widget.controller.setResultData(resultData);

      if (mounted) {
        await _premiumGate.incrementGenerationCount();
        await _storage.saveResult(widget.controller.config);
        await _history.addToHistory(await _storage.saveResult(widget.controller.config)); // Quick fix to get ID, assumes saveResult returns ID
        widget.controller.nextStep();
      }
    } catch (e) {
      if (mounted) ErrorToast.show(context, "Failed: $e");
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = widget.controller.selectedImagePath != null;

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Ready to Redesign", style: BoutiqueText.h2),
              const SizedBox(height: 24),

              if (hasImage)
                 ClipRRect(
                   borderRadius: BorderRadius.circular(16),
                   child: Image.file(File(widget.controller.selectedImagePath!), height: 200, width: double.infinity, fit: BoxFit.cover),
                 ),

              const SizedBox(height: 24),

              // Token Cost Chip
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: BoutiqueColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: BoutiqueColors.primary),
                  ),
                  child: Text("Cost: 1 Token", style: BoutiqueText.button.copyWith(color: BoutiqueColors.primary)),
                ),
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _isGenerating ? null : _generate,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                ),
                child: _isGenerating
                  ? const CircularProgressIndicator(color: BoutiqueColors.bg0)
                  : const Text("GENERATE BOUTIQUE"),
              ),

              const SizedBox(height: 16),
              Center(child: Text("Estimated time: ~30 seconds", style: BoutiqueText.caption)),
            ],
          ),
        ),
        LoadingOverlay(isVisible: _isGenerating, message: _generationStage),
      ],
    );
  }
}
