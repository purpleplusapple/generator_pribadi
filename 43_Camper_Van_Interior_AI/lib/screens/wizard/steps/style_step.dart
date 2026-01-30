// lib/screens/wizard/steps/style_step.dart
// Style selection step with Moodboard Grid

import 'package:flutter/material.dart';
import '../../../theme/camper_theme.dart';
import '../../../data/camper_styles_data.dart';
import '../../../model/camper_style_def.dart';
import '../wizard_controller.dart';
import '../widgets/moodboard_style_grid.dart';
import '../widgets/style_control_sheet.dart';

class StyleStep extends StatefulWidget {
  const StyleStep({
    super.key,
    required this.controller,
  });

  final WizardController controller;

  @override
  State<StyleStep> createState() => _StyleStepState();
}

class _StyleStepState extends State<StyleStep> {
  String _searchQuery = "";

  List<CamperStyle> get _filteredStyles {
    if (_searchQuery.isEmpty) return CamperStylesData.styles;
    return CamperStylesData.styles.where((s) {
      return s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.tags.any((t) => t.toLowerCase().contains(_searchQuery.toLowerCase()));
    }).toList();
  }

  void _onStyleSelected(CamperStyle style) {
    widget.controller.setSelectedStyle(style.id);
    _showControlSheet(style);
  }

  void _showControlSheet(CamperStyle style) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (_, scrollController) => StyleControlSheet(
          style: style,
          currentValues: widget.controller.styleParams,
          onUpdate: (key, val) {
             setState(() {
               widget.controller.updateStyleParam(key, val);
             });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search & Filter Bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: "Search styles (e.g. 'Cozy', 'Solar', 'Wood')...",
              prefixIcon: const Icon(Icons.search, color: CamperAIColors.muted),
              filled: true,
              fillColor: CamperAIColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),

        // Grid
        Expanded(
          child: MoodboardStyleGrid(
            styles: _filteredStyles,
            selectedStyleId: widget.controller.selectedStyleId,
            onStyleSelected: _onStyleSelected,
          ),
        ),
      ],
    );
  }
}
