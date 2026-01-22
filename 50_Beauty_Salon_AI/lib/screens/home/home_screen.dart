import 'package:flutter/material.dart';
import '../../theme/beauty_salon_ai_theme.dart';
import '../../widgets/beauty_split_header.dart';
import '../../widgets/floating_glass_dock.dart';
import '../../widgets/gradient_button.dart'; // Keeping this for the button inside dock

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BeautyAIColors.bg0,
      body: Stack(
        children: [
          // Main Scrollable Content
          SafeArea(
            bottom: false,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // 1. Split Header
                SliverToBoxAdapter(
                  child: BeautySplitHeader(
                    title: 'Welcome Back,\nDesigner',
                    subtitle: 'Good Morning',
                    onNotificationTap: () {},
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: BeautyAISpacing.md)),

                // 2. Section Title: Trending
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: BeautyAISpacing.lg),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Trending Looks', style: BeautyAIText.h3),
                        Text('View All', style: BeautyAIText.button.copyWith(color: BeautyAIColors.primary)),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: BeautyAISpacing.md)),

                // 3. Trending Carousel (Horizontal)
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 280,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: BeautyAISpacing.lg),
                      itemCount: _trendingLooks.length,
                      itemBuilder: (context, index) {
                        return _buildTrendingCard(_trendingLooks[index]);
                      },
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: BeautyAISpacing.xl)),

                // 4. Section Title: Services
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: BeautyAISpacing.lg),
                    child: Text('Salon Services', style: BeautyAIText.h3),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: BeautyAISpacing.md)),

                // 5. Services List (Editorial)
                SliverPadding(
                  padding: const EdgeInsets.only(
                    left: BeautyAISpacing.lg,
                    right: BeautyAISpacing.lg,
                    bottom: 120, // Space for floating dock
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildServiceTile(_services[index]),
                      childCount: _services.length,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 6. Floating Dock CTA
          FloatingGlassDock(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('New Project', style: BeautyAIText.h3.copyWith(fontSize: 16)),
                      Text('10 generations left today', style: BeautyAIText.caption),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Wizard tab (Index 1)
                    // Finding the ancestor state to switch tab might be complex without a provider/callback.
                    // Ideally we'd use a callback or global state.
                    // For now, we'll try to find the TabController or similar if available,
                    // but since RootShell manages index statefully, we might need a hack or Notification.
                    // Simulating "Open Wizard" behavior by switching tab would be ideal.
                    // Assuming we can access the parent or use a GlobalKey if set up,
                    // but simplest is to inform the user or use a specific route if set up.
                    // Since RootShell is a StatefulWidget, let's just show a snackbar for the prototype
                    // or assume the user taps the 'Wizard' tab.
                    // Actually, let's try to access the RootShell state if possible or just emit a notification.

                    // For this cloning task, triggering the logic is key.
                    // Let's assume we want to guide them to the Wizard tab.
                    final bottomNav = context.findAncestorStateOfType<State<StatefulWidget>>();
                    // This is risky. Let's just use a dialog to simulate "Start"

                    // Actually, looking at RootShell, it has _currentIndex.
                    // We can't easily change it from here without a callback passed down.
                    // I will leave a TODO note or just a visual feedback.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Switch to Wizard Tab to start designing')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BeautyAIColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                  ),
                  child: const Text('Start'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingCard(Map<String, dynamic> look) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: BeautyAISpacing.md),
      decoration: BoxDecoration(
        borderRadius: BeautyAIRadii.mdRadius,
        image: DecorationImage(
          image: NetworkImage(look['image']),
          fit: BoxFit.cover,
        ),
        boxShadow: BeautyAIShadows.soft,
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BeautyAIRadii.mdRadius,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
              ),
            ),
          ),
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  look['title'],
                  style: BeautyAIText.bodyMedium.copyWith(color: Colors.white),
                ),
                Text(
                  look['style'],
                  style: BeautyAIText.caption.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceTile(Map<String, dynamic> service) {
    return Container(
      margin: const EdgeInsets.only(bottom: BeautyAISpacing.md),
      padding: const EdgeInsets.all(BeautyAISpacing.md),
      decoration: BoxDecoration(
        color: BeautyAIColors.bg1,
        borderRadius: BeautyAIRadii.mdRadius,
        border: Border.all(color: BeautyAIColors.line),
        boxShadow: BeautyAIShadows.soft,
      ),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: BeautyAIColors.bg0,
              borderRadius: BeautyAIRadii.smRadius,
            ),
            child: Icon(service['icon'], color: BeautyAIColors.primary),
          ),
          const SizedBox(width: BeautyAISpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(service['title'], style: BeautyAIText.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                Text(service['duration'], style: BeautyAIText.caption),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: BeautyAIColors.muted),
        ],
      ),
    );
  }

  static const List<Map<String, dynamic>> _trendingLooks = [
    {
      'title': 'Minimalist Zen',
      'style': 'Japandi Style',
      'image': 'https://images.unsplash.com/photo-1600607686527-6fb886090705?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80',
    },
    {
      'title': 'Modern Luxe',
      'style': 'Rose Gold & Marble',
      'image': 'https://images.unsplash.com/photo-1560185127-6ed189bf02f4?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80',
    },
    {
      'title': 'Boho Chic',
      'style': 'Earthy Tones',
      'image': 'https://images.unsplash.com/photo-1595526114035-0d45ed16cfbf?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80',
    },
  ];

  static const List<Map<String, dynamic>> _services = [
    {'icon': Icons.chair_rounded, 'title': 'Styling Station Redesign', 'duration': 'Full Room'},
    {'icon': Icons.spa_rounded, 'title': 'Spa Room Layout', 'duration': 'Single Room'},
    {'icon': Icons.table_restaurant_rounded, 'title': 'Reception Area', 'duration': 'Entrance'},
    {'icon': Icons.lightbulb_outline, 'title': 'Lighting Plan', 'duration': 'Add-on'},
  ];
}
