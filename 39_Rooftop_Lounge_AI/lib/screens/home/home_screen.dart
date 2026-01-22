import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 120), // Space for dock
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTonightMoodHeader(context),
            const SizedBox(height: 32),
            _buildSignatureLounges(),
            const SizedBox(height: 32),
            _buildLightingScenes(),
            const SizedBox(height: 32),
            _buildMaterialList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTonightMoodHeader(BuildContext context) {
    return Container(
      height: 380,
      width: double.infinity,
      decoration: BoxDecoration(
        color: DesignTokens.surface,
        image: const DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1570129477492-45c003edd2be?q=80&w=2070&auto=format&fit=crop'), // Placeholder URL
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.transparent,
                  DesignTokens.bg0,
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tonight\'s Mood',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: DesignTokens.primary,
                              letterSpacing: 1.5,
                            ),
                          ),
                          Text(
                            'Skybar Editorial',
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                        ],
                      ),
                      CircleAvatar(
                         backgroundColor: DesignTokens.surface.withOpacity(0.5),
                         child: IconButton(
                           icon: const Icon(Icons.settings, color: DesignTokens.ink0),
                           onPressed: () {
                             // Settings placeholder
                           },
                         ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      _MoodChip(label: 'Chill', isSelected: true),
                      const SizedBox(width: 12),
                      _MoodChip(label: 'Party', isSelected: false),
                      const SizedBox(width: 12),
                      _MoodChip(label: 'Romantic', isSelected: false),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignatureLounges() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text('Signature Lounges', style: TextStyle(
            fontFamily: 'DM Serif Display',
            fontSize: 24,
            color: DesignTokens.ink0,
          )),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 320,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              return _SignatureCard(
                title: ['Velvet Sky', 'Neon Terrace', 'Garden Top', 'Infinity Edge'][index],
                subtitle: 'Modern Luxury',
                imageUrl: [
                  'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=600&q=80',
                  'https://images.unsplash.com/photo-1540541338287-41700207dee6?auto=format&fit=crop&w=600&q=80',
                  'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?auto=format&fit=crop&w=600&q=80',
                  'https://images.unsplash.com/photo-1582719508461-905c673771fd?auto=format&fit=crop&w=600&q=80',
                ][index],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLightingScenes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text('Lighting Scenes', style: TextStyle(
            fontFamily: 'DM Serif Display',
            fontSize: 24,
            color: DesignTokens.ink0,
          )),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              return _LightingCard(
                title: ['Warm', 'Neon', 'Candle', 'Ambient'][index],
                color: [Colors.orange, Colors.purple, Colors.amber, Colors.blue][index],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMaterialList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text('Materials & Seating', style: TextStyle(
            fontFamily: 'DM Serif Display',
            fontSize: 24,
            color: DesignTokens.ink0,
          )),
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemCount: 3,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return GlassCard(
              child: ListTile(
                leading: Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: DesignTokens.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.chair_rounded, color: DesignTokens.primary),
                ),
                title: Text(['Velvet Sofa', 'High Bar Stool', 'Fire Pit'][index],
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: DesignTokens.ink0),
                ),
                subtitle: Text('Premium Collection', style: TextStyle(color: DesignTokens.ink1)),
                trailing: Icon(Icons.arrow_forward_ios, size: 16, color: DesignTokens.ink1),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _MoodChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _MoodChip({required this.label, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? DesignTokens.primary : DesignTokens.surface.withOpacity(0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isSelected ? DesignTokens.primary : DesignTokens.line.withOpacity(0.5),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? DesignTokens.bg0 : DesignTokens.ink0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SignatureCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;

  const _SignatureCard({required this.title, required this.subtitle, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: DesignTokens.surface,
        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
        image: imageUrl.isNotEmpty ? DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover) : null,
      ),
      child: Stack(
        children: [
          if (imageUrl.isEmpty)
             Center(child: Icon(Icons.image_not_supported, size: 40, color: DesignTokens.line)),
          Container(
             decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(DesignTokens.radiusM),
               gradient: LinearGradient(
                 begin: Alignment.topCenter,
                 end: Alignment.bottomCenter,
                 colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
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
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LightingCard extends StatelessWidget {
  final String title;
  final Color color;

  const _LightingCard({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: DesignTokens.surface,
        borderRadius: BorderRadius.circular(DesignTokens.radiusS),
        border: Border.all(color: DesignTokens.line),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: color.withOpacity(0.4), blurRadius: 10, spreadRadius: 2),
              ],
            ),
            child: Icon(Icons.lightbulb, color: color, size: 18),
          ),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(color: DesignTokens.ink0, fontSize: 12)),
        ],
      ),
    );
  }
}
