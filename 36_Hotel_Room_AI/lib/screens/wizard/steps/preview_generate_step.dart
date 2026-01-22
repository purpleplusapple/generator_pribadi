// lib/screens/wizard/steps/preview_generate_step.dart
// Preview/Generate step
// Option A: Boutique Linen

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../../theme/hotel_room_ai_theme.dart';
import '../../../widgets/loading_overlay.dart';
import '../../../widgets/error_toast.dart';
import '../../../widgets/premium_gate_dialog.dart';
import '../../../services/hotel_result_storage.dart';
import '../../../services/hotel_history_repository.dart';
import '../../../services/hotel_prompt_builder.dart';
import '../../../services/replicate_nano_banana_service_multi.dart';
import '../../../services/premium_gate_service.dart';
import '../../../model/image_result_data.dart';
import '../../../src/hotel_paywall.dart';
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
  String _generationStage = 'Preparing studio...';

  final HotelResultStorage _storage = HotelResultStorage();
  final HotelHistoryRepository _history = HotelHistoryRepository();
  final HotelPromptBuilder _promptBuilder = HotelPromptBuilder();
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
              builder: (context) => const HotelPaywall(),
              fullscreenDialog: true,
            ),
          );
          final hasPremium = await _premiumGate.hasPremium();
          if (hasPremium && mounted) {
            ErrorToast.showSuccess(context, 'Premium activated!');
          }
        },
      );
      return;
    }

    setState(() {
      _isGenerating = true;
      _generationStage = 'Calibrating design engine...';
    });

    try {
      final imagePath = widget.controller.selectedImagePath;
      if (imagePath == null) throw Exception('No image selected');

      setState(() => _generationStage = 'Analyzing room geometry...');
      final File imageFile = File(imagePath);
      final Uint8List imageBytes = await imageFile.readAsBytes();

      setState(() => _generationStage = 'Applying luxury textures...');
      final prompt = _promptBuilder.buildPrompt(widget.controller.config);

      final imageUrl = await _replicateService.generateExteriorRedesign(
        images: [imageBytes],
        prompt: prompt,
        onStageChanged: (stage) {
          if (mounted) setState(() => _generationStage = stage);
        },
      );

      if (imageUrl == null) throw Exception('Generation failed');

      setState(() => _generationStage = 'Rendering final image...');
      final generatedBytes = await _replicateService.downloadBytes(imageUrl);
      if (generatedBytes == null) throw Exception('Download failed');

      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final savedPath = '${directory.path}/generated_$timestamp.jpg';
      final savedFile = File(savedPath);
      await savedFile.writeAsBytes(generatedBytes);

      final resultData = ImageResultData(
        generatedImagePath: savedPath,
        prompt: prompt,
        generatedAt: DateTime.now(),
        modelVersion: 'hotel-v1',
        status: GenerationStatus.completed,
      );
      widget.controller.setResultData(resultData);

      if (mounted) {
        await _premiumGate.incrementGenerationCount();
        await _ensureSaved();
        ErrorToast.showSuccess(context, 'Room designed successfully!');
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) widget.controller.nextStep();
      }
    } catch (e) {
      if (mounted) ErrorToast.show(context, 'Generation failed. Try again.');
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

        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(HotelAISpacing.lg),
              child: Column(
                children: [
                  Text('Ready to Design', style: HotelAIText.h2),
                  const SizedBox(height: 8),
                  Text(
                    'We have everything needed to create your hotel suite.',
                    style: HotelAIText.body.copyWith(color: HotelAIColors.muted),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  if (hasImage)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: HotelAIRadii.mediumRadius,
                        boxShadow: HotelAIShadows.floating,
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10), // Inner radius
                        child: Image.file(
                          File(widget.controller.selectedImagePath!),
                          height: 240,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                  const SizedBox(height: 32),

                  _SummaryRow(
                    icon: Icons.style,
                    label: "Selected Style",
                    value: widget.controller.styleSelections['Interior Style'] ?? 'Modern',
                  ),
                  const SizedBox(height: 12),
                  const _SummaryRow(
                    icon: Icons.photo_size_select_large,
                    label: "Quality",
                    value: "Premium HD",
                  ),

                  const SizedBox(height: 48),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isGenerating ? null : _generateRedesign,
                      icon: const Icon(Icons.auto_awesome),
                      label: const Text("Generate Design"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Estimated time: 30 seconds",
                    style: HotelAIText.caption,
                  ),
                ],
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

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _SummaryRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HotelAIColors.bg1,
        borderRadius: HotelAIRadii.mediumRadius,
        boxShadow: HotelAIShadows.soft,
      ),
      child: Row(
        children: [
          Icon(icon, color: HotelAIColors.primary),
          const SizedBox(width: 16),
          Text(label, style: HotelAIText.bodyMedium),
          const Spacer(),
          Text(value, style: HotelAIText.body.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
