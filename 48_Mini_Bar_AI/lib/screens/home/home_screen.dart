// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import '../../theme/mini_bar_theme.dart';
import '../../theme/design_tokens.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Top offset for status bar
    return ListView(
      padding: const EdgeInsets.only(top: 24, bottom: 120), // 120 for dock space
      children: [
        _buildHeader(),
        const SizedBox(height: 32),
        _buildSectionTitle('Signature Bar Corners'),
        const SizedBox(height: 16),
        _buildSignatureCarousel(),
        const SizedBox(height: 32),
        _buildSectionTitle('Bar Zones'),
        const SizedBox(height: 16),
        _buildBarZones(),
        const SizedBox(height: 32),
        _buildSectionTitle('Lighting Scenes'),
        const SizedBox(height: 16),
        _buildLightingScenes(),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Good Evening,', style: MiniBarText.h3.copyWith(color: MiniBarColors.muted)),
          Text('Mini Bar Lounge', style: MiniBarText.h1),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildPourChip('Classic', true),
                _buildPourChip('Modern', false),
                _buildPourChip('Tropical', false),
                _buildPourChip('Zero-proof', false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPourChip(String label, bool active) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: active ? MiniBarColors.primary : MiniBarColors.surface2,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: active ? MiniBarColors.primary : MiniBarColors.line),
      ),
      child: Text(
        label,
        style: MiniBarText.chip.copyWith(
          color: active ? MiniBarColors.bg0 : MiniBarColors.ink1,
          fontWeight: active ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: MiniBarText.h3),
          Icon(Icons.arrow_forward, color: MiniBarColors.primary, size: 20),
        ],
      ),
    );
  }

  Widget _buildSignatureCarousel() {
    return SizedBox(
      height: 320,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) {
          return Container(
            width: 240,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: MiniBarColors.surface,
              borderRadius: BorderRadius.circular(MiniBarRadii.k24),
              border: Border.all(color: MiniBarColors.line.withValues(alpha: 0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(MiniBarRadii.k24)),
                    child: SvgPicture.asset(
                      'assets/examples/example_${index + 1}.svg',
                      fit: BoxFit.cover,
                      placeholderBuilder: (context) => Container(color: MiniBarColors.surface2),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Speakeasy Setup ${index + 1}', style: MiniBarText.h4),
                      const SizedBox(height: 4),
                      Text('Compact luxury corner', style: MiniBarText.small),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBarZones() {
    final zones = [
      {'icon': Icons.countertops, 'label': 'Counters'},
      {'icon': Icons.wine_bar, 'label': 'Bottle Wall'},
      {'icon': Icons.local_bar, 'label': 'Glassware'},
      {'icon': Icons.kitchen, 'label': 'Ice & Sink'},
    ];

    return SizedBox(
      height: 100,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: zones.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return Container(
            width: 100,
            decoration: BoxDecoration(
              color: MiniBarColors.surface2,
              borderRadius: BorderRadius.circular(MiniBarRadii.k18),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(zones[index]['icon'] as IconData, color: MiniBarColors.primary, size: 30),
                const SizedBox(height: 8),
                Text(zones[index]['label'] as String, style: MiniBarText.small),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLightingScenes() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          _buildLightingTile('Warm Amber', MiniBarColors.primary),
          _buildLightingTile('Neon Subtle', Colors.purpleAccent),
          _buildLightingTile('Candlelight', Colors.orangeAccent),
          _buildLightingTile('LED Cool', Colors.blueAccent),
        ],
      ),
    );
  }

  Widget _buildLightingTile(String label, Color color) {
    return Container(
      width: (160), // approximate
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MiniBarColors.surface,
        borderRadius: BorderRadius.circular(MiniBarRadii.k12),
        border: Border.all(color: MiniBarColors.line),
      ),
      child: Row(
        children: [
          Container(
            width: 16, height: 16,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle, boxShadow: [BoxShadow(color: color.withValues(alpha: 0.6), blurRadius: 8)]),
          ),
          const SizedBox(width: 12),
          Text(label, style: MiniBarText.bodyMedium),
        ],
      ),
    );
  }
}
