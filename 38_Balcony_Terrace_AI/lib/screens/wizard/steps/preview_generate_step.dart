// lib/screens/wizard/steps/preview_generate_step.dart
// Preview/Generate step with final summary and generation trigger

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../../theme/terrace_theme.dart';
import '../../../widgets/glass_card.dart';
import '../../../widgets/gradient_button.dart';
import '../../../widgets/loading_overlay.dart';
import '../../../widgets/error_toast.dart';
import '../../../widgets/premium_gate_dialog.dart';
import '../../../services/terrace_result_storage.dart';
import '../../../services/terrace_history_repository.dart';
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
  final TerraceResultStorage _storage = TerraceResultStorage();
  final TerraceHistoryRepository _history = TerraceHistoryRepository();
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
      // Save the current config to storage
      final id = await _storage.saveResult(widget.controller.config);
      // Add to history
      await _history.addToHistory(id);
    } catch (e) {
      // Silent fail - don't block user flow
      debugPrint('Failed to save result: $e');
    }
  }

  Future<void> _generateRedesign() async {
    // 1. Check quota before proceeding
    final canGenerate = await _premiumGate.canGenerate();
    if (!canGenerate && mounted) {
      // Show premium gate dialog
      await PremiumGateDialog.show(
        context,
        onUpgrade: () async {
          Navigator.of(context).pop(); // Close gate dialog

          // Open paywall
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CustomCarPaywall(),
              fullscreenDialog: true,
            ),
          );

          // After paywall closes, check if user purchased
          final hasPremium = await _premiumGate.hasPremium();
          if (hasPremium && mounted) {
            // User is now premium, they can generate
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
      // 2. Get the original image path
      final imagePath = widget.controller.selectedImagePath;
      if (imagePath == null) {
        throw Exception('No image selected');
      }

      // 3. Read image bytes
      setState(() => _generationStage = 'Loading image...');
      final File imageFile = File(imagePath);
      final Uint8List imageBytes = await imageFile.readAsBytes();

      // 4. Build prompt from selections
      setState(() => _generationStage = 'Building prompt...');
      final prompt = _promptBuilder.buildPrompt(widget.controller.config);
      debugPrint('Generated prompt: $prompt');

      // 5. Call Replicate API
      final imageUrl = await _replicateService.generateExteriorRedesign(
        images: [imageBytes],
        prompt: prompt,
        onStageChanged: (stage) {
          if (mounted) {
            setState(() => _generationStage = stage);
          }
        },
      );

      if (imageUrl == null) {
        throw Exception('Generation failed - no image URL returned');
      }

      // 5. Download generated image
      setState(() => _generationStage = 'Downloading result...');
      final generatedBytes = await _replicateService.downloadBytes(imageUrl);
      if (generatedBytes == null) {
        throw Exception('Failed to download generated image');
      }

      // 6. Save generated image to local storage
      setState(() => _generationStage = 'Saving image...');
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final savedPath = '${directory.path}/generated_$timestamp.jpg';
      final savedFile = File(savedPath);
      await savedFile.writeAsBytes(generatedBytes);

      // 7. Update controller with result data
      final resultData = ImageResultData(
        generatedImagePath: savedPath,
        prompt: prompt,
        generatedAt: DateTime.now(),
        modelVersion: 'nano-banana',
        status: GenerationStatus.completed,
      );
      widget.controller.setResultData(resultData);

      if (mounted) {
        // Increment generation counter (for free users)
        await _premiumGate.incrementGenerationCount();

        // Save result to history
        await _ensureSaved();

        // Success: Navigate to result step
        ErrorToast.showSuccess(context, 'Redesign generated successfully!');
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          widget.controller.nextStep();
        }
      }
    } on UnsafePromptException catch (e) {
      if (mounted) {
        ErrorToast.show(context, e.message);
      }
    } on NetworkException catch (e) {
      if (mounted) {
        ErrorToast.show(context, e.message);
      }
    } on GenerationTimeoutException catch (e) {
      if (mounted) {
        ErrorToast.show(context, e.message);
      }
    } catch (e) {
      debugPrint('Generation error: $e');
      if (mounted) {
        ErrorToast.show(
          context,
          'Generation failed. Please try again.',
        );
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
        final selectionsCount = widget.controller.styleSelections.length;
        final hasNotes = widget.controller.reviewNotes?.isNotEmpty ?? false;

        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(ShoeAISpacing.base),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: ShoeAISpacing.md),

                  // Title
                  Text(
                    'Ready to Transform!',
                    style: ShoeAIText.h2,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: ShoeAISpacing.xs),

                  // Subtitle
                  Text(
                    'Your AI-powered shoe room transformation is ready',
                    style: ShoeAIText.body.copyWith(
                      color: ShoeAIColors.canvasWhite.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: ShoeAISpacing.xl),

                  // Photo Preview (NEW)
                  if (hasImage) _buildPhotoPreview(),

                  if (hasImage) const SizedBox(height: ShoeAISpacing.lg),

                  // Style Selections Card (Redesigned with chips)
                  if (selectionsCount > 0) _buildStyleSelectionsCard(),

                  if (selectionsCount > 0) const SizedBox(height: ShoeAISpacing.md),

                  // Configuration Summary Grid (NEW layout)
                  _buildConfigurationCard(
                    hasImage: hasImage,
                    selectionsCount: selectionsCount,
                    hasNotes: hasNotes,
                  ),

                  if (hasNotes) const SizedBox(height: ShoeAISpacing.md),

                  // Notes Card (if any)
                  if (hasNotes) _buildNotesCard(),

                  const SizedBox(height: ShoeAISpacing.xxl),

                  // Enhanced Generate Button
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(ShoeAIRadii.button),
                      boxShadow: ShoeAIShadows.goldGlow(opacity: 0.3),
                    ),
                    child: GradientButton(
                      label: 'Transform My Shoe Room',
                      size: ButtonSize.large,
                      icon: Icons.auto_awesome_rounded,
                      onPressed: _isGenerating ? null : _generateRedesign,
                    ),
                  ),

                  const SizedBox(height: ShoeAISpacing.md),

                  // Info text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: ShoeAIColors.canvasWhite.withValues(alpha: 0.5),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Estimated time: 30-60 seconds',
                        style: ShoeAIText.caption.copyWith(
                          color: ShoeAIColors.canvasWhite.withValues(alpha: 0.5),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: ShoeAISpacing.xl),
                ],
              ),
            ),

            // Loading Overlay
            LoadingOverlay(
              isVisible: _isGenerating,
              message: _generationStage,
            ),
          ],
        );
      },
    );
  }

  // Photo Preview with overlay
  Widget _buildPhotoPreview() {
    final imagePath = widget.controller.selectedImagePath!;

    return GlassCard(
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: ShoeAIRadii.cardRadius,
            child: Image.file(
              File(imagePath),
              fit: BoxFit.cover,
              width: double.infinity,
              height: 220,
            ),
          ),

          // Top overlay badge
          Positioned(
            top: ShoeAISpacing.md,
            right: ShoeAISpacing.md,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: ShoeAISpacing.md,
                vertical: ShoeAISpacing.sm,
              ),
              decoration: BoxDecoration(
                gradient: ShoeAIGradients.primaryCta,
                borderRadius: BorderRadius.circular(ShoeAIRadii.chip),
                boxShadow: ShoeAIShadows.goldGlow(opacity: 0.4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.auto_awesome_rounded,
                    size: 16,
                    color: ShoeAIColors.soleBlack,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Ready to Transform',
                    style: ShoeAIText.small.copyWith(
                      color: ShoeAIColors.soleBlack,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Style Selections with horizontal chips
  Widget _buildStyleSelectionsCard() {
    final selections = widget.controller.styleSelections;

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.palette_rounded,
                color: ShoeAIColors.metallicGold,
                size: 20,
              ),
              const SizedBox(width: ShoeAISpacing.sm),
              Text(
                'Style Selections',
                style: ShoeAIText.h3.copyWith(fontSize: 16),
              ),
            ],
          ),

          const SizedBox(height: ShoeAISpacing.md),

          Wrap(
            spacing: ShoeAISpacing.sm,
            runSpacing: ShoeAISpacing.sm,
            children: selections.entries.map((entry) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: ShoeAISpacing.md,
                  vertical: ShoeAISpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: ShoeAIColors.metallicGold.withValues(alpha: 0.15),
                  border: Border.all(
                    color: ShoeAIColors.metallicGold.withValues(alpha: 0.3),
                  ),
                  borderRadius: BorderRadius.circular(ShoeAIRadii.chip),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getIconForCategory(entry.key),
                      size: 14,
                      color: ShoeAIColors.metallicGold,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      entry.value,
                      style: ShoeAIText.caption.copyWith(
                        color: ShoeAIColors.canvasWhite,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Configuration summary in grid layout
  Widget _buildConfigurationCard({
    required bool hasImage,
    required int selectionsCount,
    required bool hasNotes,
  }) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.checklist_rounded,
                color: ShoeAIColors.leatherTan,
                size: 20,
              ),
              const SizedBox(width: ShoeAISpacing.sm),
              Text(
                'Transformation Summary',
                style: ShoeAIText.h3.copyWith(fontSize: 16),
              ),
            ],
          ),

          const SizedBox(height: ShoeAISpacing.md),

          Row(
            children: [
              Expanded(
                child: _buildConfigItem(
                  icon: Icons.photo_camera_rounded,
                  label: 'Photo',
                  value: hasImage ? 'Uploaded' : 'Missing',
                  isComplete: hasImage,
                ),
              ),
              const SizedBox(width: ShoeAISpacing.sm),
              Expanded(
                child: _buildConfigItem(
                  icon: Icons.style_rounded,
                  label: 'Styles',
                  value: '$selectionsCount selected',
                  isComplete: selectionsCount >= 2,
                ),
              ),
            ],
          ),

          const SizedBox(height: ShoeAISpacing.sm),

          Row(
            children: [
              Expanded(
                child: _buildConfigItem(
                  icon: Icons.note_alt_rounded,
                  label: 'Notes',
                  value: hasNotes ? 'Added' : 'None',
                  isComplete: hasNotes,
                  isOptional: true,
                ),
              ),
              const SizedBox(width: ShoeAISpacing.sm),
              Expanded(
                child: _buildConfigItem(
                  icon: Icons.bolt_rounded,
                  label: 'AI Model',
                  value: 'Premium',
                  isComplete: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConfigItem({
    required IconData icon,
    required String label,
    required String value,
    required bool isComplete,
    bool isOptional = false,
  }) {
    final color = isComplete
        ? ShoeAIColors.success
        : isOptional
            ? ShoeAIColors.canvasWhite.withValues(alpha: 0.4)
            : ShoeAIColors.warning;

    return Container(
      padding: const EdgeInsets.all(ShoeAISpacing.md),
      decoration: BoxDecoration(
        color: ShoeAIColors.canvasWhite.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(ShoeAISpacing.md),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Icon(
                isComplete ? Icons.check_circle : Icons.circle_outlined,
                size: 14,
                color: color,
              ),
            ],
          ),
          const SizedBox(height: ShoeAISpacing.sm),
          Text(
            label,
            style: ShoeAIText.small.copyWith(
              color: ShoeAIColors.canvasWhite.withValues(alpha: 0.6),
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: ShoeAIText.caption.copyWith(
              color: ShoeAIColors.canvasWhite,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // Notes card with quote style
  Widget _buildNotesCard() {
    final notes = widget.controller.reviewNotes ?? '';

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.format_quote_rounded,
                color: ShoeAIColors.canvasWhite.withValues(alpha: 0.5),
                size: 20,
              ),
              const SizedBox(width: ShoeAISpacing.sm),
              Text(
                'Your Notes',
                style: ShoeAIText.h3.copyWith(fontSize: 16),
              ),
            ],
          ),

          const SizedBox(height: ShoeAISpacing.md),

          Container(
            padding: const EdgeInsets.all(ShoeAISpacing.md),
            decoration: BoxDecoration(
              color: ShoeAIColors.leatherTan.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ShoeAISpacing.md),
              border: Border.all(
                color: ShoeAIColors.leatherTan.withValues(alpha: 0.2),
              ),
            ),
            child: Text(
              notes,
              style: ShoeAIText.body.copyWith(
                fontStyle: FontStyle.italic,
                color: ShoeAIColors.canvasWhite.withValues(alpha: 0.9),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper to get icon for style category
  IconData _getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'closet type':
        return Icons.door_front_door_rounded;
      case 'storage style':
        return Icons.shelves;
      case 'lighting':
        return Icons.lightbulb_rounded;
      case 'color scheme':
        return Icons.palette_rounded;
      case 'material':
        return Icons.texture_rounded;
      default:
        return Icons.style_rounded;
    }
  }
}
