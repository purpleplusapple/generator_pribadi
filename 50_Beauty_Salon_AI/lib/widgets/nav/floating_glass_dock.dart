import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/beauty_theme.dart';
import '../../theme/beauty_tokens.dart';

class FloatingGlassDock extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final VoidCallback onCenterFabTap;

  const FloatingGlassDock({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onCenterFabTap,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.fromLTRB(24, 0, 24, 32),
        height: 80,
        decoration: BeautyTokens.liquidGlass(
          opacity: 0.85,
          radius: 40,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _DockItem(
                  icon: Icons.grid_view_rounded,
                  label: 'Studio',
                  isSelected: selectedIndex == 0,
                  onTap: () => onItemSelected(0),
                ),
                _DockItem(
                  icon: Icons.auto_awesome_mosaic_rounded,
                  label: 'Portfolio',
                  isSelected: selectedIndex == 1,
                  onTap: () => onItemSelected(1),
                ),

                // Center FAB Placeholder (Visual only, functional space)
                const SizedBox(width: 60),

                _DockItem(
                  icon: Icons.lightbulb_outline_rounded,
                  label: 'Trends',
                  isSelected: selectedIndex == 2,
                  onTap: () => onItemSelected(2), // Example tab
                ),
                _DockItem(
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                  isSelected: selectedIndex == 3,
                  onTap: () => onItemSelected(3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DockItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _DockItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? BeautyTheme.primary : BeautyTheme.muted;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

// Separate component for the Floating Action Button to sit on top
class GlassDockFab extends StatelessWidget {
  final VoidCallback onTap;

  const GlassDockFab({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 48), // Lifted slightly above dock
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [BeautyTheme.primary, Color(0xFFE88AAE)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: BeautyTokens.shadowSoft,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: const Icon(
              Icons.add_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }
}
