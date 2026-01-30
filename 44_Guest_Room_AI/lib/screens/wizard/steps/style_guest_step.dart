import 'package:flutter/material.dart';
import '../../theme/guest_theme.dart';
import '../../model/guest_style_definition.dart';
import '../../data/guest_styles.dart';
import '../../widgets/moodboard_style_card.dart';
import '../../widgets/style_control_sheet.dart';
import '../wizard_controller.dart';

class StyleGuestStep extends StatefulWidget {
  final WizardController controller;
  const StyleGuestStep({super.key, required this.controller});

  @override
  State<StyleGuestStep> createState() => _StyleGuestStepState();
}

class _StyleGuestStepState extends State<StyleGuestStep> {
  late List<GuestStyleDefinition> _styles;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _styles = getGuestStyles();
  }

  void _onStyleTap(GuestStyleDefinition style) {
    if (widget.controller.selectedStyleId == style.id) {
      _openControls(style);
    } else {
      widget.controller.selectStyle(style.id);
      // Optional: Initialize default controls if empty
      if (widget.controller.controlValues.isEmpty) {
        final defaults = <String, dynamic>{};
        for (var c in style.controls) {
          defaults[c.id] = c.defaultValue;
        }
        widget.controller.setControlValues(defaults);
      }
    }
  }

  void _openControls(GuestStyleDefinition style) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.85,
        child: StyleControlSheet(
          style: style,
          currentValues: widget.controller.controlValues,
          onValueChanged: (key, value) {
            widget.controller.setControlValue(key, value);
            // Force rebuild of sheet to show new values
            (context as Element).markNeedsBuild();
          },
          onApply: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredStyles = _styles.where((s) =>
      s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      s.tags.any((t) => t.toLowerCase().contains(_searchQuery.toLowerCase()))
    ).toList();

    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            onChanged: (v) => setState(() => _searchQuery = v),
            decoration: InputDecoration(
              hintText: "Search styles (e.g. Modern, Cozy)...",
              prefixIcon: const Icon(Icons.search, color: GuestAIColors.muted),
              filled: true,
              fillColor: GuestAIColors.pureWhite,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            ),
          ),
        ),

        // Grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: filteredStyles.length,
            itemBuilder: (context, index) {
              final style = filteredStyles[index];
              final isSelected = widget.controller.selectedStyleId == style.id;

              return MoodboardStyleCard(
                style: style,
                isSelected: isSelected,
                onTap: () => _onStyleTap(style),
              );
            },
          ),
        ),

        // Customize Button (Floating above grid if selected)
        if (widget.controller.selectedStyleId != null)
           Padding(
             padding: const EdgeInsets.all(16),
             child: ElevatedButton.icon(
               onPressed: () {
                 final style = _styles.firstWhere((s) => s.id == widget.controller.selectedStyleId);
                 _openControls(style);
               },
               icon: const Icon(Icons.tune),
               label: const Text("Customize Settings"),
               style: ElevatedButton.styleFrom(
                 backgroundColor: GuestAIColors.inkTitle,
                 foregroundColor: Colors.white,
                 minimumSize: const Size(double.infinity, 50),
               ),
             ),
           ),
      ],
    );
  }
}
