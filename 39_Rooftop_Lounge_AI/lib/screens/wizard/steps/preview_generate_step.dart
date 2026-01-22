import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/glass_card.dart';
import '../../../widgets/gradient_button.dart';
import '../../../widgets/loading_overlay.dart';
import '../../../widgets/error_toast.dart';
import '../../../widgets/premium_gate_dialog.dart';
import '../../../services/rooftop_result_storage.dart';
import '../../../services/rooftop_history_repository.dart';
import '../../../services/rooftop_prompt_builder.dart';
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
  String _generationStage = 'Preparing...';
  final RooftopResultStorage _storage = RooftopResultStorage();
  final RooftopHistoryRepository _history = RooftopHistoryRepository();
  final RooftopPromptBuilder _promptBuilder = RooftopPromptBuilder();
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
        },
      );
      return;
    }

    setState(() {
      _isGenerating = true;
      _generationStage = 'Preparing...';
    });

    try {
      final imagePath = widget.controller.selectedImagePath;
      if (imagePath == null) throw Exception('No image selected');

      setState(() => _generationStage = 'Loading image...');
      final File imageFile = File(imagePath);
      final Uint8List imageBytes = await imageFile.readAsBytes();

      setState(() => _generationStage = 'Building prompt...');
      final prompt = _promptBuilder.buildPrompt(widget.controller.config);

      final imageUrl = await _replicateService.generateExteriorRedesign(
        images: [imageBytes],
        prompt: prompt,
        onStageChanged: (stage) {
          if (mounted) setState(() => _generationStage = stage);
        },
      );

      if (imageUrl == null) throw Exception('Generation failed');

      setState(() => _generationStage = 'Downloading result...');
      final generatedBytes = await _replicateService.downloadBytes(imageUrl);
      if (generatedBytes == null) throw Exception('Failed to download generated image');

      setState(() => _generationStage = 'Saving image...');
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final savedPath = '${directory.path}/generated_$timestamp.jpg';
      final savedFile = File(savedPath);
      await savedFile.writeAsBytes(generatedBytes);

      final resultData = ImageResultData(
        generatedImagePath: savedPath,
        prompt: prompt,
        generatedAt: DateTime.now(),
        modelVersion: 'nano-banana',
        status: GenerationStatus.completed,
      );
      widget.controller.setResultData(resultData);

      if (mounted) {
        await _premiumGate.incrementGenerationCount();
        await _ensureSaved();
        widget.controller.nextStep();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
          _generationStage = 'Preparing...';
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
        final selections = widget.controller.styleSelections;

        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                   Text(
                     'Ready to Transform',
                     style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                       fontFamily: 'DM Serif Display',
                       color: DesignTokens.ink0
                     )
                   ),
                   const SizedBox(height: 24),
                   if (hasImage) _buildPreview(widget.controller.selectedImagePath!),
                   const SizedBox(height: 24),
                   _buildSummary(selections),
                   const SizedBox(height: 32),
                   GradientButton(
                     label: 'Generate Rooftop',
                     icon: Icons.auto_awesome,
                     size: ButtonSize.large,
                     isLoading: _isGenerating,
                     onPressed: _isGenerating ? null : _generateRedesign,
                   ),
                   const SizedBox(height: 16),
                   const Text(
                     'Estimated time: 30-60 seconds',
                     style: TextStyle(color: DesignTokens.ink1, fontSize: 12),
                   ),
                ],
              ),
            ),
            if (_isGenerating)
               Positioned.fill(
                 child: Container(
                   color: Colors.black87,
                   child: Center(child: Column(
                     mainAxisSize: MainAxisSize.min,
                     children: [
                       const CircularProgressIndicator(color: DesignTokens.primary),
                       const SizedBox(height: 16),
                       Text(_generationStage, style: const TextStyle(color: DesignTokens.ink0)),
                     ],
                   )),
                 ),
               ),
          ],
        );
      },
    );
  }

  Widget _buildPreview(String path) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(DesignTokens.radiusM),
      child: Image.file(File(path), height: 200, width: double.infinity, fit: BoxFit.cover),
    );
  }

  Widget _buildSummary(Map<String, String> selections) {
    return GlassCard(
      child: Column(
        children: selections.entries.map((e) => ListTile(
          visualDensity: VisualDensity.compact,
          title: Text(e.key, style: const TextStyle(color: DesignTokens.ink1, fontSize: 12)),
          subtitle: Text(e.value, style: const TextStyle(color: DesignTokens.ink0, fontWeight: FontWeight.bold)),
          leading: const Icon(Icons.check_circle, color: DesignTokens.success, size: 16),
        )).toList(),
      ),
    );
  }
}
