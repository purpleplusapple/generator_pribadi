// lib/services/meeting_prompt_builder.dart
// AI prompt generation from user selections

import '../model/meeting_ai_config.dart';
import '../data/meeting_style_repository.dart';

class MeetingPromptBuilder {
  /// Build a prompt from MeetingAIConfig
  String buildPrompt(MeetingAIConfig config) {
    if (!config.hasStyleSelection) {
      return 'modern meeting room, high quality';
    }

    final selection = config.styleSelection!;
    final style = MeetingStyleRepository.getById(selection.styleId);
    final StringBuffer prompt = StringBuffer();

    // 1. Base Prompt (or Custom Prompt)
    if (style.id == 'custom') {
      final customPrompt = selection.controlValues['custom_prompt'] as String? ?? '';
      if (customPrompt.isEmpty) {
        prompt.write('modern meeting room, professional interior design');
      } else {
        prompt.write(customPrompt);
      }
    } else {
      prompt.write(style.basePrompt);
    }

    prompt.write(', ');

    // 2. Add Controls
    selection.controlValues.forEach((key, value) {
      if (key == 'custom_prompt' || key == 'negative_prompt' || key == 'note') return; // Handled separately

      // Format logic could be improved based on key, but simple appending works for AI
      // e.g. "Capacity: 8" -> "seating for 8 people"
      if (key == 'capacity') {
        prompt.write('seating for $value people, ');
      } else if (key == 'table_shape') {
        prompt.write('$value table, ');
      } else if (key == 'lighting') {
        prompt.write('$value lighting, ');
      } else if (key == 'av_level') {
        prompt.write('$value AV setup, ');
      } else {
        prompt.write('$value $key, ');
      }
    });

    // 3. Add Notes
    final note = selection.controlValues['note'] as String?;
    if (note != null && note.isNotEmpty) {
      prompt.write('details: $note, ');
    }

    // 4. Quality Modifiers
    prompt.write(
      ' photorealistic, 8k, architectural photography, highly detailed, interior design magazine style, volumetric lighting',
    );

    return prompt.toString();
  }

  /// Build negative prompt (things to avoid)
  String buildNegativePrompt(MeetingAIConfig config) {
    String negative = 'blurry, low quality, distorted, unrealistic, cartoonish, oversaturated, dark, poorly lit, cluttered, messy, amateur, watermark, text, logo';

    if (config.hasStyleSelection) {
      final selection = config.styleSelection!;
      if (selection.styleId == 'custom') {
        final customNeg = selection.controlValues['negative_prompt'] as String?;
        if (customNeg != null && customNeg.isNotEmpty) {
          negative += ', $customNeg';
        }
      }
    }

    return negative;
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
