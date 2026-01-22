import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../../theme/clinic_theme.dart';
import '../../../widgets/clinical_card.dart';
import '../../../widgets/primary_button.dart';
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
  final LaundryResultStorage _storage = LaundryResultStorage();
  final LaundryHistoryRepository _history = LaundryHistoryRepository();
  final LaundryPromptBuilder _promptBuilder = LaundryPromptBuilder();
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
            ErrorToast.showSuccess(
              context,
              'Premium activated! You now have unlimited generations.',
            );
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

      setState(() => _generationStage = 'Analyzing room structure...');
      final prompt = _promptBuilder.buildPrompt(widget.controller.config);

      final imageUrl = await _replicateService.generateExteriorRedesign(
        images: [imageBytes],
        prompt: prompt,
        onStageChanged: (stage) {
          if (mounted) setState(() => _generationStage = stage);
        },
      );

      if (imageUrl == null) throw Exception('Generation failed');

      setState(() => _generationStage = 'Downloading high-res render...');
      final generatedBytes = await _replicateService.downloadBytes(imageUrl);
      if (generatedBytes == null) throw Exception('Failed to download image');

      setState(() => _generationStage = 'Finalizing...');
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
        ErrorToast.showSuccess(context, 'Clinic Design Generated!');
        if (mounted) widget.controller.nextStep();
      }
    } catch (e) {
      debugPrint('Generation error: $e');
      if (mounted) {
        ErrorToast.show(context, 'Generation failed. Please try again.');
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
        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(ClinicSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Analysis Complete', style: ClinicText.h2, textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Text(
                    'We are ready to generate your clinic design.',
                    style: ClinicText.body.copyWith(color: ClinicColors.ink2),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: ClinicSpacing.xl),

                  if (widget.controller.selectedImagePath != null)
                     _buildPreviewCard(),

                  const SizedBox(height: ClinicSpacing.xl),

                  PrimaryButton(
                    label: 'Generate Clinic Design',
                    icon: Icons.auto_awesome,
                    size: ButtonSize.large,
                    onPressed: _isGenerating ? null : _generateRedesign,
                    isLoading: _isGenerating,
                  ),

                  const SizedBox(height: ClinicSpacing.md),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.timer_outlined, size: 16, color: ClinicColors.ink2),
                      const SizedBox(width: 4),
                      Text('Est. time: 30s', style: ClinicText.caption),
                    ],
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

  Widget _buildPreviewCard() {
    return ClinicalCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: Image.file(
              File(widget.controller.selectedImagePath!),
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(ClinicSpacing.base),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: ClinicColors.success),
                const SizedBox(width: 8),
                Expanded(child: Text('Input Verified', style: ClinicText.bodySemiBold)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: ClinicColors.primarySoft,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text('READY', style: ClinicText.small.copyWith(color: ClinicColors.primary, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
