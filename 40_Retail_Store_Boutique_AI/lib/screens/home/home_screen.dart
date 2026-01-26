// lib/screens/home/home_screen.dart
// Merchandising Editorial Home Screen

import 'package:flutter/material.dart';
import '../../theme/boutique_theme.dart';
import '../../widgets/glass_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // We add bottom padding for the floating dock
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),

              _buildSectionTitle("Featured Layouts"),
              const SizedBox(height: 16),
              const _FeaturedLayoutCarousel(),

              const SizedBox(height: 32),

              _buildSectionTitle("Store Zones"),
              const SizedBox(height: 16),
              const _ZoneRowCards(),

              const SizedBox(height: 32),

              _buildSectionTitle("Lighting & Materials"),
              const SizedBox(height: 16),
              const _LightingMaterialsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const _BoutiqueSnapshotHeader();
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: BoutiqueText.h3.copyWith(fontSize: 18),
        ),
        Icon(Icons.arrow_forward_ios, size: 14, color: BoutiqueColors.muted),
      ],
    );
  }
}

class _BoutiqueSnapshotHeader extends StatelessWidget {
  const _BoutiqueSnapshotHeader();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: BoutiqueColors.primary.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.storefront, color: BoutiqueColors.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("MY BOUTIQUE", style: BoutiqueText.caption.copyWith(letterSpacing: 2)),
                    Text("Luxury Fashion Store", style: BoutiqueText.h2),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildStat("Display Score", "92%"),
              _buildVerticalDivider(),
              _buildStat("Flow Rating", "A+"),
              _buildVerticalDivider(),
              _buildStat("Lighting", "Warm"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 30,
      width: 1,
      color: BoutiqueColors.line,
      margin: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  Widget _buildStat(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: BoutiqueText.caption.copyWith(fontSize: 10)),
          const SizedBox(height: 4),
          Text(value, style: BoutiqueText.h3.copyWith(color: BoutiqueColors.ink0)),
        ],
      ),
    );
  }
}

class _FeaturedLayoutCarousel extends StatelessWidget {
  const _FeaturedLayoutCarousel();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: ListView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        children: [
          _buildCard("Spring Collection", "Front Window", Icons.star, Colors.purple),
          const SizedBox(width: 16),
          _buildCard("Minimalist Rack", "Aisle View", Icons.checkroom, Colors.blue),
          const SizedBox(width: 16),
          _buildCard("Luxury Counter", "Checkout", Icons.point_of_sale, Colors.amber),
        ],
      ),
    );
  }

  Widget _buildCard(String title, String subtitle, IconData icon, Color accent) {
    return Container(
      width: 180,
      decoration: BoxDecoration(
        color: BoutiqueColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: BoutiqueColors.line),
        boxShadow: BoutiqueShadows.card,
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Icon(icon, size: 100, color: accent.withValues(alpha: 0.1)),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: accent, size: 20),
                ),
                const SizedBox(height: 12),
                Text(title, style: BoutiqueText.h3.copyWith(fontSize: 16)),
                Text(subtitle, style: BoutiqueText.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ZoneRowCards extends StatelessWidget {
  const _ZoneRowCards();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildRowItem("Entrance Area", "High Traffic", Icons.meeting_room),
        const SizedBox(height: 12),
        _buildRowItem("Display Wall", "Visual Merchandising", Icons.grid_view),
        const SizedBox(height: 12),
        _buildRowItem("Fitting Room", "Customer Experience", Icons.curtains),
      ],
    );
  }

  Widget _buildRowItem(String title, String subtitle, IconData icon) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: BorderRadius.circular(16),
      child: Row(
        children: [
          Icon(icon, color: BoutiqueColors.ink1, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: BoutiqueText.bodyMedium),
                Text(subtitle, style: BoutiqueText.caption.copyWith(fontSize: 11)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: BoutiqueColors.bg0,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text("Edit", style: BoutiqueText.small.copyWith(color: BoutiqueColors.primary)),
          ),
        ],
      ),
    );
  }
}

class _LightingMaterialsSection extends StatelessWidget {
  const _LightingMaterialsSection();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _buildChip("Warm Spotlight", true),
        _buildChip("Black Marble", false),
        _buildChip("Brass Accents", false),
        _buildChip("Velvet Finish", false),
        _buildChip("Soft Glow", false),
      ],
    );
  }

  Widget _buildChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? BoutiqueColors.primary.withValues(alpha: 0.2) : BoutiqueColors.surface2,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? BoutiqueColors.primary : BoutiqueColors.line,
        ),
      ),
      child: Text(
        label,
        style: BoutiqueText.small.copyWith(
          color: isSelected ? BoutiqueColors.primary : BoutiqueColors.ink1,
        ),
      ),
    );
  }
}
