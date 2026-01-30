import 'package:flutter/material.dart';
import '../../theme/guest_theme.dart';
import '../../src/app_assets.dart'; // Assumes I'll update this or use strings
import '../wizard/guest_wizard_screen.dart';

class GuestWelcomeScreen extends StatelessWidget {
  const GuestWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: GuestAISpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Welcome,", style: GuestAIText.h3.copyWith(color: GuestAIColors.muted)),
                Text("Make Guests\nFeel At Home", style: GuestAIText.h1),
              ],
            ),
          ),
          const SizedBox(height: GuestAISpacing.xl),

          // 1. Editorial Carousel
          SizedBox(
            height: 320,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: GuestAISpacing.base),
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return _buildInspirationCard(context, index);
              },
            ),
          ),

          const SizedBox(height: GuestAISpacing.xl),

          // 2. Guest Essentials (Checklist)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: GuestAISpacing.lg),
            child: Text("Guest Essentials", style: GuestAIText.h2),
          ),
          const SizedBox(height: GuestAISpacing.base),
          _buildEssentialsList(),

          const SizedBox(height: GuestAISpacing.xxl),

          // 3. Room Types
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: GuestAISpacing.lg),
            child: Text("Room Types", style: GuestAIText.h2),
          ),
          const SizedBox(height: GuestAISpacing.base),
          _buildRoomTypes(context),

          const SizedBox(height: 100), // Spacing for FAB
        ],
      ),
    );
  }

  Widget _buildInspirationCard(BuildContext context, int index) {
    // Mapping to our downloaded assets
    final assetName = "assets/examples/guest_example_${index + 1}.jpg";
    final titles = [
      "Boutique Comfort",
      "Minimal Zen",
      "Warm & Cozy",
      "Luxury Suite",
      "Nature Retreat"
    ];

    return Container(
      width: 240,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: GuestAIRadii.regularRadius,
        image: DecorationImage(
          image: AssetImage(assetName),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: GuestAIRadii.regularRadius,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.6)],
            stops: const [0.6, 1.0],
          ),
        ),
        padding: const EdgeInsets.all(16),
        alignment: Alignment.bottomLeft,
        child: Text(
          titles[index % titles.length],
          style: GuestAIText.h3.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildEssentialsList() {
    final items = [
      {"icon": Icons.bed_rounded, "title": "Comfort Bedding"},
      {"icon": Icons.light_mode_outlined, "title": "Warm Lighting"},
      {"icon": Icons.wifi_rounded, "title": "Wifi & Desk"},
      {"icon": Icons.local_cafe_outlined, "title": "Welcome Tray"},
    ];

    return SizedBox(
      height: 110,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: GuestAISpacing.lg),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            width: 100,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: GuestAIColors.pureWhite,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: GuestAIColors.line),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item["icon"] as IconData, color: GuestAIColors.brass, size: 32),
                const SizedBox(height: 8),
                Text(
                  item["title"] as String,
                  style: GuestAIText.small.copyWith(fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRoomTypes(BuildContext context) {
    final types = [
      "Standard Guest Room",
      "Home Office Combo",
      "Small Nook",
      "Family Suite",
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: GuestAISpacing.lg),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: types.map((t) => ActionChip(
          label: Text(t),
          labelStyle: GuestAIText.bodyMedium.copyWith(color: GuestAIColors.inkBody),
          backgroundColor: GuestAIColors.pureWhite,
          side: const BorderSide(color: GuestAIColors.line),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          onPressed: () {
            // Quick start logic could go here
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const GuestWizardScreen()),
            );
          },
        )).toList(),
      ),
    );
  }
}
