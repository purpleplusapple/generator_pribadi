// lib/services/shoe_prompt_builder.dart
// AI prompt generation from user selections

import '../model/shoe_ai_config.dart';

class LaundryPromptBuilder {
  /// Build a prompt from ShoeAIConfig
  String buildPrompt(ShoeAIConfig config) {
    final StringBuffer prompt = StringBuffer();

    // Base instruction
    prompt.writeln(
      'A professional interior design photo of a modern shoe room with the following specifications:',
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
      'High quality, photorealistic, professional interior photography, '
      '4K resolution, well-lit, professional staging, architectural photography',
    );

    return prompt.toString().trim();
  }

  /// Build negative prompt (things to avoid)
  String buildNegativePrompt() {
    return 'blurry, low quality, distorted, unrealistic, cartoonish, '
        'oversaturated, dark, poorly lit, cluttered, messy, amateur';
  }

  /// Get recommended image dimensions based on original
  Map<String, int> getRecommendedDimensions(int width, int height) {
    // Keep aspect ratio, cap at 1024
    const int maxDim = 1024;
    
    if (width > height) {
      final ratio = height / width;
      return {
        'width': maxDim,
        'height': (maxDim * ratio).round(),
      };
    } else {
      final ratio = width / height;
      return {
        'width': (maxDim * ratio).round(),
        'height': maxDim,
      };
    }
  }
}
