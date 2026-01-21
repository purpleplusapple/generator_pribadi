// lib/screens/wizard/steps/style_laundry_step.dart
// Style selection step with 6 category groups

import 'package:flutter/material.dart';
import '../../../theme/shoe_room_ai_theme.dart';
import '../../../widgets/glass_card.dart';
import '../../../widgets/laundry_chip.dart';
import '../wizard_controller.dart';

class StyleLaundryStep extends StatefulWidget {
  const StyleLaundryStep({
    super.key,
    required this.controller,
  });

  final WizardController controller;

  @override
  State<StyleLaundryStep> createState() => _StyleLaundryStepState();
}

class _StyleLaundryStepState extends State<StyleLaundryStep> {
  final Map<String, List<String>> _styleOptions = {
    'Interior Style': [
      'Modern',
      'Scandinavian',
      'Industrial',
      'Farmhouse',
      'Traditional',
    ],
    'Color Scheme': [
      'Light & Bright',
      'Dark & Moody',
      'Neutral',
      'Bold & Colorful',
    ],
    'Cabinet Style': [
      'Open Shelving',
      'Closed Cabinets',
      'Mixed',
      'Minimalist',
    ],
    'Countertop Material': [
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
          padding: const EdgeInsets.all(ShoeAISpacing.base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: ShoeAISpacing.lg),
              
              // Title
              Text(
                'Choose Your Style',
                style: ShoeAIText.h2,
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: ShoeAISpacing.sm),
              
              // Subtitle
              Text(
                'Select options from at least 2 categories to continue',
                style: ShoeAIText.body.copyWith(
                  color: ShoeAIColors.canvasWhite.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: ShoeAISpacing.base),
              
              // Selection counter
              GlassCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: ShoeAISpacing.md,
                  vertical: ShoeAISpacing.sm,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$selectedCount of ${_styleOptions.length} categories selected',
                      style: ShoeAIText.bodyMedium.copyWith(
                        color: selectedCount >= 2
                            ? ShoeAIColors.metallicGold
                            : ShoeAIColors.canvasWhite,
                      ),
                    ),
                    if (selectedCount > 0)
                      TextButton(
                        onPressed: _clearAllSelections,
                        child: Text(
                          'Clear All',
                          style: ShoeAIText.caption.copyWith(
                            color: ShoeAIColors.error,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              const SizedBox(height: ShoeAISpacing.xl),
              
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
            left: ShoeAISpacing.xs,
            bottom: ShoeAISpacing.sm,
          ),
          child: Text(
            category,
            style: ShoeAIText.h3.copyWith(fontSize: 18),
          ),
        ),
        
        // Chips
        SizedBox(
          height: 50,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: options.length + 1, // +1 for custom button
            separatorBuilder: (context, index) =>
                const SizedBox(width: ShoeAISpacing.sm),
            itemBuilder: (context, index) {
              // Last item is the custom button
              if (index == options.length) {
                return LaundryChip(
                  label: isCustomSelected ? selectedValue! : '+ Custom',
                  isSelected: isCustomSelected,
                  onTap: () => _showCustomDialog(category, selectedValue),
                  icon: isCustomSelected ? Icons.edit_rounded : Icons.add_rounded,
                );
              }
              
              final option = options[index];
              final isSelected = selectedValue == option;
              
              return LaundryChip(
                label: option,
                isSelected: isSelected,
                onTap: () => _onOptionSelected(category, option),
              );
            },
          ),
        ),
        
        const SizedBox(height: ShoeAISpacing.xl),
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
        backgroundColor: ShoeAIColors.soleBlack,
        title: Text(
          'Custom $category',
          style: ShoeAIText.h3,
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 50,
          style: ShoeAIText.body,
          decoration: InputDecoration(
            hintText: 'Enter your custom style...',
            hintStyle: ShoeAIText.body.copyWith(
              color: ShoeAIColors.canvasWhite.withValues(alpha: 0.5),
            ),
            filled: true,
            fillColor: ShoeAIColors.soleBlack,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: ShoeAIColors.leatherTan),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: ShoeAIColors.leatherTan, width: 2),
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
                foregroundColor: ShoeAIColors.error,
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
              foregroundColor: ShoeAIColors.leatherTan,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
