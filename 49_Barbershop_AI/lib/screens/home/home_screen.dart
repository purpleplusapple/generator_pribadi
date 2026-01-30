// lib/screens/home/home_screen.dart
// Shop Floor Planner Home Screen

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme/barber_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BarberTheme.bg0,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100), // Space for dock
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _BarberStudioHeader(),
              const SizedBox(height: 32),

              const _SectionTitle(title: "Featured Shops"),
              const SizedBox(height: 16),
              const _FeaturedShopCarousel(),

              const SizedBox(height: 32),
              const _SectionTitle(title: "Shop Zones"),
              const SizedBox(height: 16),
              const _ZoneRowCards(),

              const SizedBox(height: 32),
              const _SectionTitle(title: "Lighting & Materials"),
              const SizedBox(height: 16),
              const _LightingMaterialsTiles(),

              const SizedBox(height: 32),
              // Quick Start Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: BarberTheme.primarySoft,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: BarberTheme.primary.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: BarberTheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add_rounded, color: BarberTheme.bg0),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Start New Design",
                          style: BarberTheme.themeData.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Upload photo or use template",
                          style: BarberTheme.themeData.textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        title,
        style: BarberTheme.themeData.textTheme.headlineMedium,
      ),
    );
  }
}

class _BarberStudioHeader extends StatelessWidget {
  const _BarberStudioHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.chair_rounded, color: BarberTheme.primary, size: 28),
              const SizedBox(width: 12),
              Text(
                "Signature Chair Setup",
                style: BarberTheme.themeData.textTheme.displaySmall,
              ),
            ],
          ),
          const SizedBox(height: 24),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _Chip(label: "Classic", isSelected: true),
                _Chip(label: "Modern"),
                _Chip(label: "Industrial"),
                _Chip(label: "Luxury"),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _Chip({required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? BarberTheme.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isSelected ? BarberTheme.primary : BarberTheme.line,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? BarberTheme.bg0 : BarberTheme.ink1,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _FeaturedShopCarousel extends StatelessWidget {
  const _FeaturedShopCarousel();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 380,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            width: 260,
            margin: const EdgeInsets.only(right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      color: BarberTheme.surface2,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          SvgPicture.asset(
                            'assets/examples/shop_0${(index % 9) + 1}.svg',
                            fit: BoxFit.cover,
                            placeholderBuilder: (ctx) => Center(
                              child: CircularProgressIndicator(color: BarberTheme.primary),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 16,
                            left: 16,
                            right: 16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Heritage ${index+1}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Playfair Display',
                                  ),
                                ),
                                Text(
                                  "3 Chairs • Wood & Chrome",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ZoneRowCards extends StatelessWidget {
  const _ZoneRowCards();

  @override
  Widget build(BuildContext context) {
    final zones = [
      {'icon': Icons.chair_alt, 'label': 'Chairs'},
      {'icon': Icons.crop_portrait, 'label': 'Mirrors'},
      {'icon': Icons.water_drop_outlined, 'label': 'Wash'},
      {'icon': Icons.weekend_outlined, 'label': 'Lounge'},
    ];

    return SizedBox(
      height: 110,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: zones.length,
        separatorBuilder: (_,__) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return Container(
            width: 100,
            decoration: BoxDecoration(
              color: BarberTheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: BarberTheme.line),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(zones[index]['icon'] as IconData, color: BarberTheme.muted, size: 32),
                const SizedBox(height: 8),
                Text(
                  zones[index]['label'] as String,
                  style: BarberTheme.themeData.textTheme.labelMedium,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class _LightingMaterialsTiles extends StatelessWidget {
  const _LightingMaterialsTiles();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.5,
        children: [
          _Tile(label: "Warm Spot", color: Colors.orangeAccent.withOpacity(0.1)),
          _Tile(label: "Chrome", color: Colors.blueGrey.withOpacity(0.1)),
          _Tile(label: "Leather", color: Colors.brown.withOpacity(0.1)),
          _Tile(label: "Wood", color: Colors.amber.withOpacity(0.1)),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final String label;
  final Color color;
  const _Tile({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: BarberTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BarberTheme.line),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: double.infinity,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(11)),
            ),
          ),
          const SizedBox(width: 12),
          Text(label, style: BarberTheme.themeData.textTheme.labelLarge),
        ],
      ),
    );
  }
}
