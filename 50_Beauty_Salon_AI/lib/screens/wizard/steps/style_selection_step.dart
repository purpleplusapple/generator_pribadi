import 'package:flutter/material.dart';
import '../../../theme/beauty_salon_ai_theme.dart';
import '../../../widgets/editorial_look_card.dart'; // New component
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
          padding: const EdgeInsets.only(bottom: 100), // Space for bottom bar
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(BeautyAISpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Curate Your Look',
                      style: BeautyAIText.h2,
                    ),
                    const SizedBox(height: BeautyAISpacing.sm),
                    Text(
                      'Select at least 2 elements to define your salon\'s aesthetic.',
                      style: BeautyAIText.body.copyWith(color: BeautyAIColors.muted),
                    ),
                    const SizedBox(height: BeautyAISpacing.md),
                    // Selection counter pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: BeautyAIColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle, size: 16, color: BeautyAIColors.primary),
                          const SizedBox(width: 8),
                          Text(
                            '$selectedCount selected',
                            style: BeautyAIText.caption.copyWith(color: BeautyAIColors.primary, fontWeight: FontWeight.bold),
                          ),
                          if (selectedCount > 0) ...[
                            const SizedBox(width: 12),
                            GestureDetector(
                              onTap: _clearAllSelections,
                              child: Text(
                                'Clear',
                                style: BeautyAIText.caption.copyWith(color: BeautyAIColors.muted),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: BeautyAISpacing.lg, vertical: BeautyAISpacing.sm),
          child: Text(
            category.toUpperCase(),
            style: BeautyAIText.caption.copyWith(letterSpacing: 1.2, fontWeight: FontWeight.bold),
          ),
        ),

        SizedBox(
          height: 140, // Height for EditorialLookCard
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: BeautyAISpacing.lg),
            itemCount: options.length,
            separatorBuilder: (context, index) => const SizedBox(width: BeautyAISpacing.md),
            itemBuilder: (context, index) {
              final option = options[index];
              final isSelected = selectedValue == option;

              return SizedBox(
                width: 120,
                child: EditorialLookCard(
                  title: option,
                  subtitle: 'Tap to select',
                  icon: _getIconForCategory(category), // Dynamic icon
                  isSelected: isSelected,
                  onTap: () => _onOptionSelected(category, option),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: BeautyAISpacing.xl),
      ],
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Interior Style': return Icons.chair_alt_rounded;
      case 'Color Scheme': return Icons.palette_outlined;
      case 'Storage / Cabinetry': return Icons.shelves;
      case 'Workstation Surface': return Icons.table_bar_rounded;
      case 'Flooring': return Icons.grid_on_rounded;
      case 'Lighting': return Icons.lightbulb_outline_rounded;
      default: return Icons.star_outline_rounded;
    }
  }
}
