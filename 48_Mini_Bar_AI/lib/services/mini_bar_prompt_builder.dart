// lib/services/mini_bar_prompt_builder.dart
// AI prompt generation for Mini Bar AI

import '../model/mini_bar_config.dart';
import '../model/mini_bar_style_def.dart';

class MiniBarPromptBuilder {
  /// Build a prompt from MiniBarConfig
  String buildPrompt(MiniBarConfig config) {
    if (config.selectedStyleId == null) return '';

    final style = kMiniBarStyles.firstWhere(
      (s) => s.id == config.selectedStyleId,
      orElse: () => kMiniBarStyles.first,
    );

    final StringBuffer prompt = StringBuffer();

    // 1. Base Context
    prompt.write('A photorealistic interior design of a home mini bar corner, ');

    // 2. Style Descriptor
    prompt.write('${style.name} style. ${style.promptModifier}. ');

    // 3. Control Values
    config.controlValues.forEach((key, value) {
      // Find the label for this control if possible, or just use the value
      // This is a simple concatenation. Ideally we map key->label.
      if (value.toString().isNotEmpty) {
         prompt.write('$key: $value. ');
      }
    });

    // 4. User Notes
    final note = config.controlValues['note'];
    if (note != null && note.toString().isNotEmpty) {
      prompt.write('User requirements: $note. ');
    }

    // Custom Advanced logic
    if (style.id == 'custom_advanced') {
      final customPrompt = config.controlValues['custom_prompt'];
      if (customPrompt != null) prompt.write(customPrompt);
    }

    // 5. Quality Line
    prompt.write(' keep realistic proportions, avoid clutter, highlight bottle display with warm lighting, elegant surfaces, 8k resolution, architectural photography.');

    return prompt.toString();
  }

  /// Build negative prompt
  String buildNegativePrompt(MiniBarConfig config) {
    String base = 'blurry, low quality, distorted, watermark, text, signature, people, animals, messy, broken furniture';

    final neg = config.controlValues['negative_prompt'];
    if (neg != null && neg.toString().isNotEmpty) {
      base += ', $neg';
    }
    return base;
  }
}
