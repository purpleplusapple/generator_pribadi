// lib/model/study_style.dart
import 'study_control.dart';

class StudyStyle {
  final String id;
  final String name;
  final String description;
  final String moodboardAsset; // 2x2 collage SVG path
  final String tileAsset;      // Small tile path
  final List<String> chips;    // e.g. ["Focus", "Cozy"]
  final List<StudyControl> controls;

  const StudyStyle({
    required this.id,
    required this.name,
    required this.description,
    required this.moodboardAsset,
    required this.tileAsset,
    required this.chips,
    required this.controls,
  });
}
