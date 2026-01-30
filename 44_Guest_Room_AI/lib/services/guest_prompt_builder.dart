import '../model/guest_ai_config.dart';
import '../data/guest_styles.dart';
import '../model/guest_style_definition.dart';

class GuestPromptBuilder {
  /// Build a prompt from GuestAIConfig
  String buildPrompt(GuestAIConfig config) {
    if (config.selectedStyleId == null) return "guest room interior";

    final styles = getGuestStyles();
    GuestStyleDefinition? style;
    try {
      style = styles.firstWhere((s) => s.id == config.selectedStyleId);
    } catch (e) {
      return "guest room interior";
    }

    if (style.id == 'custom_advanced') {
      final customPrompt = config.getControlValue('custom_prompt') ?? '';
      return "$customPrompt, guest bedroom, photorealistic, 8k, interior design";
    }

    final StringBuffer prompt = StringBuffer();

    // 1. Base Instruction from Style
    prompt.write("${style.basePrompt}, ");

    // 2. Control Values
    config.controlValues.forEach((key, value) {
      // Find control definition to get label
      try {
        final control = style!.controls.firstWhere((c) => c.id == key);

        if (control.type == ControlType.toggle) {
          if (value == true) {
            prompt.write("with ${control.label}, ");
          }
        } else if (control.type == ControlType.slider) {
          // Add emphasis for high values
          if (value > 80) prompt.write("very ${control.label}, ");
          else if (value > 40) prompt.write("${control.label}, "); // Implicitly handle value context in future
        } else if (control.type == ControlType.chips) {
          prompt.write("$value ${control.label.toLowerCase()}, ");
        } else if (control.type == ControlType.text && value.toString().isNotEmpty) {
          prompt.write("Note: $value, ");
        }
      } catch (e) {
        // Control might be generic or not found
      }
    });

    // 3. Quality Assurance
    prompt.write("guest bedroom, hotel quality, 8k, highly detailed, photorealistic, professional interior photography, inviting atmosphere");

    return prompt.toString();
  }

  /// Build negative prompt (things to avoid)
  String buildNegativePrompt(GuestAIConfig config) {
    String baseNegative = 'blurry, low quality, distorted, unrealistic, cartoonish, oversaturated, dark, poorly lit, cluttered, messy, amateur, text, watermark, logos';

    // Add custom negative prompt
    if (config.selectedStyleId == 'custom_advanced') {
      final customNeg = config.getControlValue('negative_prompt') ?? '';
      if (customNeg.isNotEmpty) {
        baseNegative += ', $customNeg';
      }
    }

    return baseNegative;
  }

  /// Get recommended image dimensions
  Map<String, int> getRecommendedDimensions(int width, int height) {
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
