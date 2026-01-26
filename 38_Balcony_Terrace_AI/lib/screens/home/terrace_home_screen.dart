import 'package:flutter/material.dart';
import '../../theme/design_tokens.dart';
import '../../theme/terrace_theme.dart';

class TerraceHomeScreen extends StatefulWidget {
  const TerraceHomeScreen({super.key});

  @override
  State<TerraceHomeScreen> createState() => _TerraceHomeScreenState();
}

class _TerraceHomeScreenState extends State<TerraceHomeScreen> {
  String _selectedMood = 'Cozy';
  final List<String> _moods = ['Cozy', 'Minimal', 'Jungle', 'Party'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.bg0,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100), // Space for Dock
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildLanternCarousel(),
              const SizedBox(height: 32),
              _buildSectionTitle('Space Size'),
              _buildSizeSelector(),
              const SizedBox(height: 32),
              _buildSectionTitle('Greenery Level'),
              _buildGreeneryCards(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            'Tonight on\nYour Terrace',
            style: terraceTheme.textTheme.displayLarge?.copyWith(
              color: DesignTokens.ink0,
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _moods.map((mood) {
                final isSelected = _selectedMood == mood;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(mood),
                    selected: isSelected,
                    onSelected: (val) => setState(() => _selectedMood = mood),
                    backgroundColor: DesignTokens.surface,
                    selectedColor: DesignTokens.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? DesignTokens.bg0 : DesignTokens.ink1,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? Colors.transparent : DesignTokens.line,
                      ),
                    ),
                    showCheckmark: false,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Text(
        title,
        style: terraceTheme.textTheme.headlineMedium,
      ),
    );
  }

  Widget _buildLanternCarousel() {
    // Mock data for carousel
    final items = [
      {'title': 'String Lights', 'color': DesignTokens.accent},
      {'title': 'Rattan Glow', 'color': Colors.brown},
      {'title': 'Urban Night', 'color': Colors.blueGrey},
    ];

    return SizedBox(
      height: 320,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            width: 240,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: DesignTokens.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: DesignTokens.line),
              image: const DecorationImage(
                // Placeholder gradient instead of image for now
                image: NetworkImage('https://via.placeholder.com/240x320/101A18/E7A35A?text=Night+Scene'),
                fit: BoxFit.cover,
                opacity: 0.6,
              ),
              boxShadow: index == 0 ? DesignTokens.shadowGlowAmber : [],
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: (item['color'] as Color).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: (item['color'] as Color).withOpacity(0.5)),
                    ),
                    child: Text(
                      'Trending',
                      style: TextStyle(color: item['color'] as Color, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['title'] as String,
                    style: terraceTheme.textTheme.titleLarge?.copyWith(
                      color: DesignTokens.ink0,
                      fontWeight: FontWeight.bold,
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

  Widget _buildSizeSelector() {
    final sizes = [
      {'icon': Icons.crop_square, 'label': 'Small'},
      {'icon': Icons.view_column, 'label': 'Narrow'},
      {'icon': Icons.branding_watermark, 'label': 'Rooftop'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: sizes.map((size) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: DesignTokens.surface2,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: DesignTokens.line),
              ),
              child: Column(
                children: [
                  Icon(size['icon'] as IconData, color: DesignTokens.muted),
                  const SizedBox(height: 8),
                  Text(
                    size['label'] as String,
                    style: const TextStyle(color: DesignTokens.ink1, fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGreeneryCards() {
    return SizedBox(
      height: 140,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _greeneryCard('Low Maintenance', 'Cactus & succulents', 0.3),
          _greeneryCard('Balanced', 'Pots & hanging plants', 0.6),
          _greeneryCard('Jungle Max', 'Dense vertical walls', 0.9),
        ],
      ),
    );
  }

  Widget _greeneryCard(String title, String subtitle, double intensity) {
    return Container(
      width: 160,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DesignTokens.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: DesignTokens.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.grass, color: DesignTokens.primary.withOpacity(intensity + 0.1)),
              const Spacer(),
              Icon(Icons.arrow_forward, size: 16, color: DesignTokens.muted),
            ],
          ),
          const Spacer(),
          Text(title, style: const TextStyle(color: DesignTokens.ink0, fontWeight: FontWeight.bold)),
          Text(subtitle, style: const TextStyle(color: DesignTokens.muted, fontSize: 10)),
        ],
      ),
    );
  }
}
