// lib/screens/home/home_screen.dart
// Redesigned home screen with hero section and horizontal carousel

import 'package:flutter/material.dart';
import '../../theme/beauty_salon_ai_theme.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Hero Section
              _buildHeroSection(context),

              const SizedBox(height: BeautyAISpacing.massive),

              // Features Carousel
              _buildFeaturesSection(),

              const SizedBox(height: BeautyAISpacing.huge),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: BeautyAISpacing.xl,
        vertical: BeautyAISpacing.massive,
      ),
      child: Column(
        children: [
          // App Icon with glow
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: BeautyAIGradients.primaryCta,
              shape: BoxShape.circle,
              boxShadow: BeautyAIShadows.goldGlow(opacity: 0.5),
            ),
            child: Icon(
              Icons.spa_rounded,
              size: 56,
              color: BeautyAIColors.charcoal,
            ),
          ),

          const SizedBox(height: BeautyAISpacing.xl),

          // Animated Gradient Title
          ShaderMask(
            shaderCallback: (bounds) => BeautyAIGradients.primaryCta.createShader(bounds),
            child: Text(
              'Beauty Salon AI',
              style: BeautyAIText.h1.copyWith(
                fontSize: 38,
                letterSpacing: -0.8,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: BeautyAISpacing.lg),

          // Subtitle with badges
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildBadge(Icons.auto_awesome_rounded, 'AI-Powered'),
              const SizedBox(width: BeautyAISpacing.sm),
              _buildBadge(Icons.speed_rounded, 'Instant'),
              const SizedBox(width: BeautyAISpacing.sm),
              _buildBadge(Icons.hd_rounded, 'HD Quality'),
            ],
          ),

          const SizedBox(height: BeautyAISpacing.xxl),

          // Primary CTA
          SizedBox(
            width: double.infinity,
            child: GradientButton(
              label: 'Design Your Dream Salon',
              size: ButtonSize.large,
              icon: Icons.auto_fix_high_rounded,
              onPressed: () {
                // Navigate to wizard
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening wizard...')),
                );
              },
            ),
          ),

          const SizedBox(height: BeautyAISpacing.lg),

          // Secondary action
          TextButton.icon(
            onPressed: () {},
            icon: Icon(Icons.play_circle_outline, color: BeautyAIColors.roseGold),
            label: Text(
              'Watch Demo',
              style: BeautyAIText.bodyMedium.copyWith(
                color: BeautyAIColors.roseGold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: BeautyAISpacing.md,
        vertical: BeautyAISpacing.sm,
      ),
      decoration: BoxDecoration(
        color: BeautyAIColors.creamWhite.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: BeautyAIColors.creamWhite.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: BeautyAIColors.metallicGold),
          const SizedBox(width: 4),
          Text(
            label,
            style: BeautyAIText.small.copyWith(
              color: BeautyAIColors.creamWhite,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: BeautyAISpacing.xl),
          child: Text(
            'How It Works',
            style: BeautyAIText.h2.copyWith(
              fontSize: 26,
              letterSpacing: 0.5,
            ),
          ),
        ),

        const SizedBox(height: BeautyAISpacing.xl),

        // Horizontal scrolling features
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: BeautyAISpacing.lg),
            itemCount: _features.length,
            itemBuilder: (context, index) {
              final feature = _features[index];
              return _buildFeatureCard(
                feature['icon'] as IconData,
                feature['title'] as String,
                feature['description'] as String,
                index,
              );
            },
          ),
        ),

        const SizedBox(height: BeautyAISpacing.lg),

        // Page indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _features.length,
            (index) => Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index == 0
                    ? BeautyAIColors.roseGold
                    : BeautyAIColors.creamWhite.withValues(alpha: 0.3),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String description, int index) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: BeautyAISpacing.lg),
      child: GlassCard(
        padding: const EdgeInsets.all(BeautyAISpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Step number badge
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: BeautyAIGradients.primaryCta,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: BeautyAIText.bodyMedium.copyWith(
                    color: BeautyAIColors.charcoal,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            const SizedBox(height: BeautyAISpacing.lg),

            // Icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                gradient: BeautyAIGradients.accentHighlight,
                borderRadius: BorderRadius.circular(18),
                boxShadow: BeautyAIShadows.goldGlow(opacity: 0.3),
              ),
              child: Icon(icon, size: 32, color: BeautyAIColors.charcoal),
            ),

            const SizedBox(height: BeautyAISpacing.lg),

            // Title
            Text(
              title,
              style: BeautyAIText.h3.copyWith(fontSize: 20),
            ),

            const SizedBox(height: BeautyAISpacing.sm),

            // Description
            Text(
              description,
              style: BeautyAIText.body.copyWith(
                color: BeautyAIColors.creamWhite.withValues(alpha: 0.8),
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static final List<Map<String, dynamic>> _features = [
    {
      'icon': Icons.add_a_photo_rounded,
      'title': 'Upload Photo',
      'description': 'Take or select a photo of your space to transform',
    },
    {
      'icon': Icons.tune_rounded,
      'title': 'Choose Style',
      'description': 'Pick from modern, chic, minimalist, and luxury salon designs',
    },
    {
      'icon': Icons.auto_awesome_rounded,
      'title': 'AI Magic',
      'description': 'Our AI generates stunning, realistic salon designs in seconds',
    },
    {
      'icon': Icons.download_rounded,
      'title': 'Save & Share',
      'description': 'Download high-quality images and share your dream salon',
    },
  ];
}
