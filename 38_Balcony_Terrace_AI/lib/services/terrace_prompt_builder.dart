import '../data/style_categories.dart';

class TerracePromptBuilder {

  static String buildPrompt({
    required StyleCategory category,
    required Map<String, dynamic> controlValues,
    String? userNote,
    String? customPromptOverride, // For Advanced Custom mode
    bool isAdvancedCustom = false,
  }) {
    if (isAdvancedCustom && customPromptOverride != null && customPromptOverride.isNotEmpty) {
      return _buildAdvancedPrompt(customPromptOverride, userNote);
    }

    final StringBuffer buffer = StringBuffer();

    // 1. Base Prompt from Category
    buffer.write(category.basePrompt);
    buffer.write(", night scene, 8k resolution, photorealistic, ");

    // 2. Append Control Values
    // We iterate through the category controls and see if we have a value.
    for (final control in category.controls) {
      final value = controlValues[control.id];
      if (value == null) continue;

      _appendControlPrompt(buffer, control, value);
    }

    // 3. User Note
    if (userNote != null && userNote.trim().isNotEmpty) {
      buffer.write(", user request: ${userNote.trim()}");
    }

    // 4. Quality Boosters (Dark Theme specific)
    buffer.write(", clear details, professional photography, soft lighting, sharp focus");

    return buffer.toString();
  }

  static String _buildAdvancedPrompt(String customText, String? userNote) {
    final StringBuffer buffer = StringBuffer();
    buffer.write(customText);
    buffer.write(", night scene, photorealistic, 8k");

    if (userNote != null && userNote.isNotEmpty) {
      buffer.write(", additional notes: $userNote");
    }

    return buffer.toString();
  }

  static void _appendControlPrompt(StringBuffer buffer, ControlSpec control, dynamic value) {
    // Logic to translate control values to prompt snippets
    // This is a heuristic mapping.

    switch (control.type) {
      case ControlType.chips:
      case ControlType.toggle:
        if (value is String) {
          if (value == 'Yes') {
             buffer.write(", with ${control.label.toLowerCase()}");
          } else if (value == 'No' || value == 'None') {
             // Skip or explicit negation if needed
          } else {
             buffer.write(", $value ${control.label.toLowerCase()}");
          }
        }
        break;

      case ControlType.slider:
        if (value is num) {
          // Interpret slider 0-100
          if (value < 30) {
            buffer.write(", low ${control.label.toLowerCase()}");
          } else if (value > 70) {
            buffer.write(", high ${control.label.toLowerCase()}");
          }
          // Mid values usually implied default
        }
        break;

      case ControlType.stepper:
        if (value is num) {
          buffer.write(", with $value ${control.label.toLowerCase()}");
        }
        break;
    }
  }

  static String buildNegativePrompt({String? customNegative}) {
    final base = "blurry, low quality, distorted, daylight, bright sun, ugly, render artifacts, watermark, text";
    if (customNegative != null && customNegative.isNotEmpty) {
      return "$base, $customNegative";
    }
    return base;
  }
}
