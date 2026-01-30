// lib/services/image_prep_service.dart
// Image preprocessing for AI generation

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

class ImagePrepService {
  /// Maximum dimension for images (to keep file size reasonable)
  static const int maxDimension = 1024;

  /// Prepare image for API by converting to base64 data URI
  Future<String> prepImageForAPI(String imagePath) async {
    try {
      // Read image file
      final File imageFile = File(imagePath);
      final Uint8List imageBytes = await imageFile.readAsBytes();

      // Offload processing to isolate
      return await compute(_processImage, imageBytes);
    } catch (e) {
      throw Exception('Failed to prepare image: $e');
    }
  }

  /// Process image in isolate: decode, resize, encode, base64
  static String _processImage(Uint8List imageBytes) {
    // Decode image
    final img.Image? image = img.decodeImage(imageBytes);
    if (image == null) {
      throw Exception('Failed to decode image');
    }

    // Resize if too large
    img.Image processedImage = image;
    if (image.width > maxDimension || image.height > maxDimension) {
      processedImage = img.copyResize(
        image,
        width: image.width > image.height ? maxDimension : null,
        height: image.height > image.width ? maxDimension : null,
      );
    }

    // Encode to JPEG with quality 85%
    final Uint8List jpegBytes = Uint8List.fromList(
      img.encodeJpg(processedImage, quality: 85),
    );

    // Convert to base64
    final String base64String = base64Encode(jpegBytes);

    // Return data URI
    return 'data:image/jpeg;base64,$base64String';
  }

  /// Get image dimensions
  Future<Map<String, int>> getImageDimensions(String imagePath) async {
    final File imageFile = File(imagePath);
    final Uint8List imageBytes = await imageFile.readAsBytes();

    return await compute(_decodeDimensions, imageBytes);
  }

  static Map<String, int> _decodeDimensions(Uint8List imageBytes) {
    final img.Image? image = img.decodeImage(imageBytes);

    if (image == null) {
      throw Exception('Failed to decode image');
    }

    return {
      'width': image.width,
      'height': image.height,
    };
  }
}
