import 'package:flutter/material.dart';
import '../../../theme/apartment_tokens.dart';
import '../wizard_controller.dart';

class StyleApartmentStep extends StatelessWidget {
  const StyleApartmentStep({super.key, required this.controller});
  final WizardController controller;

  static const List<Map<String, String>> _styles = [
    {
      'id': 'scandi_compact',
      'title': 'Scandi Compact',
      'desc': 'Clean lines, bright whites, and functional wood.',
      'icon': 'chair',
      'tag': 'Bright',
    },
    {
      'id': 'japandi_calm',
      'title': 'Japandi Calm',
      'desc': 'Fusion of Japanese rustic minimalism and Scandi.',
      'icon': 'spa',
      'tag': 'Zen',
    },
    {
      'id': 'warm_modern',
      'title': 'Warm Modern',
      'desc': 'Cozy textures, earth tones, and inviting layouts.',
      'icon': 'weekend',
      'tag': 'Cozy',
    },
    {
      'id': 'minimal_micro',
      'title': 'Minimal Micro',
      'desc': 'Extreme minimalism to make small spaces feel huge.',
      'icon': 'check_box_outline_blank',
      'tag': 'Spacious',
    },
    {
      'id': 'loft_style',
      'title': 'Loft-Style',
      'desc': 'Industrial touches, metal accents, and high contrast.',
      'icon': 'domain',
      'tag': 'Trendy',
    },
    {
      'id': 'wfh_studio',
      'title': 'Work-From-Home',
      'desc': 'Optimized for productivity without sacrificing comfort.',
      'icon': 'laptop_mac',
      'tag': 'Productive',
    },
    {
      'id': 'hidden_bed',
      'title': 'Hidden Bed',
      'desc': 'Murphy beds and convertible furniture focus.',
      'icon': 'bed',
      'tag': 'Smart',
    },
    {
      'id': 'rental_friendly',
      'title': 'Rental Friendly',
      'desc': 'No drilling, freestanding storage, removable decor.',
      'icon': 'home',
      'tag': 'Safe',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(ApartmentTokens.s16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose your Studio Style',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ApartmentTokens.ink0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Select a vibe to transform your space.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: ApartmentTokens.ink1,
                ),
              ),
              const SizedBox(height: ApartmentTokens.s24),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _styles.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: ApartmentTokens.s12,
                  mainAxisSpacing: ApartmentTokens.s12,
                ),
                itemBuilder: (context, index) {
                  final style = _styles[index];
                  final isSelected = controller.styleSelections['Style'] == style['title'];
                  return _buildStyleCard(context, style, isSelected);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStyleCard(BuildContext context, Map<String, String> style, bool isSelected) {
    return GestureDetector(
      onTap: () {
        controller.setStyleSelection('Style', style['title']!);
        // Auto-select a lighting match to satisfy typical "2 selections" logic if present in controller
        // or just to provide richer prompt context.
        controller.setStyleSelection('Lighting', 'Natural Daylight');
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? ApartmentTokens.primarySoft : ApartmentTokens.surface,
          borderRadius: BorderRadius.circular(ApartmentTokens.r16),
          border: Border.all(
            color: isSelected ? ApartmentTokens.primary : ApartmentTokens.line,
            width: isSelected ? 2 : 1,
          ),
        ),
        padding: const EdgeInsets.all(ApartmentTokens.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  _getIcon(style['icon']!),
                  color: isSelected ? ApartmentTokens.primary : ApartmentTokens.muted,
                  size: 28,
                ),
                if (isSelected)
                  const Icon(Icons.check_circle, color: ApartmentTokens.primary, size: 20),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: ApartmentTokens.bg0,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    style['tag']!,
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: ApartmentTokens.ink0),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  style['title']!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isSelected ? ApartmentTokens.primary : ApartmentTokens.ink0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  style['desc']!,
                  style: const TextStyle(fontSize: 11, color: ApartmentTokens.muted),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(String name) {
    switch (name) {
      case 'chair': return Icons.chair_alt;
      case 'spa': return Icons.spa;
      case 'weekend': return Icons.weekend;
      case 'check_box_outline_blank': return Icons.check_box_outline_blank;
      case 'domain': return Icons.domain;
      case 'laptop_mac': return Icons.laptop_mac;
      case 'bed': return Icons.bed;
      case 'home': return Icons.home;
      default: return Icons.style;
    }
  }
}
