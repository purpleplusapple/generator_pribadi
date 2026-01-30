import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../model/beauty_config.dart';
import '../../model/image_result_data.dart';
import '../../services/beauty_salon_history_repository.dart';
import '../../services/beauty_salon_result_storage.dart';
import '../../services/replicate_nano_banana_service_multi.dart';
import '../../theme/beauty_theme.dart';
import '../../widgets/stepper/wizard_rail_stepper.dart';
import '../result/salon_reveal_page.dart';
import 'upload_studio_step.dart';
import 'style_moodboard_step.dart';

class BeautyWizardScreen extends StatefulWidget {
  const BeautyWizardScreen({super.key});

  @override
  State<BeautyWizardScreen> createState() => _BeautyWizardScreenState();
}

class _BeautyWizardScreenState extends State<BeautyWizardScreen> {
  int _currentStep = 0;
  BeautyAIConfig _config = BeautyAIConfig.empty();
  bool _isGenerating = false;
  String _generationStatus = 'Initializing...';

  final List<String> _stepTitles = ['Upload', 'Style', 'Generate'];
  final ReplicateNanoBananaService _service = ReplicateNanoBananaService();
  final BeautySalonResultStorage _storage = BeautySalonResultStorage();
  final BeautySalonHistoryRepository _historyRepo = BeautySalonHistoryRepository();

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    } else {
      _generate();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _generate() async {
    if (_config.originalImagePath == null) return;

    setState(() {
      _isGenerating = true;
      _generationStatus = 'Preparing upload...';
    });

    try {
      final originalFile = File(_config.originalImagePath!);
      final bytes = await originalFile.readAsBytes();

      // 1. Generate URL
      final resultUrl = await _service.generateSalon(
        config: _config,
        originalImageBytes: bytes,
        onStageChanged: (status) => setState(() => _generationStatus = status),
      );

      if (resultUrl == null) throw Exception("Generation failed (null result)");

      // 2. Download Image
      setState(() => _generationStatus = 'Downloading result...');
      final resultBytes = await _service.downloadBytes(resultUrl);

      if (resultBytes == null) throw Exception("Failed to download result image");

      // 3. Save to Disk
      final dir = await getApplicationDocumentsDirectory();
      final filename = 'salon_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final localFile = File('${dir.path}/$filename');
      await localFile.writeAsBytes(resultBytes);

      // 4. Create Result Data
      final resultData = ImageResultData(
        url: resultUrl,
        localResultPath: localFile.path,
        generationTime: DateTime.now(),
      );

      final finalConfig = _config.copyWith(
        resultData: resultData,
        timestamp: DateTime.now(),
      );

      // 5. Save History
      final resultId = await _storage.saveResult(finalConfig);
      await _historyRepo.addToHistory(resultId);

      // 6. Navigate
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => SalonRevealPage(
              config: finalConfig,
              resultImage: localFile,
              originalImage: originalFile,
            ),
          ),
        );
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
        setState(() => _isGenerating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BeautyTheme.bg0,
      body: Row(
        children: [
          // 1. Left Rail
          WizardRailStepper(
            currentStep: _currentStep,
            steps: _stepTitles,
          ),

          // 2. Main Content
          Expanded(
            child: Column(
              children: [
                // Header / Back
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: _isGenerating ? null : _prevStep,
                        ),
                        if (!_isGenerating)
                          ElevatedButton(
                            onPressed: _canProceed() ? _nextStep : null,
                            child: Text(_currentStep == 2 ? 'Generate' : 'Next'),
                          ),
                      ],
                    ),
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _buildStepContent(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    if (_isGenerating) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: BeautyTheme.primary),
            const SizedBox(height: 16),
            Text(
              _generationStatus,
              style: const TextStyle(fontWeight: FontWeight.w600, color: BeautyTheme.ink1),
            ),
            const SizedBox(height: 8),
            const Text(
              'This may take 15-30 seconds',
              style: TextStyle(fontSize: 12, color: BeautyTheme.muted),
            ),
          ],
        ),
      );
    }

    switch (_currentStep) {
      case 0:
        return UploadStudioStep(
          selectedImage: _config.originalImagePath != null
              ? File(_config.originalImagePath!)
              : null,
          onImageSelected: (file) {
            setState(() {
              _config = _config.copyWith(originalImagePath: file.path);
            });
          },
        );
      case 1:
        return StyleMoodboardStep(
          selectedStyleId: _config.selectedStyleId,
          controlValues: _config.controlValues,
          onStyleSelected: (id, values) {
             setState(() {
               _config = _config.copyWith(
                 selectedStyleId: id,
                 controlValues: values,
               );
             });
          },
        );
      case 2:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: BeautyTheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.auto_awesome, size: 64, color: BeautyTheme.primary),
              ),
              const SizedBox(height: 32),
              Text('Ready to Glow Up?', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 12),
              const Text(
                'We will generate your salon design based on your choices.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _generate,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: const Text('GENERATE DESIGN'),
              ),
            ],
          ),
        );
      default:
        return const SizedBox();
    }
  }

  bool _canProceed() {
    if (_currentStep == 0) return _config.hasOriginalImage;
    if (_currentStep == 1) return _config.hasStyle;
    return true;
  }
}
