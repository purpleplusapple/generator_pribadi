// lib/screens/wizard/steps/style_selection_step.dart
// Style selection step with 6 category groups

import 'package:flutter/material.dart';
import '../../../theme/beauty_salon_ai_theme.dart';
import '../../../widgets/glass_card.dart';
import '../../../widgets/style_chip.dart';
import '../wizard_controller.dart';

class StyleSelectionStep extends StatefulWidget {
  const StyleSelectionStep({
    super.key,
    required this.controller,
  });

  final WizardController controller;

  @override
  State<StyleSelectionStep> createState() => _StyleSelectionStepState();
}

class _StyleSelectionStepState extends State<StyleSelectionStep> {
  final Map<String, List<String>> _styleOptions = {
    'Interior Style': [
      'Modern',
      'Scandinavian',
      'Industrial',
      'Boho Chic',
      'Classic Elegant',
    ],
    'Color Scheme': [
      'Light & Bright',
      'Dark & Moody',
      'Neutral',
      'Bold & Colorful',
    ],
    'Storage / Cabinetry': [
      'Open Shelving',
      'Closed Cabinets',
      'Mixed',
      'Minimalist',
    ],
    'Workstation Surface': [
      'Quartz',
      'Marble',
      'Wood',
      'Concrete',
      'Laminate',
    ],
    'Flooring': [
      'Tile',
      'Wood',
      'Vinyl',
      'Concrete',
    ],
    'Lighting': [
      'Bright & Even',
      'Warm & Ambient',
      'Task Lighting',
      'Natural Light',
    ],
  };

  void _onOptionSelected(String category, String value) {
    widget.controller.setStyleSelection(category, value);
  }

  void _clearAllSelections() {
    final categories = _styleOptions.keys.toList();
    for (final category in categories) {
      widget.controller.removeStyleSelection(category);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final selections = widget.controller.styleSelections;
        final selectedCount = selections.length;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(BeautyAISpacing.base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: BeautyAISpacing.lg),

              // Title
              Text(
                'Choose Your Style',
                style: BeautyAIText.h2,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: BeautyAISpacing.sm),

              // Subtitle
              Text(
                'Select options from at least 2 categories to continue',
                style: BeautyAIText.body.copyWith(
                  color: BeautyAIColors.creamWhite.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: BeautyAISpacing.base),

              // Selection counter
              GlassCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: BeautyAISpacing.md,
                  vertical: BeautyAISpacing.sm,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$selectedCount of ${_styleOptions.length} categories selected',
                      style: BeautyAIText.bodyMedium.copyWith(
                        color: selectedCount >= 2
                            ? BeautyAIColors.metallicGold
                            : BeautyAIColors.creamWhite,
                      ),
                    ),
                    if (selectedCount > 0)
                      TextButton(
                        onPressed: _clearAllSelections,
                        child: Text(
                          'Clear All',
                          style: BeautyAIText.caption.copyWith(
                            color: BeautyAIColors.error,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: BeautyAISpacing.xl),

              // Category groups
              ..._styleOptions.entries.map((entry) {
                return _buildCategoryGroup(
                  entry.key,
                  entry.value,
                  selections[entry.key],
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryGroup(
    String category,
    List<String> options,
    String? selectedValue,
  ) {
    // Check if selected value is custom (not in predefined options)
    final isCustomSelected = selectedValue != null && !options.contains(selectedValue);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category title
        Padding(
          padding: const EdgeInsets.only(
            left: BeautyAISpacing.xs,
            bottom: BeautyAISpacing.sm,
          ),
          child: Text(
            category,
            style: BeautyAIText.h3.copyWith(fontSize: 18),
          ),
        ),

        // Chips
        SizedBox(
          height: 50,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: options.length + 1, // +1 for custom button
            separatorBuilder: (context, index) =>
                const SizedBox(width: BeautyAISpacing.sm),
            itemBuilder: (context, index) {
              // Last item is the custom button
              if (index == options.length) {
                return StyleChip(
                  label: isCustomSelected ? selectedValue! : '+ Custom',
                  isSelected: isCustomSelected,
                  onTap: () => _showCustomDialog(category, selectedValue),
                  icon: isCustomSelected ? Icons.edit_rounded : Icons.add_rounded,
                );
              }

              final option = options[index];
              final isSelected = selectedValue == option;

              return StyleChip(
                label: option,
                isSelected: isSelected,
                onTap: () => _onOptionSelected(category, option),
              );
            },
          ),
        ),

        const SizedBox(height: BeautyAISpacing.xl),
      ],
    );
  }

  void _showCustomDialog(String category, String? currentValue) {
    final controller = TextEditingController(
      text: currentValue != null && !_styleOptions[category]!.contains(currentValue)
          ? currentValue
          : '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: BeautyAIColors.creamWhite,
        title: Text(
          'Custom $category',
          style: BeautyAIText.h3,
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 50,
          style: BeautyAIText.body,
          decoration: InputDecoration(
            hintText: 'Enter your custom style...',
            hintStyle: BeautyAIText.body.copyWith(
              color: BeautyAIColors.charcoal.withValues(alpha: 0.5),
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: BeautyAIColors.roseGold),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: BeautyAIColors.roseGold, width: 2),
            ),
          ),
        ),
        actions: [
          if (currentValue != null && !_styleOptions[category]!.contains(currentValue))
            TextButton(
              onPressed: () {
                widget.controller.removeStyleSelection(category);
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: BeautyAIColors.error,
              ),
              child: const Text('Remove'),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                widget.controller.setStyleSelection(category, text);
              }
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: BeautyAIColors.roseGold,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
