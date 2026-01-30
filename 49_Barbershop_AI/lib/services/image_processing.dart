import 'dart:convert';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

/// Request object for image processing in background isolate
class ImageProcessRequest {
  final Uint8List bytes;
  final int targetKB;
  final int maxWidth;
  final int maxHeight;

  ImageProcessRequest({
    required this.bytes,
    required this.targetKB,
    required this.maxWidth,
    required this.maxHeight,
  });
}

/// Processes image in background isolate to avoid blocking UI
///
/// Decodes, resizes, and compresses the image to meet target size.
/// Returns a base64 data URL.
String processImageToDataUrl(ImageProcessRequest request) {
  try {
    final decoded = img.decodeImage(request.bytes);
    if (decoded == null) {
      final b64 = base64Encode(request.bytes);
      return 'data:image/png;base64,$b64';
    }

    int quality = 92;
    img.Image current = decoded;

    if (decoded.width > request.maxWidth || decoded.height > request.maxHeight) {
      current = img.copyResize(
        decoded,
        width: decoded.width > decoded.height ? request.maxWidth : null,
        height: decoded.height >= decoded.width ? request.maxHeight : null,
        interpolation: img.Interpolation.linear,
      );
    }

    Uint8List out = Uint8List.fromList(img.encodeJpg(current, quality: quality));
    while (out.lengthInBytes > request.targetKB * 1024 && quality > 40) {
      quality -= 10;
      out = Uint8List.fromList(img.encodeJpg(current, quality: quality));
    }

    final b64 = base64Encode(out);
    return 'data:image/jpeg;base64,$b64';
  } catch (e) {
    print('[ImageProcessing] Error: $e');
    final b64 = base64Encode(request.bytes);
    return 'data:image/jpeg;base64,$b64';
  }
}
