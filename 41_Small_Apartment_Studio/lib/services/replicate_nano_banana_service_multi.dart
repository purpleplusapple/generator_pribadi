import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'image_processing.dart';
import 'safe_prompt_filter.dart';

class UnsafePromptException implements Exception {
  UnsafePromptException(this.message);
  final String message;
  @override
  String toString() => message;
}

class NetworkException implements Exception {
  NetworkException(this.message);
  final String message;
  @override
  String toString() => message;
}

class GenerationTimeoutException implements Exception {
  GenerationTimeoutException(this.message);
  final String message;
  @override
  String toString() => message;
}

class ReplicateNanoBananaService {
  ReplicateNanoBananaService({SafePromptFilter? filter})
      : _filter = filter ?? SafePromptFilter(mode: 'strict');

  static const _apiToken = 'dummy';
  static const _model = 'google/nano-banana';
  static const _baseUrl = 'https://api.replicate.com/v1';
  static const _maxPollAttempts = 60;
  static const _pollInterval = Duration(seconds: 2);
  static const _requestTimeout = Duration(seconds: 30);

  final http.Client _client = http.Client();
  final SafePromptFilter _filter;

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

  Future<String?> generateExteriorRedesign({
    required List<Uint8List> images,
    required String prompt,
    int targetKBPerImage = 240,
    String outputFormat = 'jpg',
    int outputQuality = 100,
    ValueChanged<String>? onStageChanged,
  }) async {
    if (images.isEmpty) return null;

    onStageChanged?.call('Checking content safety...');
    final check = _filter.check(prompt);
    if (!check.allowed) {
      throw UnsafePromptException('Content policy violation: "${check.reason}"');
    }
    final safePrompt = check.sanitized;

    onStageChanged?.call('Processing your photo...');
    final futures = images.map((bytes) => _bytesToDataUrlJpeg(bytes: bytes, targetKB: targetKBPerImage));
    final dataUrls = await Future.wait(futures);

    onStageChanged?.call('Starting AI generation...');
    final predictionId = await _createPrediction(
      prompt: safePrompt,
      imageDataUrls: dataUrls,
      outputFormat: outputFormat,
      outputQuality: outputQuality,
    );

    if (predictionId == null) return null;

    onStageChanged?.call('Generating your redesign...');
    return await _pollForCompletion(predictionId: predictionId, onStageChanged: onStageChanged);
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
      final response = await _client.post(
        uri,
        headers: {
          'Authorization': 'Bearer $_apiToken',
          'Content-Type': 'application/json',
          'Prefer': 'wait',
        },
        body: jsonEncode(body),
      ).timeout(_requestTimeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'succeeded') {
          final output = data['output'];
          if (output is List && output.isNotEmpty) return '__COMPLETED__${output[0]}';
          if (output is String) return '__COMPLETED__$output';
        }
        return data['id'] as String?;
      }
      return null;
    } on SocketException catch (_) {
      throw NetworkException('Unable to reach Small Apartment Studio AI servers.');
    } on TimeoutException catch (_) {
      throw NetworkException('Request timed out.');
    } catch (_) {
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
      'Analyzing structural elements...',
      'Applying luxury textures...',
      'Rendering your rooftop design...',
      'Enhancing lighting details...',
      'Finalizing your lounge...',
    ];

    while (attempts < _maxPollAttempts) {
      try {
        final response = await _client.get(uri, headers: {'Authorization': 'Bearer $_apiToken'}).timeout(_requestTimeout);

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final status = data['status'] as String?;

          final stageIndex = (attempts ~/ 3).clamp(0, stages.length - 1);
          onStageChanged?.call(stages[stageIndex]);

          if (status == 'succeeded') {
            final output = data['output'];
            if (output is List && output.isNotEmpty) return output[0] as String;
            if (output is String) return output;
            return null;
          } else if (status == 'failed' || status == 'canceled') {
            return null;
          }
        }
      } catch (_) {}

      attempts++;
      await Future.delayed(_pollInterval);
    }

    throw GenerationTimeoutException('Generation is taking longer than expected.');
  }

  Future<Uint8List?> downloadBytes(String url) async {
    try {
      final response = await _client.get(Uri.parse(url)).timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) return response.bodyBytes;
      return null;
    } catch (e) {
      throw NetworkException('Unable to download generated image.');
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
    final b64 = base64Encode(bytes);
    return 'data:image/jpeg;base64,$b64';
  }
}
