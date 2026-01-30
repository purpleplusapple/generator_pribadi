import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:image/image.dart' as img;

void main() async {
  print('Starting benchmark...');

  // Generate a large image (2000x2000)
  print('Generating test image (2000x2000)...');
  final img.Image testImage = img.Image(width: 2000, height: 2000);
  // Fill with some color/noise to make encoding non-trivial
  for (var y = 0; y < testImage.height; y++) {
    for (var x = 0; x < testImage.width; x++) {
      testImage.setPixel(x, y, img.ColorRgb8(x % 255, y % 255, (x + y) % 255));
    }
  }

  // Encode to JPEG bytes to simulate the input "file"
  final Uint8List inputBytes = Uint8List.fromList(img.encodeJpg(testImage));
  print('Input size: ${inputBytes.lengthInBytes} bytes');

  // Warmup
  print('Warming up...');
  await _runWorkload(inputBytes);

  // Measure
  print('Measuring...');
  final stopwatch = Stopwatch()..start();
  final result = await _runWorkload(inputBytes);
  stopwatch.stop();

  print('Result length: ${result.length}');
  print('Time taken (Synchronous blocking simulation): ${stopwatch.elapsedMilliseconds} ms');
}

Future<String> _runWorkload(Uint8List imageBytes) async {
  // Decode image
  final img.Image? image = img.decodeImage(imageBytes);
  if (image == null) {
    throw Exception('Failed to decode image');
  }

  // Resize if too large
  const int maxDimension = 1024;
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

  return 'data:image/jpeg;base64,$base64String';
}
