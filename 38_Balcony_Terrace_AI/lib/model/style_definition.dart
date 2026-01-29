import 'style_control.dart';

class StyleDefinition {
  final String id;
  final String title;
  final String description;
  final String imagePath; // Path to thumbnail
  final List<String> tags; // e.g. ["Cozy", "Warm"]
  final List<StyleControl> controls;
  final String basePrompt; // The AI prompt fragment

  const StyleDefinition({
    required this.id,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.tags,
    required this.controls,
    required this.basePrompt,
  });
}
