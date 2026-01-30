// lib/screens/home/home_screen.dart
// Command Room Dashboard

import 'package:flutter/material.dart';
import '../../theme/meeting_room_theme.dart';
import '../../theme/meeting_tokens.dart';
import '../../data/meeting_style_repository.dart';
import '../wizard/wizard_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Handled by RootShell
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Command Header
                  _buildHeader(),
                  const SizedBox(height: 32),

                  // Templates Carousel
                  _buildSectionTitle('BOARDROOM TEMPLATES', Icons.view_carousel_rounded),
                  const SizedBox(height: 16),
                  _buildTemplateCarousel(context),
                  const SizedBox(height: 32),

                  // Zones
                  _buildSectionTitle('ZONES', Icons.grid_view_rounded),
                  const SizedBox(height: 16),
                  _buildZonesRow(),
                  const SizedBox(height: 32),

                  // Tech Stack
                  _buildSectionTitle('TECH STACK', Icons.memory_rounded),
                  const SizedBox(height: 16),
                  _buildTechStackTiles(),

                  const SizedBox(height: 80), // Bottom padding for FAB
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MeetingTokens.surface,
        borderRadius: BorderRadius.circular(MeetingTokens.radiusLG),
        border: Border.all(color: MeetingTokens.line.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ROOM READINESS',
                style: MeetingRoomText.caption.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: MeetingTokens.success.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'ONLINE',
                  style: MeetingRoomText.small.copyWith(
                    color: MeetingTokens.success,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildIndicator('LIGHTING', 0.85, MeetingTokens.accentGold),
              _buildIndicator('SEATING', 0.60, MeetingTokens.accent),
              _buildIndicator('AV SYNC', 0.95, MeetingTokens.accentTeal),
              _buildIndicator('ACOUSTIC', 0.40, MeetingTokens.danger),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(String label, double value, Color color) {
    return Column(
      children: [
        SizedBox(
          height: 60,
          width: 8,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: MeetingTokens.bg0,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                heightFactor: value,
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.5),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: MeetingRoomText.small.copyWith(fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: MeetingTokens.muted),
        const SizedBox(width: 8),
        Text(
          title,
          style: MeetingRoomText.caption.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: MeetingTokens.muted,
          ),
        ),
      ],
    );
  }

  Widget _buildTemplateCarousel(BuildContext context) {
    // Get first 5 styles as templates
    final templates = MeetingStyleRepository.styles.take(5).toList();

    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: templates.length,
        itemBuilder: (context, index) {
          final style = templates[index];
          // Use first image as cover
          final imagePath = style.moodboardImages.isNotEmpty
              ? style.moodboardImages.first
              : 'assets/examples/example_01.jpg'; // Fallback

          return GestureDetector(
            onTap: () {
               Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const WizardScreen(),
                  fullscreenDialog: true,
                ),
              );
            },
            child: Container(
              width: 220,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(MeetingTokens.radiusLG),
                color: MeetingTokens.surface,
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withValues(alpha: 0.4),
                    BlendMode.darken,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.9),
                            Colors.transparent,
                          ],
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(MeetingTokens.radiusLG),
                          bottomRight: Radius.circular(MeetingTokens.radiusLG),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            style.name.toUpperCase(),
                            style: MeetingRoomText.h3.copyWith(fontSize: 18),
                            maxLines: 2,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'View Specs ->',
                            style: MeetingRoomText.small.copyWith(
                              color: MeetingTokens.accent,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildZonesRow() {
    final zones = [
      {'label': 'Table & Seating', 'count': '24 items'},
      {'label': 'Display Wall', 'count': '3 screens'},
      {'label': 'Whiteboard', 'count': 'Active'},
      {'label': 'Acoustics', 'count': '90%'},
    ];

    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: zones.length,
        separatorBuilder: (c, i) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final zone = zones[index];
          return Container(
            width: 140,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: MeetingTokens.surface,
              borderRadius: BorderRadius.circular(MeetingTokens.radiusMD),
              border: Border.all(color: MeetingTokens.line.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.layers_rounded, color: MeetingTokens.primary, size: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      zone['label']!,
                      style: MeetingRoomText.bodyMedium.copyWith(fontSize: 13),
                    ),
                    Text(
                      zone['count']!,
                      style: MeetingRoomText.small.copyWith(color: MeetingTokens.muted),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTechStackTiles() {
    final tech = [
      {'icon': Icons.videocam_rounded, 'label': 'Camera'},
      {'icon': Icons.mic_rounded, 'label': 'Audio'},
      {'icon': Icons.router_rounded, 'label': 'Network'},
      {'icon': Icons.cable_rounded, 'label': 'Cables'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.0,
      ),
      itemCount: tech.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: MeetingTokens.bg1,
            borderRadius: BorderRadius.circular(MeetingTokens.radiusMD),
            border: Border.all(color: MeetingTokens.line.withValues(alpha: 0.3)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(tech[index]['icon'] as IconData, color: MeetingTokens.ink1, size: 24),
              const SizedBox(height: 8),
              Text(
                tech[index]['label'] as String,
                style: MeetingRoomText.small.copyWith(fontSize: 10),
              ),
            ],
          ),
        );
      },
    );
  }
}
