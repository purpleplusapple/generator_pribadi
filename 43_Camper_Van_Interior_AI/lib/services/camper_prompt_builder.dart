// lib/services/camper_prompt_builder.dart
// Construct prompts for Replicate based on CamperConfig

import '../model/camper_config.dart';
import '../data/camper_styles_data.dart';

class CamperPromptBuilder {

  static String buildPrompt(CamperConfig config) {
    // 1. Base Prompt (Road-Luxe + Compact Craftsmanship)
    final buffer = StringBuffer();
    buffer.write("camper van interior redesign, realistic compact proportions, premium craftsmanship, functional zones, ");

    // 2. Style Info
    final styleId = config.selectedStyleId;
    if (styleId != null) {
      final style = CamperStylesData.styles.firstWhere(
        (s) => s.id == styleId,
        orElse: () => CamperStylesData.styles.first
      );

      buffer.write("${style.name}, ${style.description}, ");
      buffer.write(style.tags.join(", "));
      buffer.write(", ");
    }

    // 3. Control Params
    config.styleParams.forEach((key, value) {
      // Map keys to readable prompt text if needed
      // e.g. "off_grid" -> "Off-Grid Capability: 50%"
      if (value is bool && value == true) {
         buffer.write("$key enabled, ");
      } else if (value is String) {
         buffer.write("$value, ");
      } else {
         buffer.write("$key: $value, ");
      }
    });

    // 4. User Note
    if (config.reviewNotes != null && config.reviewNotes!.isNotEmpty) {
      buffer.write("User request: ${config.reviewNotes}, ");
    }

    // 5. Quality Line
    buffer.write("keep realistic conversion layout, avoid impossible space, maintain clean surfaces, readable lighting, 8k resolution, photorealistic, interior design photography");

    return buffer.toString();
  }

  static String buildNegativePrompt(CamperConfig config) {
    // Standard negative prompt + custom
    String base = "blurry, low quality, distorted, impossible geometry, messy, clutter, watermark, text, signature, bad perspective, neon lights, oversized furniture";

    // Check for custom negative prompt in params
    if (config.styleParams.containsKey('negative_prompt')) {
      base += ", ${config.styleParams['negative_prompt']}";
    }

    return base;
  }
}
