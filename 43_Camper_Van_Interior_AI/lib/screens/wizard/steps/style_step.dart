import 'package:flutter/material.dart';
import '../../../theme/camper_tokens.dart';
import '../../../model/camper_style.dart';
import '../../../data/camper_styles_data.dart';
import '../wizard_controller.dart';
import '../widgets/moodboard_style_grid.dart';
import '../widgets/style_control_sheet.dart';

class StyleStep extends StatefulWidget {
  final WizardController controller;
  const StyleStep({super.key, required this.controller});

  @override
  State<StyleStep> createState() => _StyleStepState();
}

class _StyleStepState extends State<StyleStep> {
  String _searchQuery = "";

  List<CamperStyle> get _filteredStyles {
    if (_searchQuery.isEmpty) return CamperStylesData.styles;
    return CamperStylesData.styles.where((s) =>
      s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      s.tags.any((t) => t.toLowerCase().contains(_searchQuery.toLowerCase()))
    ).toList();
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
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, scrollController) => StyleControlSheet(
          style: style,
          currentValues: widget.controller.styleControlValues,
          onValueChanged: widget.controller.updateStyleControl,
          onApply: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        return Column(
          children: [
            // Search / Filter Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Search 30+ Styles (e.g. Scandi, Off-grid)",
                  filled: true,
                  fillColor: CamperTokens.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                ),
                onChanged: (val) => setState(() => _searchQuery = val),
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

            // Footer
            if (widget.controller.selectedStyleId != null)
              Container(
                padding: const EdgeInsets.all(16),
                color: CamperTokens.bg0.withValues(alpha: 0.9),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     TextButton.icon(
                       onPressed: () {
                         final style = CamperStylesData.styles.firstWhere((s) => s.id == widget.controller.selectedStyleId);
                         _showControlSheet(style);
                       },
                       icon: const Icon(Icons.tune),
                       label: const Text("Customize")
                     ),
                     ElevatedButton(
                       onPressed: widget.controller.nextStep,
                       style: ElevatedButton.styleFrom(
                         backgroundColor: CamperTokens.primary,
                         foregroundColor: Colors.black,
                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                       ),
                       child: const Row(
                         children: [Text("Next Step"), SizedBox(width: 8), Icon(Icons.arrow_forward)],
                       ),
                     )
                  ],
                ),
              )
          ],
        );
      },
    );
  }
}
