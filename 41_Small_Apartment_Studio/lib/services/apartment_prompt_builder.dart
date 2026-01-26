// lib/services/apartment_prompt_builder.dart
// AI prompt generation from user selections

import '../model/apartment_config.dart';

class ApartmentPromptBuilder {
  /// Build a prompt from ApartmentConfig
  String buildPrompt(ApartmentConfig config) {
    final StringBuffer prompt = StringBuffer();

    // Base instruction
    prompt.writeln(
      'A professional interior design photo of a modern small apartment studio with smart zoning and storage solutions:',
    );
    prompt.writeln();

    // Add style selections
    if (config.styleSelections.isNotEmpty) {
      for (final entry in config.styleSelections.entries) {
        prompt.writeln('- ${entry.key}: ${entry.value}');
      }
      prompt.writeln();
    }

    // Add custom notes if provided
    if (config.reviewNotes != null && config.reviewNotes!.isNotEmpty) {
      prompt.writeln('Additional requirements:');
      prompt.writeln(config.reviewNotes);
      prompt.writeln();
    }

    // Quality modifiers
    prompt.writeln(
      'High quality, photorealistic, Architectural Digest style, bright natural lighting, '
      'airy atmosphere, clean lines, 4K resolution, cozy, organized, space-saving furniture, open plan',
    );

    return prompt.toString().trim();
  }

  /// Build negative prompt (things to avoid)
  String buildNegativePrompt() {
    return 'blurry, low quality, distorted, unrealistic, cartoonish, '
        'dark, gloomy, messy, cluttered, amateur, bad lighting, text, watermark';
  }

  /// Get recommended image dimensions based on original
  Map<String, int> getRecommendedDimensions(int width, int height) {
    const int maxDim = 1024;
    if (width > height) {
      final ratio = height / width;
      return {'width': maxDim, 'height': (maxDim * ratio).round()};
    } else {
      final ratio = width / height;
      return {'width': (maxDim * ratio).round(), 'height': maxDim};
    }
  }
}
