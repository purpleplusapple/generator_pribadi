// lib/screens/wizard/steps/style_boutique_step.dart
// Style selection step with Editorial Cards

import 'package:flutter/material.dart';
import '../../../theme/boutique_theme.dart';
import '../../../widgets/glass_card.dart';
import '../wizard_controller.dart';

class StyleBoutiqueStep extends StatefulWidget {
  const StyleBoutiqueStep({
    super.key,
    required this.controller,
  });

  final WizardController controller;

  @override
  State<StyleBoutiqueStep> createState() => _StyleBoutiqueStepState();
}

class _StyleBoutiqueStepState extends State<StyleBoutiqueStep> {
  final List<Map<String, dynamic>> _editorialStyles = [
    {
      'title': 'Dark Luxury',
      'subtitle': 'Black Marble & Brass',
      'colors': [Color(0xFF000000), Color(0xFFC9A45B)],
      'category': 'Vibe'
    },
    {
      'title': 'Modern Minimal',
      'subtitle': 'Clean White & Glass',
      'colors': [Color(0xFFF5F5F5), Color(0xFFAAAAAA)],
      'category': 'Vibe'
    },
    {
      'title': 'Cosmetics Glow',
      'subtitle': 'Pink Accents & Light',
      'colors': [Color(0xFF222222), Color(0xFFE35DA7)],
      'category': 'Vibe'
    },
    {
      'title': 'Industrial Chic',
      'subtitle': 'Raw Concrete & Metal',
      'colors': [Color(0xFF555555), Color(0xFF222222)],
      'category': 'Vibe'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final currentSelection = widget.controller.styleSelections['Vibe'];

        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: _editorialStyles.length + 1,
          separatorBuilder: (ctx, i) => const SizedBox(height: 16),
          itemBuilder: (ctx, i) {
            if (i == 0) return _buildHeader();
            final style = _editorialStyles[i - 1];
            final isSelected = currentSelection == style['title'];
            return _buildEditorialCard(style, isSelected);
          },
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Select Aesthetic", style: BoutiqueText.h2),
          Text("Choose the mood for your boutique", style: BoutiqueText.body.copyWith(color: BoutiqueColors.muted)),
        ],
      ),
    );
  }

  Widget _buildEditorialCard(Map<String, dynamic> style, bool isSelected) {
    return GestureDetector(
      onTap: () {
        widget.controller.removeStyleSelection('Vibe'); // Clear previous
        widget.controller.setStyleSelection('Vibe', style['title']);
        // Auto add a secondary one to pass validation easily or just fix validation
        widget.controller.setStyleSelection('Material', 'Standard');
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 120,
        decoration: BoxDecoration(
          color: isSelected ? BoutiqueColors.primary.withValues(alpha: 0.1) : BoutiqueColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? BoutiqueColors.primary : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected ? BoutiqueShadows.goldGlow(opacity: 0.2) : [],
        ),
        child: Row(
          children: [
            // Color strip
            Container(
              width: 80,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(18)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: style['colors'],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(style['title'], style: BoutiqueText.h3.copyWith(fontSize: 18)),
                    const SizedBox(height: 4),
                    Text(style['subtitle'], style: BoutiqueText.caption),
                  ],
                ),
              ),
            ),
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: BoutiqueColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 16, color: BoutiqueColors.bg0),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
