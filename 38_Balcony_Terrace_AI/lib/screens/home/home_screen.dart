// lib/screens/home/home_screen.dart
// Night Terrace Inspiration Dashboard

import 'package:flutter/material.dart';
import '../../theme/terrace_theme.dart';
import 'widgets/tonight_header.dart';
import 'widgets/lantern_carousel.dart';
import 'widgets/space_selector.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Let bokeh show through
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 120), // Space for Glass Dock
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: TerraceAISpacing.xl),

              TonightHeader(
                onMoodSelected: (mood) {
                  // TODO: Filter content or start wizard with this mood
                  print('Selected mood: $mood');
                },
              ),

              const SizedBox(height: TerraceAISpacing.xxl),

              // Lantern Scenes Carousel
              const LanternCarousel(),

              const SizedBox(height: TerraceAISpacing.xxl),

              // Space Selector
              const SpaceSelector(),

              const SizedBox(height: TerraceAISpacing.xxl),

              // Inspiration Grid (Placeholder for "Featured Transformations")
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: TerraceAISpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Featured Makeovers', style: TerraceAIText.h2),
                    const SizedBox(height: TerraceAISpacing.lg),
                    _buildFeaturedCard(),
                    const SizedBox(height: TerraceAISpacing.lg),
                    _buildFeaturedCard(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedCard() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: TerraceAIColors.surface.withValues(alpha: 0.6),
        borderRadius: TerraceAIRadii.lgRadius,
        border: Border.all(color: TerraceAIColors.line),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_not_supported_rounded, color: TerraceAIColors.muted, size: 40),
            const SizedBox(height: 8),
            Text('Before / After', style: TerraceAIText.caption),
          ],
        ),
      ),
    );
  }
}
