// lib/screens/wizard/steps/style_step.dart
// Style selection with Editorial Cards
// Option A: Boutique Linen

import 'package:flutter/material.dart';
import '../../../theme/hotel_room_ai_theme.dart';
import '../../../widgets/room_type_pill.dart';
import '../wizard_controller.dart';

class StyleStep extends StatefulWidget {
  const StyleStep({
    super.key,
    required this.controller,
  });

  final WizardController controller;

  @override
  State<StyleStep> createState() => _StyleStepState();
}

class _StyleStepState extends State<StyleStep> {
  // We'll map "Mood" to specific styles
  final List<MoodItem> _moods = [
    MoodItem("warm_boutique", "Warm Boutique", "Linen, Wood, Soft Light", "assets/mood_warm.jpg"),
    MoodItem("modern_luxury", "Modern Luxury", "Dark, Sleek, Gold Accents", "assets/mood_modern.jpg"),
    MoodItem("coastal_calm", "Coastal Calm", "White, Blue, Airy", "assets/mood_coastal.jpg"),
    MoodItem("japandi_zen", "Japandi Zen", "Minimal, Natural, Low", "assets/mood_japandi.jpg"),
    MoodItem("classic_grand", "Classic Grand", "Ornate, Rich, Velvet", "assets/mood_classic.jpg"),
    MoodItem("industrial_chic", "Industrial Chic", "Raw, Metal, Brick", "assets/mood_industrial.jpg"),
  ];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final currentStyle = widget.controller.styleSelections['Interior Style'];

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(HotelAISpacing.lg),
              child: Column(
                children: [
                  Text("Choose Aesthetic", style: HotelAIText.h2),
                  const SizedBox(height: 8),
                  Text(
                    "Select a mood board to define the room's character.",
                    style: HotelAIText.body.copyWith(color: HotelAIColors.muted),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: HotelAISpacing.lg),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _moods.length,
                itemBuilder: (context, index) {
                  final mood = _moods[index];
                  final isSelected = currentStyle == mood.name;

                  return _MoodCard(
                    mood: mood,
                    isSelected: isSelected,
                    onTap: () {
                      // We treat "Interior Style" as the primary key for now
                      if (isSelected) {
                        widget.controller.removeStyleSelection('Interior Style');
                      } else {
                        widget.controller.setStyleSelection('Interior Style', mood.name);
                        // Also set secondary params implicitly if needed
                      }
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class MoodItem {
  final String id;
  final String name;
  final String desc;
  final String image;
  MoodItem(this.id, this.name, this.desc, this.image);
}

class _MoodCard extends StatelessWidget {
  final MoodItem mood;
  final bool isSelected;
  final VoidCallback onTap;

  const _MoodCard({
    required this.mood,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: HotelAIRadii.mediumRadius,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: HotelAIColors.bg1,
          borderRadius: HotelAIRadii.mediumRadius,
          border: isSelected
              ? Border.all(color: HotelAIColors.primary, width: 2)
              : Border.all(color: Colors.transparent),
          boxShadow: isSelected ? HotelAIShadows.floating : HotelAIShadows.soft,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                child: Container(
                  color: HotelAIColors.primarySoft,
                  child: Stack(
                    children: [
                      Center(
                        child: Icon(
                          Icons.image,
                          color: HotelAIColors.muted.withValues(alpha: 0.5),
                        ),
                      ),
                      if (isSelected)
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: HotelAIColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check, color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mood.name,
                    style: HotelAIText.bodyMedium.copyWith(
                      color: isSelected ? HotelAIColors.primary : HotelAIColors.ink0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    mood.desc,
                    style: HotelAIText.caption,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
