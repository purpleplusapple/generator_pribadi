import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../../theme/apartment_tokens.dart';
import '../../../widgets/gradient_button.dart';
import '../../../widgets/premium_gate_dialog.dart';
import '../../../services/apartment_result_storage.dart';
import '../../../services/apartment_history_repository.dart';
import '../../../services/apartment_prompt_builder.dart';
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
  final ApartmentResultStorage _storage = ApartmentResultStorage();
  final ApartmentHistoryRepository _history = ApartmentHistoryRepository();
  final ApartmentPromptBuilder _promptBuilder = ApartmentPromptBuilder();
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

      setState(() => _generationStage = 'Designing space...');
      final prompt = _promptBuilder.buildPrompt(widget.controller.config);

      // Using the existing service method (renamed or legacy)
      final imageUrl = await _replicateService.generateExteriorRedesign(
        images: [imageBytes],
        prompt: prompt,
        onStageChanged: (stage) {
          if (mounted) setState(() => _generationStage = stage);
        },
      );

      if (imageUrl == null) throw Exception('Generation failed');

      setState(() => _generationStage = 'Finalizing render...');
      final generatedBytes = await _replicateService.downloadBytes(imageUrl);
      if (generatedBytes == null) throw Exception('Failed to download generated image');

      setState(() => _generationStage = 'Saving project...');
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
              padding: const EdgeInsets.all(ApartmentTokens.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                   Text(
                     'Ready to Redesign',
                     style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                       color: ApartmentTokens.ink0,
                       fontWeight: FontWeight.bold,
                     )
                   ),
                   const SizedBox(height: 8),
                   Text(
                     'Review your choices before generating.',
                     style: TextStyle(color: ApartmentTokens.ink1),
                   ),
                   const SizedBox(height: 24),

                   if (hasImage) _buildPreview(widget.controller.selectedImagePath!),

                   const SizedBox(height: 24),
                   _buildSummary(selections),

                   const SizedBox(height: 32),

                   // CTA
                   SizedBox(
                     height: 56,
                     child: ElevatedButton(
                       onPressed: _isGenerating ? null : _generateRedesign,
                       style: ElevatedButton.styleFrom(
                         backgroundColor: ApartmentTokens.primary,
                         foregroundColor: Colors.white,
                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ApartmentTokens.rMax)),
                       ),
                       child: _isGenerating
                         ? const CircularProgressIndicator(color: Colors.white)
                         : const Text('Generate Studio', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                     ),
                   ),

                   const SizedBox(height: 16),
                   const Center(
                     child: Text(
                       'Estimated time: ~30 seconds',
                       style: TextStyle(color: ApartmentTokens.muted, fontSize: 12),
                     ),
                   ),
                ],
              ),
            ),

            // Full screen loader override
            if (_isGenerating)
               Positioned.fill(
                 child: Container(
                   color: ApartmentTokens.bg0.withOpacity(0.95),
                   child: Center(child: Column(
                     mainAxisSize: MainAxisSize.min,
                     children: [
                       const CircularProgressIndicator(color: ApartmentTokens.primary),
                       const SizedBox(height: 24),
                       Text(
                         _generationStage,
                         style: const TextStyle(
                           color: ApartmentTokens.ink0,
                           fontSize: 18,
                           fontWeight: FontWeight.bold
                         ),
                       ),
                       const SizedBox(height: 8),
                       const Text(
                         'AI is analyzing your room structure...',
                         style: TextStyle(color: ApartmentTokens.ink1),
                       ),
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ApartmentTokens.r16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 12, offset: const Offset(0,4)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ApartmentTokens.r16),
        child: Image.file(File(path), height: 250, width: double.infinity, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildSummary(Map<String, String> selections) {
    return Container(
      padding: const EdgeInsets.all(ApartmentTokens.s16),
      decoration: BoxDecoration(
        color: ApartmentTokens.surface,
        borderRadius: BorderRadius.circular(ApartmentTokens.r16),
        border: Border.all(color: ApartmentTokens.line),
      ),
      child: Column(
        children: selections.entries.map((e) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: ApartmentTokens.success, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(e.key, style: const TextStyle(color: ApartmentTokens.muted, fontSize: 12)),
                    Text(e.value, style: const TextStyle(color: ApartmentTokens.ink0, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        )).toList(),
      ),
    );
  }
}
