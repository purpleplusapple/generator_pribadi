import '../data/storage_styles.dart';

class PromptBuilder {
  static String buildPrompt({
    required StorageStyle style,
    required Map<String, dynamic> controlValues,
    String? userNote,
    bool isCustom = false,
  }) {
    final StringBuffer sb = StringBuffer();

    // 1. Base
    sb.write("utility/storage room redesign, pro organization, realistic clearance and access paths, ");

    // 2. Style Descriptor
    sb.write("${style.name}, ${style.description}, ");

    // 3. Custom Advanced Logic
    if (isCustom && controlValues['strictness'] != null) {
      double strictness = controlValues['strictness'];
      sb.write("adherence score ${strictness.toStringAsFixed(1)}, ");
    }

    // 4. Control Values
    controlValues.forEach((key, value) {
      // Human readable mapping
      if (value is bool && value == true) {
        sb.write("$key enabled, ");
      } else if (value is String) {
        sb.write("$value $key, ");
      } else if (value is double && key != 'strictness') {
        // Skip sliders unless mapped, generally sliders need context
      }
    });

    // 5. User Note
    if (userNote != null && userNote.isNotEmpty) {
      sb.write("User requirement: $userNote, ");
    }

    // 6. Quality Line
    sb.write("keep realistic shelf spacing, reachable storage, uncluttered floor, clear pathways, highly detailed 8k render, architectural photography.");

    return sb.toString();
  }

  static String buildNegativePrompt({required Map<String, dynamic> controlValues}) {
    // Basic negative prompt
    String neg = "people, pets, clutter, messy floor, distorted perspective, impossible architecture, watermark, text, blurry, low resolution, broken furniture, cartoon, illustration";

    // Add custom negative prefs if any (assuming 'negative_prefs' might be a control in custom)
    if (controlValues.containsKey('negative_prefs')) {
       neg += ", ${controlValues['negative_prefs']}";
    }

    return neg;
  }
}
