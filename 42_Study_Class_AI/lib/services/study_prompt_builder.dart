import '../model/study_ai_config.dart';
import '../data/study_styles_data.dart';
import '../model/study_style.dart';

class StudyPromptBuilder {
  String buildPrompt(StudyAIConfig config) {
    if (config.selectedStyleId == null) return '';

    // Find style
    final style = studyStyles.firstWhere(
      (s) => s.id == config.selectedStyleId,
      orElse: () => studyStyles.first,
    );

    final sb = StringBuffer();

    // 1. Base
    sb.write('Study/classroom interior redesign, premium academic, realistic proportions, clean desk setup. ');

    // 2. Style
    sb.write('Style: ${style.name}, ${style.description}. ');
    sb.write('Vibe: ${style.chips.join(", ")}. ');

    // 3. Controls
    if (config.controlValues.isNotEmpty) {
      config.controlValues.forEach((key, value) {
        // Find label if possible, or just use key/value
        // We handle simple value to string conversion
        if (value is bool) {
          if (value) sb.write('$key: enabled. ');
        } else if (value is double || value is int) {
           // Maybe add unit/context if known, otherwise just value
           // For sliders like "warmth", "65" might mean nothing without context.
           // Ideally we look up the control definition.
           final control = style.controls.firstWhere((c) => c.id == key, orElse: () => style.controls.first);
           sb.write('${control.label}: $value. ');
        } else if (value is List) {
          sb.write('$key: ${(value as List).join(", ")}. ');
        } else {
          sb.write('$key: $value. ');
        }
      });
    }

    // 4. User Note
    if (config.userNote != null && config.userNote!.isNotEmpty) {
      sb.write('User Note: ${config.userNote}. ');
    }

    // 5. Custom Advanced special handling
    if (style.id == 'custom_adv') {
      final customPrompt = config.controlValues['custom_prompt'];
      if (customPrompt != null && customPrompt.toString().isNotEmpty) {
        sb.write('Custom Requirements: $customPrompt. ');
      }
    }

    // 6. Quality Line
    sb.write('keep readable lighting, avoid muddy dark details, keep study surfaces clear, realistic furniture scale, 8k resolution, architectural photography.');

    return sb.toString();
  }

  String buildNegativePrompt(StudyAIConfig config) {
    final sb = StringBuffer();
    sb.write('people, blurry, distorted, messy, dark shadows, low quality, watermark, text, signature. ');

    // Custom negative
    if (config.selectedStyleId == 'custom_adv') {
      final neg = config.controlValues['negative_prompt'];
      if (neg != null) sb.write('$neg');
    }

    return sb.toString();
  }
}
