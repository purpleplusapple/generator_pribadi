// lib/screens/wizard/steps/style_terrace_step.dart
// Advanced Style Step with Category Gallery and Controls

import 'package:flutter/material.dart';
import '../../../theme/terrace_theme.dart';
import '../../data/terrace_style_data.dart';
import '../../widgets/terrace_chip.dart';
import '../wizard_controller.dart';
import '../widgets/category_gallery.dart';
import '../widgets/category_control_sheet.dart';

class StyleTerraceStep extends StatefulWidget {
  const StyleTerraceStep({
    super.key,
    required this.controller,
  });

  final WizardController controller;

  @override
  State<StyleTerraceStep> createState() => _StyleTerraceStepState();
}

class _StyleTerraceStepState extends State<StyleTerraceStep> {
  TerraceStyleCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    // Restore selection if present
    final savedCategoryId = widget.controller.styleSelections['category_id'];
    if (savedCategoryId != null) {
      try {
        _selectedCategory = terraceCategories.firstWhere((c) => c.id == savedCategoryId);
      } catch (e) {
        // Category not found
      }
    }
  }

  void _onCategorySelected(TerraceStyleCategory category) {
    setState(() {
      _selectedCategory = category;
    });

    // Clear old selections if category changes (optional, but cleaner)
    // Actually, keep it simple. Overwrite 'category_id'.
    // We might want to clear other keys that don't match controls, but
    // for now we'll just set the new category.
    widget.controller.setStyleSelection('category_id', category.id);

    // Set defaults if not present
    for (var control in category.controls) {
      if (!widget.controller.styleSelections.containsKey(control.id) && control.defaultValue != null) {
        widget.controller.setStyleSelection(control.id, control.defaultValue!);
      }
    }

    _showControlSheet(category);
  }

  void _showControlSheet(TerraceStyleCategory category) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (_, scrollController) => CategoryControlSheet(
          category: category,
          currentValues: widget.controller.styleSelections,
          onValueChanged: (key, value) {
            widget.controller.setStyleSelection(key, value);
            // Force rebuild of sheet to show updates
            // In a real app we might use a state management solution closer to the widget
            // But since the controller notifies listeners, we need the sheet to listen?
            // The sheet is stateless (or has local state), but it takes currentValues.
            // Since we are inside the modal builder, it might not rebuild automatically when controller changes
            // unless we wrap it in a ListenableBuilder.
            (context as Element).markNeedsBuild();
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
            Padding(
              padding: const EdgeInsets.all(TerraceAISpacing.base),
              child: Text(
                'Choose Your Atmosphere',
                style: TerraceAIText.h2,
                textAlign: TextAlign.center,
              ),
            ),

            Expanded(
              child: CategoryGallery(
                selectedCategoryId: _selectedCategory?.id,
                onCategorySelected: _onCategorySelected,
              ),
            ),

            if (_selectedCategory != null)
              Padding(
                padding: const EdgeInsets.all(TerraceAISpacing.base),
                child: TerraceChip(
                  label: 'Customize ${_selectedCategory!.title}',
                  isSelected: true,
                  icon: Icons.tune_rounded,
                  onTap: () => _showControlSheet(_selectedCategory!),
                ),
              ),
          ],
        );
      },
    );
  }
}
