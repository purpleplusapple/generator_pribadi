// lib/screens/wizard/steps/preview_generate_step.dart
// Preview/Generate step with final summary and generation trigger

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../../theme/camper_theme.dart';
import '../../../widgets/glass_card.dart';
import '../../../widgets/gradient_button.dart';
import '../../../widgets/loading_overlay.dart';
import '../../../widgets/error_toast.dart';
import '../../../widgets/premium_gate_dialog.dart';
import '../../../services/camper_storage.dart';
import '../../../services/camper_history_repository.dart';
import '../../../services/camper_prompt_builder.dart';
import '../../../services/replicate_nano_banana_service_multi.dart';
import '../../../services/premium_gate_service.dart';
import '../../../model/image_result_data.dart';
import '../../../src/mypaywall.dart';
import '../wizard_controller.dart';
import '../../../data/camper_styles_data.dart';

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
  String _generationStage = 'Preparing...';
  final CamperResultStorage _storage = CamperResultStorage();
  final CamperHistoryRepository _history = CamperHistoryRepository();
  // Prompt builder is static now
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
      _generationStage = 'Preparing...';
    });

    try {
      final imagePath = widget.controller.selectedImagePath;
      if (imagePath == null) throw Exception('No image selected');

      setState(() => _generationStage = 'Loading image...');
      final File imageFile = File(imagePath);
      final Uint8List imageBytes = await imageFile.readAsBytes();

      setState(() => _generationStage = 'Building prompt...');
      final prompt = CamperPromptBuilder.buildPrompt(widget.controller.config);
      final negPrompt = CamperPromptBuilder.buildNegativePrompt(widget.controller.config);
      debugPrint('Prompt: $prompt');

      final imageUrl = await _replicateService.generateExteriorRedesign(
        images: [imageBytes],
        prompt: prompt,
        negativePrompt: negPrompt,
        onStageChanged: (stage) {
          if (mounted) setState(() => _generationStage = stage);
        },
      );

      if (imageUrl == null) throw Exception('Generation failed - no URL');

      setState(() => _generationStage = 'Downloading result...');
      final generatedBytes = await _replicateService.downloadBytes(imageUrl);
      if (generatedBytes == null) throw Exception('Failed to download image');

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
        ErrorToast.showSuccess(context, 'Van redesigned successfully!');
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          widget.controller.nextStep();
        }
      }
    } catch (e) {
      debugPrint('Generation error: $e');
      if (mounted) {
        ErrorToast.show(context, 'Generation failed. Try again.');
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
        final styleId = widget.controller.selectedStyleId;
        final hasNotes = widget.controller.reviewNotes?.isNotEmpty ?? false;

        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(CamperAISpacing.base),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: CamperAISpacing.md),
                  Text('Review & Generate', style: CamperAIText.h2, textAlign: TextAlign.center),
                  const SizedBox(height: CamperAISpacing.xs),
                  Text('Confirm your van conversion plan',
                    style: CamperAIText.body.copyWith(color: CamperAIColors.muted), textAlign: TextAlign.center),

                  const SizedBox(height: CamperAISpacing.xl),

                  if (hasImage) _buildPhotoPreview(),
                  if (hasImage) const SizedBox(height: CamperAISpacing.lg),

                  if (styleId != null) _buildStyleSummary(styleId),

                  const SizedBox(height: CamperAISpacing.md),
                  if (hasNotes) _buildNotesCard(),

                  const SizedBox(height: CamperAISpacing.xxl),

                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(CamperAIRadii.button),
                      boxShadow: CamperAIShadows.goldGlow(opacity: 0.3),
                    ),
                    child: GradientButton(
                      label: 'Generate My Van',
                      size: ButtonSize.large,
                      icon: Icons.auto_awesome_rounded,
                      onPressed: _isGenerating ? null : _generateRedesign,
                    ),
                  ),
                ],
              ),
            ),
            LoadingOverlay(isVisible: _isGenerating, message: _generationStage),
          ],
        );
      },
    );
  }

  Widget _buildPhotoPreview() {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: CamperAIRadii.cardRadius,
        child: Image.file(
          File(widget.controller.selectedImagePath!),
          fit: BoxFit.cover,
          width: double.infinity,
          height: 220,
        ),
      ),
    );
  }

  Widget _buildStyleSummary(String styleId) {
    final style = CamperStylesData.styles.firstWhere((s) => s.id == styleId, orElse: () => CamperStylesData.styles.first);
    final params = widget.controller.styleParams;

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.palette, color: CamperAIColors.leatherTan),
              const SizedBox(width: 8),
              Text(style.name, style: CamperAIText.h3),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: params.entries.take(6).map((e) {
              return Chip(
                label: Text("${e.key}: ${e.value}"),
                backgroundColor: CamperAIColors.surface2,
                labelStyle: CamperAIText.caption,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesCard() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Notes", style: CamperAIText.h3),
          const SizedBox(height: 8),
          Text(widget.controller.reviewNotes ?? "", style: CamperAIText.body),
        ],
      ),
    );
  }
}
