// lib/services/terrace_prompt_builder.dart
import '../model/terrace_ai_config.dart';
import '../data/terrace_styles.dart';

class TerracePromptBuilder {
  String buildPrompt(TerraceAIConfig config) {
    if (config.selectedStyleId == null) return '';

    final style = TerraceStyles.getById(config.selectedStyleId!);
    final StringBuffer prompt = StringBuffer();

    // 1. Base Prompt from Style
    if (style.basePrompt.isNotEmpty) {
      prompt.write('${style.basePrompt}, ');
    }

    // 2. Add Control Values
    config.controlValues.forEach((key, value) {
      // Find the control definition to get the label if needed, or just use value
      // Simple strategy: key=value
      if (value == null) return;

      // Special handling for some keys
      if (key == 'note' && value.toString().isNotEmpty) {
         // Appended later
         return;
      }
      if (key == 'custom_prompt') {
        prompt.write('$value, ');
        return;
      }
      if (key == 'strictness' || key == 'warmth' || key == 'intensity' || key == 'clutter') {
         // These might be internal params for the model guidance scale rather than prompt text,
         // but here we just put them in prompt or ignore.
         // Let's add them as descriptors if high/low
         // e.g. "high warmth" or "low clutter"
         return;
      }

      // Default: add value as string (e.g. "Bamboo" from Privacy)
      if (value is bool && value == true) {
         prompt.write('$key enabled, ');
      } else if (value is String) {
         prompt.write('$value $key, '); // e.g. "Bamboo privacy", "Lantern lighting"
      }
    });

    // 3. User Note
    final note = config.controlValues['note'];
    if (note != null && note.toString().isNotEmpty) {
      prompt.write('${note.toString()}, ');
    }

    // 4. Quality Modifiers
    prompt.write('cinematic outdoor lighting, realistic textures, 8k resolution, architectural photography, night scene, detailed background.');

    return prompt.toString();
  }

  String buildNegativePrompt(TerraceAIConfig config) {
     // Check for custom negative
     final customNeg = config.controlValues['negative_prompt'];
     String base = 'blurry, low quality, distorted, watermark, text, signature, indoor, bedroom, bathroom, kitchen, ';
     if (customNeg != null && customNeg.toString().isNotEmpty) {
       base += customNeg.toString();
     }
     return base;
  }
}
