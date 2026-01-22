// lib/services/rooftop_prompt_builder.dart
// AI prompt generation from user selections

import '../model/rooftop_config.dart';

class RooftopPromptBuilder {
  /// Build a prompt from RooftopConfig
  String buildPrompt(RooftopConfig config) {
    final StringBuffer prompt = StringBuffer();

    // Base instruction
    prompt.writeln(
      'A professional architectural photo of a luxury rooftop lounge and terrace with the following specifications:',
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
      'High quality, photorealistic, professional night photography, '
      '4K resolution, cinematic lighting, city lights, luxury atmosphere, architectural detail',
    );

    return prompt.toString().trim();
  }

  /// Build negative prompt (things to avoid)
  String buildNegativePrompt() {
    return 'blurry, low quality, distorted, unrealistic, cartoonish, '
        'oversaturated, daylight, cluttered, messy, amateur, indoor ceiling';
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
