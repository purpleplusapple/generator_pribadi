import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

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

/// Service for generating AI custom van builds (image-to-image) using Replicate API
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
      _processImageInIsolate,
      {
        'bytes': bytes,
        'targetKB': targetKB,
        'maxWidth': maxWidth,
        'maxHeight': maxHeight,
      },
    );
  }

  /// Generates an AI exterior redesign from input images and prompt
  Future<String?> generateExteriorRedesign({
    required List<Uint8List> images,
    required String prompt,
    String? negativePrompt,
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

    onStageChanged?.call('Processing your interior photo...');
    final futures = images.map((bytes) => _bytesToDataUrlJpeg(
          bytes: bytes,
          targetKB: targetKBPerImage,
        ));
    final dataUrls = await Future.wait(futures);

    onStageChanged?.call('Starting AI generation...');
    final predictionId = await _createPrediction(
      prompt: safePrompt,
      negativePrompt: negativePrompt,
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
    String? negativePrompt,
    required List<String> imageDataUrls,
    required String outputFormat,
    required int outputQuality,
  }) async {
    final uri = Uri.parse('$_baseUrl/predictions');
    final body = {
      'version': _model,
      'input': {
        'prompt': prompt,
        'negative_prompt': negativePrompt ?? "",
        'image_input': imageDataUrls, // Might need to be 'image' depending on model version
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
        'Unable to reach Camper Van AI servers. Please check your internet connection.',
      );
    } on TimeoutException catch (_) {
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
      'Analyzing interior dimensions...',
      'Applying your styling choices...',
      'Rendering your custom layout...',
      'Enhancing wood textures...',
      'Finalizing your van build...',
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
            debugPrint('[ReplicateService] Generation failed');
            return null;
          }
        }
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
      return null;
    } catch (e) {
      return null;
    }
  }

  void dispose() {
    _client.close();
  }
}

Future<String> _processImageInIsolate(Map<String, dynamic> params) async {
  final bytes = params['bytes'] as Uint8List;
  final targetKB = params['targetKB'] as int;
  final maxWidth = params['maxWidth'] as int;
  final maxHeight = params['maxHeight'] as int;

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
    debugPrint('[ReplicateService] Image processing error in isolate: $e');
    final b64 = base64Encode(bytes);
    return 'data:image/jpeg;base64,$b64';
  }
}
