import 'package:flutter/material.dart';
import '../theme/apartment_tokens.dart';

class StudioSizeSelector extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onSelected;

  const StudioSizeSelector({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> sizes = const [
    '18m² Micro',
    '24m² Studio',
    '30m² Spacious',
    'Custom',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: ApartmentTokens.s16),
          child: Text(
            'How big is your studio?',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: ApartmentTokens.s12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: ApartmentTokens.s16),
          child: Row(
            children: sizes.asMap().entries.map((entry) {
              final isSelected = entry.key == selectedIndex;
              return Padding(
                padding: const EdgeInsets.only(right: ApartmentTokens.s8),
                child: FilterChip(
                  label: Text(entry.value),
                  selected: isSelected,
                  onSelected: (_) => onSelected(entry.key),
                  backgroundColor: ApartmentTokens.bg1,
                  selectedColor: ApartmentTokens.primarySoft,
                  labelStyle: TextStyle(
                    color: isSelected ? ApartmentTokens.primary : ApartmentTokens.ink1,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ApartmentTokens.rMax),
                    side: BorderSide(
                      color: isSelected ? ApartmentTokens.primary : ApartmentTokens.line,
                    ),
                  ),
                  showCheckmark: false,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
