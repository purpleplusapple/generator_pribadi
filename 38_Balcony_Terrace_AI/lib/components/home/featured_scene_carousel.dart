import 'package:flutter/material.dart';
import '../../theme/terrace_theme.dart';
// import 'package:flutter_svg/flutter_svg.dart'; // We are using placeholder SvgPicture if needed, but simple Containers with decoration are safer for now without external package dep verification, though flutter_svg is standard.
// Actually, pubspec has flutter_svg? No, wait.
// 32_shoe_room_ai/pubspec.yaml did NOT have flutter_svg.
// I should check if I added it? No.
// I will use Image.asset or just Containers with Colors for now, or Image.network if I had URLs.
// Wait, my generated assets are SVGs. I need flutter_svg package to render them easily, OR I can just use Image.asset if they are raster, but they are .svg.
// Does Flutter support SVG out of the box? No.
// I should add flutter_svg to pubspec if I want to use the .svg files I generated.
// Or I can rewrite my generator to produce .png (binary) but that's hard in python script without libraries like PIL available in the sandbox.
// Actually, I can use `flutter_svg` package. It's very common.

// Let me check pubspec.yaml again to see if I can add it.
// I will add flutter_svg to pubspec.yaml.

class FeaturedSceneCarousel extends StatelessWidget {
  const FeaturedSceneCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: TerraceSpacing.base),
        itemCount: 5,
        itemBuilder: (context, index) {
          return _FeaturedCard(index: index);
        },
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  final int index;

  const _FeaturedCard({required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      margin: const EdgeInsets.only(right: TerraceSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(TerraceTokens.radiusLarge),
        color: TerraceColors.surface,
        image: const DecorationImage(
          image: AssetImage('assets/examples/example_scene_1.svg'), // Placeholder
          fit: BoxFit.cover,
        ),
        boxShadow: TerraceShadows.card,
      ),
      child: Stack(
        children: [
          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(TerraceTokens.radiusLarge),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.8),
                ],
              ),
            ),
          ),
          // Text
          Positioned(
            bottom: TerraceSpacing.lg,
            left: TerraceSpacing.lg,
            right: TerraceSpacing.lg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: TerraceColors.metallicGold,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'TRENDING',
                    style: TerraceText.small.copyWith(
                      color: TerraceColors.soleBlack,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Urban Oasis ${index + 1}',
                  style: TerraceText.h3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
