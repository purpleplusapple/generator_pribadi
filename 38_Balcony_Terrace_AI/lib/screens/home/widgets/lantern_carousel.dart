import 'package:flutter/material.dart';
import '../../../theme/terrace_theme.dart';
import '../../../widgets/glass_card.dart';

class LanternCarousel extends StatelessWidget {
  const LanternCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: TerraceAISpacing.xl),
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) {
          return _buildCard(index);
        },
      ),
    );
  }

  Widget _buildCard(int index) {
    final styles = [
      {'title': 'Lantern Lounge', 'desc': 'Warm amber glow with rattan seats'},
      {'title': 'Tropical Night', 'desc': 'Lush plants under string lights'},
      {'title': 'City Skyline', 'desc': 'Modern minimal with city view'},
      {'title': 'Boho Retreat', 'desc': 'Floor cushions and candles'},
    ];

    final style = styles[index];

    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: TerraceAISpacing.lg),
      child: Stack(
        children: [
          // Background (Placeholder gradient/color until images)
          Container(
            decoration: BoxDecoration(
              borderRadius: TerraceAIRadii.lgRadius,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  TerraceAIColors.surface2,
                  TerraceAIColors.surface,
                ],
              ),
              boxShadow: TerraceAIShadows.card,
            ),
          ),

          // Content Overlay
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(TerraceAISpacing.lg),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(TerraceAIRadii.lg),
                  bottomRight: Radius.circular(TerraceAIRadii.lg),
                ),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    style['title']!,
                    style: TerraceAIText.h3.copyWith(color: TerraceAIColors.ink0),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    style['desc']!,
                    style: TerraceAIText.small.copyWith(color: TerraceAIColors.ink1.withValues(alpha: 0.8)),
                  ),
                ],
              ),
            ),
          ),

          // Glow effect (Lantern)
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: TerraceAIColors.accent,
                boxShadow: TerraceAIShadows.amberGlow(opacity: 0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
