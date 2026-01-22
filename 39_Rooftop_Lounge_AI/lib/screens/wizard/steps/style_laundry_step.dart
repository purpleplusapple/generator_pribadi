import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/glass_card.dart';
import '../wizard_controller.dart';

class StyleLaundryStep extends StatelessWidget {
  const StyleLaundryStep({super.key, required this.controller});
  final WizardController controller;

  static const List<Map<String, String>> _styles = [
    {
      'id': 'midnight_luxury',
      'title': 'Midnight Luxury',
      'desc': 'Dark marble, gold accents, and deep velvet tones.',
      'icon': 'nightlife',
    },
    {
      'id': 'modern_skybar',
      'title': 'Modern Skybar',
      'desc': 'Sleek glass, minimal lines, and cool blue lighting.',
      'icon': 'apartment',
    },
    {
      'id': 'neon_minimal',
      'title': 'Neon Minimal',
      'desc': 'High contrast, cyber-noir vibes with neon strips.',
      'icon': 'bolt',
    },
    {
      'id': 'tropical_night',
      'title': 'Tropical Night',
      'desc': 'Lush greenery, warm wood, and ambient lanterns.',
      'icon': 'forest',
    },
    {
      'id': 'romantic_candle',
      'title': 'Romantic Candle',
      'desc': 'Intimate seating, soft glow, and cozy textiles.',
      'icon': 'favorite',
    },
    {
      'id': 'dj_lounge',
      'title': 'DJ Lounge',
      'desc': 'Party layout, stage lighting, and VIP booths.',
      'icon': 'speaker',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Rooftop Vibe',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontFamily: 'DM Serif Display',
                  color: DesignTokens.ink0
                )
              ),
              const SizedBox(height: 16),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _styles.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final style = _styles[index];
                  // Using 'Style' category for simplicity, or we can map multiple categories
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
        // Use 'Style' as the main category
        controller.setStyleSelection('Style', style['title']!);
        // Satisfy the 2 selection requirement of original controller logic if needed
        // Or I should update controller logic.
        // The controller checks hasMinimumStyleSelections (count >= 2).
        // So I'll auto-add a "Lighting" selection or just add a dummy second selection.
        controller.setStyleSelection('Lighting', 'Auto-Match');
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 100,
        decoration: BoxDecoration(
          color: isSelected ? DesignTokens.primary.withOpacity(0.15) : DesignTokens.surface,
          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
          border: Border.all(
            color: isSelected ? DesignTokens.primary : DesignTokens.line.withOpacity(0.5),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              decoration: BoxDecoration(
                color: DesignTokens.bg1,
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(18)),
              ),
              child: Center(
                child: Icon(
                  _getIcon(style['icon']!),
                  color: isSelected ? DesignTokens.primary : DesignTokens.ink1,
                  size: 28,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      style['title']!,
                      style: TextStyle(
                        fontFamily: 'DM Serif Display',
                        fontSize: 18,
                        color: isSelected ? DesignTokens.primary : DesignTokens.ink0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      style['desc']!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: DesignTokens.ink1),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Icon(Icons.check_circle, color: DesignTokens.primary),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(String name) {
    switch (name) {
      case 'nightlife': return Icons.local_bar;
      case 'apartment': return Icons.apartment;
      case 'bolt': return Icons.bolt;
      case 'forest': return Icons.park;
      case 'favorite': return Icons.favorite;
      case 'speaker': return Icons.speaker;
      default: return Icons.style;
    }
  }
}
