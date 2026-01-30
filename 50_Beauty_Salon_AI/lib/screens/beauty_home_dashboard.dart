import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme/beauty_theme.dart';
import '../../theme/beauty_tokens.dart';
import '../../widgets/cards/salon_zone_card.dart';

class BeautyHomeDashboard extends StatelessWidget {
  final VoidCallback onCreateTap;

  const BeautyHomeDashboard({
    super.key,
    required this.onCreateTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // 1. Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Next',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: BeautyTheme.muted,
                  ),
                ),
                Text(
                  'Glow-Up',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: BeautyTheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _Chip(label: 'Nails', isActive: true),
                      const SizedBox(width: 8),
                      _Chip(label: 'Hair', isActive: false),
                      const SizedBox(width: 8),
                      _Chip(label: 'Spa', isActive: false),
                      const SizedBox(width: 8),
                      _Chip(label: 'Makeup', isActive: false),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // 2. Signature Salons Carousel (Editorial)
        SliverToBoxAdapter(
          child: SizedBox(
            height: 320,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: 4,
              itemBuilder: (context, index) {
                // Placeholder logic for carousel
                return Container(
                  width: 240,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(BeautyTokens.radiusL),
                    boxShadow: BeautyTokens.shadowSoft,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(BeautyTokens.radiusL),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        SvgPicture.asset(
                          'assets/examples/example_salon_${index + 1}.svg',
                          fit: BoxFit.cover,
                          placeholderBuilder: (_) => Container(color: BeautyTheme.surface2),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Trend ${2024 + index}',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                ['Rose Luxury', 'Minimalist', 'Neon Glow', 'Eco Zen'][index],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Playfair Display',
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // 3. Zones Title
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Design Zones', style: Theme.of(context).textTheme.titleLarge),
                const Icon(Icons.arrow_forward, size: 16, color: BeautyTheme.muted),
              ],
            ),
          ),
        ),

        // 4. Zones List
        SliverToBoxAdapter(
          child: SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                SalonZoneCard(
                  title: 'Styling',
                  subtitle: 'Mirrors & Chairs',
                  icon: Icons.face,
                  onTap: () {},
                ),
                SalonZoneCard(
                  title: 'Wash',
                  subtitle: 'Basins & Relax',
                  icon: Icons.water_drop_outlined,
                  onTap: () {},
                ),
                SalonZoneCard(
                  title: 'Reception',
                  subtitle: 'Welcome Area',
                  icon: Icons.storefront,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),

        // 5. Bottom Padding for Dock
        const SliverToBoxAdapter(child: SizedBox(height: 120)),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool isActive;

  const _Chip({required this.label, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? BeautyTheme.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isActive ? Colors.transparent : BeautyTheme.line,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : BeautyTheme.ink1,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}
