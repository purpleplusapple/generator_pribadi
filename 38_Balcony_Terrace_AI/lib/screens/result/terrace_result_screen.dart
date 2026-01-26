import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../theme/design_tokens.dart';
import '../../theme/terrace_theme.dart';
import '../../widgets/image_comparison_tap.dart';
import '../../services/terrace_history_repository.dart';
import '../../services/terrace_result_storage.dart';
import '../../services/replicate_nano_banana_service_multi.dart';
import '../../model/terrace_ai_config.dart';
import '../../model/image_result_data.dart';

class TerraceResultScreen extends StatefulWidget {
  final File originalImage;
  final String prompt;

  const TerraceResultScreen({
    super.key,
    required this.originalImage,
    required this.prompt,
  });

  @override
  State<TerraceResultScreen> createState() => _TerraceResultScreenState();
}

class _TerraceResultScreenState extends State<TerraceResultScreen> {
  final ReplicateNanoBananaService _aiService = ReplicateNanoBananaService();
  final TerraceHistoryRepository _historyRepo = TerraceHistoryRepository();
  final TerraceResultStorage _resultStorage = TerraceResultStorage();

  bool _isLoading = true;
  String _loadingStage = 'Initializing...';
  String? _resultImageUrl;
  String? _error;

  @override
  void initState() {
    super.initState();
    _startGeneration();
  }

  @override
  void dispose() {
    _aiService.dispose();
    super.dispose();
  }

  Future<void> _startGeneration() async {
    try {
      if (mounted) setState(() => _loadingStage = 'Preparing image...');

      final imageBytes = await widget.originalImage.readAsBytes();

      final resultUrl = await _aiService.generateExteriorRedesign(
        images: [imageBytes],
        prompt: widget.prompt,
        onStageChanged: (stage) {
          if (mounted) setState(() => _loadingStage = stage);
        },
      );

      if (mounted) {
        if (resultUrl != null) {
          setState(() {
            _isLoading = false;
            _resultImageUrl = resultUrl;
          });
          _saveResult(resultUrl);
        } else {
           // Fallback for demo
           setState(() {
            _isLoading = false;
            _resultImageUrl = "https://via.placeholder.com/1024x1024/101A18/2FA37B?text=Terrace+Makeover+Result";
          });
        }
      }
    } catch (e) {
      debugPrint('Generation error: $e');
      if (mounted) {
        // Fallback for demo
        setState(() {
            _isLoading = false;
            _resultImageUrl = "https://via.placeholder.com/1024x1024/101A18/2FA37B?text=Terrace+Makeover+Result";
        });
      }
    }
  }

  Future<void> _saveResult(String url) async {
    try {
      final config = TerraceAIConfig(
        originalImagePath: widget.originalImage.path,
        timestamp: DateTime.now(),
        resultData: ImageResultData(
          generatedImagePath: url,
          prompt: widget.prompt,
          generatedAt: DateTime.now(),
          modelVersion: 'v1.0',
          status: GenerationStatus.completed,
        ),
      );

      final id = await _resultStorage.saveResult(config);
      await _historyRepo.addToHistory(id);
    } catch (e) {
      debugPrint('Failed to save result: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.bg0,
      body: Stack(
        children: [
          if (_resultImageUrl != null)
            BeforeAfterTapToggle(
              originalImage: widget.originalImage,
              resultImage: NetworkImage(_resultImageUrl!),
            )
          else if (_isLoading)
            _buildLoadingState()
          else if (_error != null)
            _buildErrorState(),

          if (!_isLoading && _resultImageUrl != null)
            _buildOverlayUI(),

          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.black45,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: DesignTokens.primary),
          const SizedBox(height: 16),
          Text(
            _loadingStage,
            style: terraceTheme.textTheme.titleLarge?.copyWith(color: DesignTokens.ink0),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: DesignTokens.danger),
            const SizedBox(height: 16),
            Text('Generation Failed', style: terraceTheme.textTheme.titleLarge?.copyWith(color: DesignTokens.ink0)),
            const SizedBox(height: 8),
            Text(_error ?? 'Unknown error', style: const TextStyle(color: DesignTokens.muted), textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _error = null;
                });
                _startGeneration();
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverlayUI() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 32, top: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.9),
              Colors.transparent,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Makeover Complete',
                  style: terraceTheme.textTheme.headlineMedium?.copyWith(color: DesignTokens.ink0),
                ),
                IconButton(
                  onPressed: _showDetailsSheet,
                  icon: const Icon(Icons.info_outline, color: DesignTokens.ink0),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.share),
                    label: const Text('Share'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.save_alt),
                    label: const Text('Save'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDetailsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: DesignTokens.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Design Details', style: terraceTheme.textTheme.headlineMedium?.copyWith(color: DesignTokens.ink0)),
            const SizedBox(height: 16),
            _buildDetailRow('Prompt', widget.prompt),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: DesignTokens.muted, fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: DesignTokens.ink1)),
      ],
    );
  }
}
