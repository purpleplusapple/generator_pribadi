import 'package:flutter/material.dart';
import '../../model/beauty_config.dart';
import '../../theme/beauty_theme.dart';
import '../../widgets/cards/moodboard_style_card.dart';
import '../../widgets/sheets/style_control_sheet.dart';

class StyleMoodboardStep extends StatefulWidget {
  final String? selectedStyleId;
  final Map<String, dynamic> controlValues;
  final Function(String styleId, Map<String, dynamic> values) onStyleSelected;

  const StyleMoodboardStep({
    super.key,
    required this.selectedStyleId,
    required this.controlValues,
    required this.onStyleSelected,
  });

  @override
  State<StyleMoodboardStep> createState() => _StyleMoodboardStepState();
}

class _StyleMoodboardStepState extends State<StyleMoodboardStep> {
  String _searchQuery = '';
  String _activeFilter = 'All';

  List<BeautyStyle> get _filteredStyles {
    final query = _searchQuery.toLowerCase();
    return BeautyStylePresets.all.where((s) {
      final matchesSearch = s.name.toLowerCase().contains(query) ||
                          s.description.toLowerCase().contains(query);
      if (!matchesSearch) return false;

      if (_activeFilter == 'All') return true;
      // Simple logic for filters based on name keywords
      if (_activeFilter == 'Luxury' && (s.name.contains('Luxe') || s.name.contains('Gold') || s.name.contains('Premium'))) return true;
      if (_activeFilter == 'Minimal' && (s.name.contains('Minimal') || s.name.contains('Clean') || s.name.contains('Scandi'))) return true;
      if (_activeFilter == 'Cozy' && (s.name.contains('Warm') || s.name.contains('Cozy') || s.name.contains('Boho'))) return true;

      return false;
    }).toList();
  }

  void _handleStyleTap(BeautyStyle style) {
    // 1. Select the style
    // 2. Open the Control Sheet immediately

    // Initialize default values for this style if not present
    final Map<String, dynamic> newValues = Map.from(widget.controlValues);
    for (var control in style.controls) {
      if (!newValues.containsKey(control.id)) {
        newValues[control.id] = control.defaultValue;
      }
    }

    widget.onStyleSelected(style.id, newValues);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StyleControlSheet(
        style: style,
        currentValues: newValues,
        onUpdate: (key, value) {
          // Update local state in sheet is handled by sheet, but we need to propagate up
          final updated = Map<String, dynamic>.from(widget.controlValues);
          updated[key] = value;
          widget.onStyleSelected(style.id, updated);
        },
        onApply: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose Aesthetic',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),

        // Search & Filter
        TextField(
          decoration: InputDecoration(
            hintText: 'Search styles (e.g. "Pink", "Minimal")',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          ),
          onChanged: (val) => setState(() => _searchQuery = val),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ['All', 'Luxury', 'Minimal', 'Cozy'].map((filter) {
              final isActive = _activeFilter == filter;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(filter),
                  selected: isActive,
                  onSelected: (val) => setState(() => _activeFilter = filter),
                  selectedColor: BeautyTheme.primary,
                  labelStyle: TextStyle(
                    color: isActive ? Colors.white : BeautyTheme.ink1,
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 16),

        // Grid
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _filteredStyles.length + 1, // +1 for Custom
            itemBuilder: (context, index) {
              if (index == 0) {
                 return MoodboardStyleCard(
                  style: BeautyStylePresets.customStyle,
                  isSelected: widget.selectedStyleId == 'custom',
                  onTap: () => _handleStyleTap(BeautyStylePresets.customStyle),
                );
              }
              final style = _filteredStyles[index - 1];
              return MoodboardStyleCard(
                style: style,
                isSelected: widget.selectedStyleId == style.id,
                onTap: () => _handleStyleTap(style),
              );
            },
          ),
        ),
      ],
    );
  }
}
