import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/study_dashboard_header.dart';
import '../../widgets/editorial_style_carousel.dart';
import '../../widgets/desk_zone_row_cards.dart';
import '../../widgets/lighting_preset_tiles.dart';
import '../../services/premium_gate_service.dart'; // Keep logic

class HomeScreen extends StatefulWidget {
  final VoidCallback onCreateTap; // For Quick Start

  const HomeScreen({super.key, required this.onCreateTap});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _currentVibe = 'Deep Focus';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Background handled by RootShell
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100), // Space for dock
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Header
              StudyDashboardHeader(
                currentVibe: _currentVibe,
                onVibeChanged: (val) => setState(() => _currentVibe = val),
              ),

              const SizedBox(height: 32),

              // Section 1: Editorial Carousel
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text('Classroom Styles', style: StudyAIText.h2),
              ),
              const SizedBox(height: 16),
              EditorialStyleCarousel(onTapStyle: widget.onCreateTap),

              const SizedBox(height: 40),

              // Section 2: Desk Zones
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Desk Zones', style: StudyAIText.h2),
                    Text('See all', style: StudyAIText.button.copyWith(color: StudyAIColors.primary)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const DeskZoneRowCards(),

              const SizedBox(height: 40),

              // Section 3: Lighting
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text('Lighting Presets', style: StudyAIText.h2),
              ),
              const SizedBox(height: 16),
              const LightingPresetTiles(),

              const SizedBox(height: 40),

              // Section 4: Quick Start Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: StudyAIGradients.primaryCta,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'New Design Project',
                              style: StudyAIText.h2.copyWith(color: StudyAIColors.bg0),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Start from scratch with AI assistance',
                              style: StudyAIText.bodyMedium.copyWith(color: StudyAIColors.bg0.withValues(alpha: 0.8)),
                            ),
                          ],
                        ),
                      ),
                      FloatingActionButton(
                        onPressed: widget.onCreateTap,
                        backgroundColor: StudyAIColors.bg0,
                        foregroundColor: StudyAIColors.primary,
                        child: const Icon(Icons.arrow_forward),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
