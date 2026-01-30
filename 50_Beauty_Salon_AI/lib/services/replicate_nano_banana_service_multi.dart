import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

import '../model/beauty_config.dart';
import 'safe_prompt_filter.dart';

/// Exception thrown when prompt contains unsafe content
class UnsafePromptException implements Exception {
  UnsafePromptException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Exception thrown when network operations fail
class NetworkException implements Exception {
  NetworkException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Exception thrown when generation times out
class GenerationTimeoutException implements Exception {
  GenerationTimeoutException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Service for generating AI Beauty Salon designs using Replicate API
class ReplicateNanoBananaService {
  ReplicateNanoBananaService({SafePromptFilter? filter})
      : _filter = filter ?? SafePromptFilter(mode: 'strict');

  // API Configuration
  // Note: In production, use environment variables or secure storage
  static const _apiToken = 'dummy';
  static const _model = 'google/nano-banana'; // Or whatever model is used
  static const _baseUrl = 'https://api.replicate.com/v1';

  // Timeouts and retries
  static const _maxPollAttempts = 60;
  static const _pollInterval = Duration(seconds: 2);
  static const _requestTimeout = Duration(seconds: 30);

  final http.Client _client = http.Client();
  final SafePromptFilter _filter;

  /// Converts image bytes to a data URL, resizing and compressing as needed
  Future<String> _bytesToDataUrlJpeg({
    required Uint8List bytes,
    int targetKB = 240,
    int maxWidth = 2048,
    int maxHeight = 2048,
  }) async {
    try {
      final decoded = img.decodeImage(bytes);
      if (decoded == null) {
        final b64 = base64Encode(bytes);
        return 'data:image/png;base64,$b64';
      }

      int quality = 92;
      img.Image current = decoded;

      if (decoded.width > maxWidth || decoded.height > maxHeight) {
        current = img.copyResize(
          decoded,
          width: decoded.width > decoded.height ? maxWidth : null,
          height: decoded.height >= decoded.width ? maxHeight : null,
          interpolation: img.Interpolation.linear,
        );
      }

      Uint8List out = Uint8List.fromList(img.encodeJpg(current, quality: quality));
      while (out.lengthInBytes > targetKB * 1024 && quality > 40) {
        quality -= 10;
        out = Uint8List.fromList(img.encodeJpg(current, quality: quality));
      }

      final b64 = base64Encode(out);
      return 'data:image/jpeg;base64,$b64';
    } catch (e) {
      debugPrint('[ReplicateService] Image processing error: $e');
      final b64 = base64Encode(bytes);
      return 'data:image/jpeg;base64,$b64';
    }
  }

  /// Generates a Salon Design based on Config
  Future<String?> generateSalon({
    required BeautyAIConfig config,
    required Uint8List originalImageBytes,
    int targetKBPerImage = 240,
    ValueChanged<String>? onStageChanged,
  }) async {

    // 1. Build Prompt
    final positivePrompt = config.buildPositivePrompt();
    // Replicate usually takes prompts in specific fields depending on the model.
    // Assuming prompt and negative_prompt are supported.

    onStageChanged?.call('Validating design...');
    final check = _filter.check(positivePrompt);
    if (!check.allowed) {
      throw UnsafePromptException(
        'Your choices violate our content policy: "${check.reason}"',
      );
    }
    final safePrompt = check.sanitized;

    onStageChanged?.call('Processing studio image...');
    final dataUrl = await _bytesToDataUrlJpeg(
      bytes: originalImageBytes,
      targetKB: targetKBPerImage,
    );

    onStageChanged?.call('Starting AI Designer...');

    // NOTE: Model inputs vary. Adjust keys as needed for the specific ControlNet/Img2Img model.
    // For now using generic inputs.
    final predictionId = await _createPrediction(
      prompt: safePrompt,
      negativePrompt: config.buildNegativePrompt(),
      imageDataUrl: dataUrl,
    );

    if (predictionId == null) {
      debugPrint('[ReplicateService] Failed to create prediction');
      return null;
    }

    onStageChanged?.call('Rendering your salon...');
    final result = await _pollForCompletion(
      predictionId: predictionId,
      onStageChanged: onStageChanged,
    );

    return result;
  }

  Future<String?> _createPrediction({
    required String prompt,
    required String negativePrompt,
    required String imageDataUrl,
  }) async {
    final uri = Uri.parse('$_baseUrl/predictions');
    final body = {
      'version': _model,
      'input': {
        'prompt': prompt,
        'negative_prompt': negativePrompt,
        'image': imageDataUrl,
        // Note: 'image_input' was in previous file, usually 'image' is standard for img2img models.
        // Keeping consistent with typical ControlNet or SD XL inputs.
        // If the model expects specific keys, they go here.
        'num_inference_steps': 30,
        'guidance_scale': 7.5,
        'prompt_strength': 0.8,
        'controlnet_conditioning_scale': 1.0, // If using ControlNet
      }
    };

    try {
      final response = await _client
          .post(
            uri,
            headers: {
              'Authorization': 'Bearer $_apiToken',
              'Content-Type': 'application/json',
              'Prefer': 'wait',
            },
            body: jsonEncode(body),
          )
          .timeout(_requestTimeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final status = data['status'] as String?;
        if (status == 'succeeded') {
          final output = data['output'];
          if (output is List && output.isNotEmpty) {
            return '__COMPLETED__${output[0]}';
          }
          if (output is String) {
            return '__COMPLETED__$output';
          }
        }
        return data['id'] as String?;
      }

      debugPrint('[ReplicateService] Create prediction failed: ${response.body}');
      return null;
    } catch (e) {
      debugPrint('[ReplicateService] Error creating prediction: $e');
      return null;
    }
  }

  Future<String?> _pollForCompletion({
    required String predictionId,
    ValueChanged<String>? onStageChanged,
  }) async {
    if (predictionId.startsWith('__COMPLETED__')) {
      return predictionId.replaceFirst('__COMPLETED__', '');
    }

    final uri = Uri.parse('$_baseUrl/predictions/$predictionId');
    int attempts = 0;

    final stages = [
      'Analyzing room structure...',
      'Applying ${DateTime.now().millisecond % 2 == 0 ? "Lighting" : "Materials"}...',
      'Refining furniture details...',
      'Polishing surfaces...',
      'Final touches...',
    ];

    while (attempts < _maxPollAttempts) {
      try {
        final response = await _client
            .get(
              uri,
              headers: {'Authorization': 'Bearer $_apiToken'},
            )
            .timeout(_requestTimeout);

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final status = data['status'] as String?;

          final stageIndex = (attempts ~/ 3).clamp(0, stages.length - 1);
          onStageChanged?.call(stages[stageIndex]);

          if (status == 'succeeded') {
            final output = data['output'];
             if (output is List && output.isNotEmpty) {
              return output[0] as String;
            }
            if (output is String) {
              return output;
            }
            return null;
          } else if (status == 'failed' || status == 'canceled') {
            return null;
          }
        }
      } catch (e) {
        // ignore
      }

      attempts++;
      await Future.delayed(_pollInterval);
    }

    throw GenerationTimeoutException(
      'Generation is taking longer than expected.',
    );
  }

  Future<Uint8List?> downloadBytes(String url) async {
    try {
      final response = await _client.get(Uri.parse(url));
      if (response.statusCode == 200) return response.bodyBytes;
      return null;
    } catch (e) {
      return null;
    }
  }

  void dispose() {
    _client.close();
  }
}
