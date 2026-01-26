import 'package:flutter/material.dart';
import '../../theme/apartment_tokens.dart';
import '../../widgets/studio_size_selector.dart';
import '../../widgets/zoning_template_carousel.dart';
import '../../widgets/storage_hack_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedSizeIndex = 1; // Default to 24m

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100), // Space for FAB
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: ApartmentTokens.s16),
          // Hero / Greeting
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: ApartmentTokens.s16),
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.displaySmall,
                children: [
                  const TextSpan(text: 'Design your\n'),
                  TextSpan(
                    text: 'Small Studio',
                    style: TextStyle(color: ApartmentTokens.primary),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: ApartmentTokens.s8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: ApartmentTokens.s16),
            child: Text(
              'Smart zoning & storage ideas for compact living.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),

          const SizedBox(height: ApartmentTokens.s32),

          // Size Selector
          StudioSizeSelector(
            selectedIndex: _selectedSizeIndex,
            onSelected: (idx) => setState(() => _selectedSizeIndex = idx),
          ),

          const SizedBox(height: ApartmentTokens.s32),

          // Zoning Templates
          const ZoningTemplateCarousel(),

          const SizedBox(height: ApartmentTokens.s32),

          // Storage Hacks
          const StorageHackList(),

          const SizedBox(height: ApartmentTokens.s32),

          // Style Inspirations
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: ApartmentTokens.s16),
            child: Text(
              'Style Inspirations',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          const SizedBox(height: ApartmentTokens.s12),
          SizedBox(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: ApartmentTokens.s16),
              children: [
                _buildStyleCard('Scandi Compact', 'Bright & Functional', const Color(0xFFF0EBE5)),
                _buildStyleCard('Japandi Calm', 'Zen Minimalism', const Color(0xFFE8E8E8)),
                _buildStyleCard('Warm Modern', 'Cozy Earth Tones', const Color(0xFFF5E6D3)),
                _buildStyleCard('Industrial Loft', 'Raw Materials', const Color(0xFFDCDCDC)),
              ],
            ),
          ),

          const SizedBox(height: ApartmentTokens.s32),
        ],
      ),
    );
  }

  Widget _buildStyleCard(String title, String subtitle, Color color) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: ApartmentTokens.s12),
      padding: const EdgeInsets.all(ApartmentTokens.s16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(ApartmentTokens.r16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white54,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_awesome, size: 20, color: ApartmentTokens.ink0),
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ApartmentTokens.ink0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: ApartmentTokens.ink1,
            ),
          ),
        ],
      ),
    );
  }
}
