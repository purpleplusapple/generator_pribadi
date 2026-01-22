import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'image_processing.dart';
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

/// Service for generating AI custom car builds (image-to-image) using Replicate API
class ReplicateNanoBananaService {
  ReplicateNanoBananaService({SafePromptFilter? filter})
      : _filter = filter ?? SafePromptFilter(mode: 'strict');

  // API Configuration
  // Note: In production, use environment variables or secure storage
  static const _apiToken = 'dummy';
  static const _model = 'google/nano-banana';
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
    return compute(
      processImageToDataUrl,
      ImageProcessRequest(
        bytes: bytes,
        targetKB: targetKB,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      ),
    );
  }

  /// Generates an AI exterior redesign from input images and prompt
  ///
  /// Returns the URL of the generated image, or null if generation failed.
  /// Throws [UnsafePromptException] if prompt contains blocked content.
  /// Throws [NetworkException] if network operations fail.
  /// Throws [GenerationTimeoutException] if generation takes too long.
  Future<String?> generateExteriorRedesign({
    required List<Uint8List> images,
    required String prompt,
    int targetKBPerImage = 240,
    String outputFormat = 'jpg',
    int outputQuality = 100,
    ValueChanged<String>? onStageChanged,
  }) async {
    if (images.isEmpty) {
      debugPrint('[ReplicateService] No images provided');
      return null;
    }

    onStageChanged?.call('Checking content safety...');
    final check = _filter.check(prompt);
    if (!check.allowed) {
      throw UnsafePromptException(
        'Your prompt violates our content policy: "${check.reason}"',
      );
    }
    final safePrompt = check.sanitized;

    onStageChanged?.call('Processing your exterior photo...');
    final dataUrls = <String>[];
    for (final bytes in images) {
      final dataUrl = await _bytesToDataUrlJpeg(
        bytes: bytes,
        targetKB: targetKBPerImage,
      );
      dataUrls.add(dataUrl);
    }

    onStageChanged?.call('Starting AI generation...');
    final predictionId = await _createPrediction(
      prompt: safePrompt,
      imageDataUrls: dataUrls,
      outputFormat: outputFormat,
      outputQuality: outputQuality,
    );

    if (predictionId == null) {
      debugPrint('[ReplicateService] Failed to create prediction');
      return null;
    }

    onStageChanged?.call('Generating your redesign...');
    final result = await _pollForCompletion(
      predictionId: predictionId,
      onStageChanged: onStageChanged,
    );

    return result;
  }

  Future<String?> _createPrediction({
    required String prompt,
    required List<String> imageDataUrls,
    required String outputFormat,
    required int outputQuality,
  }) async {
    final uri = Uri.parse('$_baseUrl/predictions');
    final body = {
      'version': _model,
      'input': {
        'prompt': prompt,
        'image_input': imageDataUrls,
        'output_format': outputFormat,
        'output_quality': outputQuality,
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

      debugPrint('[ReplicateService] Create prediction status: ${response.statusCode}');

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
    } on SocketException catch (e) {
      debugPrint('[ReplicateService] Network error: $e');
      throw NetworkException(
        'Unable to reach Custom Car AI servers. Please check your internet connection.',
      );
    } on TimeoutException catch (_) {
      debugPrint('[ReplicateService] Request timeout');
      throw NetworkException(
        'Request timed out. Please try again.',
      );
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
      'Analyzing body lines & panels...',
      'Applying your styling choices...',
      'Rendering your custom car setup...',
      'Enhancing details...',
      'Finalizing your custom build...',
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

          debugPrint('[ReplicateService] Poll status: $status');

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
            debugPrint('[ReplicateService] Unexpected output format: $output');
            return null;
          } else if (status == 'failed' || status == 'canceled') {
            final error = data['error'];
            debugPrint('[ReplicateService] Generation failed: $error');
            return null;
          }
        }
      } on SocketException catch (e) {
        debugPrint('[ReplicateService] Network error during poll: $e');
      } catch (e) {
        debugPrint('[ReplicateService] Poll error: $e');
      }

      attempts++;
      await Future.delayed(_pollInterval);
    }

    throw GenerationTimeoutException(
      'Generation is taking longer than expected. Please try again.',
    );
  }

  Future<Uint8List?> downloadBytes(String url) async {
    try {
      final response = await _client
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return response.bodyBytes;
      }

      debugPrint('[ReplicateService] Download failed: ${response.statusCode}');
      return null;
    } on SocketException catch (e) {
      debugPrint('[ReplicateService] Network error downloading: $e');
      throw NetworkException(
        'Unable to download generated image. Please check your connection.',
      );
    } catch (e) {
      debugPrint('[ReplicateService] Download error: $e');
      return null;
    }
  }

  /// Disposes the HTTP client
  void dispose() {
    _client.close();
  }
}
