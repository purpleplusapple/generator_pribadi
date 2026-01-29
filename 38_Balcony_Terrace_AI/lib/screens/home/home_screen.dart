import 'package:flutter/material.dart';
import '../../theme/terrace_theme.dart';
import '../../components/navigation/glass_dock.dart';
import '../../components/home/terrace_mood_header.dart';
import '../../components/home/featured_scene_carousel.dart';
import '../../components/wizard/create_bottom_sheet.dart';
import '../gallery/gallery_screen.dart';
import '../settings/settings_screen.dart';
// import '../wizard/wizard_screen.dart'; // Will implement logic later

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const _HomeContent(),
    const GalleryScreen(),
    const Center(child: Text("History (Coming Soon)")), // Placeholder for History
    const SettingsScreen(),
  ];

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _showCreateModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => CreateBottomSheet(
        onStartWizard: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/wizard'); // Assume route
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TerraceColors.bg0,
      body: Stack(
        children: [
          // Background Gradient/Blob
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: TerraceColors.primaryEmerald.withValues(alpha: 0.1),
                filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              ),
            ),
          ),

          // Main Content
          IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),

          // Glass Dock
          GlassDock(
            selectedIndex: _currentIndex,
            onItemSelected: _onTabSelected,
            onCenterTap: _showCreateModal,
          ),
        ],
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 120), // Space for dock
      children: [
        const SizedBox(height: 60), // Status bar
        const TerraceMoodHeader(),
        const SizedBox(height: TerraceSpacing.lg),
        const FeaturedSceneCarousel(),
        const SizedBox(height: TerraceSpacing.xxl),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: TerraceSpacing.base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Explore by Size', style: TerraceText.h2),
              const SizedBox(height: TerraceSpacing.md),
              const _SizeSelector(),
              const SizedBox(height: TerraceSpacing.xxl),

              Text('Lighting Scenes', style: TerraceText.h2),
              const SizedBox(height: TerraceSpacing.md),
              const _LightingScenes(),
            ],
          ),
        ),
      ],
    );
  }
}

class _SizeSelector extends StatelessWidget {
  const _SizeSelector();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _SizeCard(label: 'Small', icon: Icons.crop_square),
          _SizeCard(label: 'Narrow', icon: Icons.view_column),
          _SizeCard(label: 'Corner', icon: Icons.rounded_corner),
          _SizeCard(label: 'Rooftop', icon: Icons.deck),
        ],
      ),
    );
  }
}

class _SizeCard extends StatelessWidget {
  final String label;
  final IconData icon;

  const _SizeCard({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: TerraceSpacing.md),
      decoration: BoxDecoration(
        color: TerraceColors.bg1,
        borderRadius: BorderRadius.circular(TerraceTokens.radiusMedium),
        border: Border.all(color: TerraceColors.line),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: TerraceColors.muted, size: 30),
          const SizedBox(height: 8),
          Text(label, style: TerraceText.bodySmall),
        ],
      ),
    );
  }
}

class _LightingScenes extends StatelessWidget {
  const _LightingScenes();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _LightingRow(label: 'String Lights', color: Colors.orange),
        _LightingRow(label: 'Lanterns', color: Colors.amber),
        _LightingRow(label: 'Hidden LED', color: Colors.blue),
      ],
    );
  }
}

class _LightingRow extends StatelessWidget {
  final String label;
  final Color color;

  const _LightingRow({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: TerraceSpacing.sm),
      padding: const EdgeInsets.all(TerraceSpacing.base),
      decoration: BoxDecoration(
        color: TerraceColors.surface,
        borderRadius: BorderRadius.circular(TerraceTokens.radiusSmall),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: color.withValues(alpha: 0.6), blurRadius: 8),
              ],
            ),
          ),
          const SizedBox(width: TerraceSpacing.md),
          Text(label, style: TerraceText.body),
          const Spacer(),
          Icon(Icons.chevron_right, color: TerraceColors.muted),
        ],
      ),
    );
  }
}
