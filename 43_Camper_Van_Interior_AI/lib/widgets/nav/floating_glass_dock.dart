import 'package:flutter/material.dart';
import '../../theme/camper_theme.dart';
import '../glass_card.dart';

class FloatingGlassDock extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;
  final VoidCallback onBuildPressed;

  const FloatingGlassDock({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.onBuildPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      height: 70,
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        borderRadius: BorderRadius.circular(35),
        blurSigma: 20,
        fillOpacity: 0.8, // Darker glass
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left Group
            Row(
              children: [
                _buildTabItem(0, Icons.explore_outlined, Icons.explore, "Explore"),
                const SizedBox(width: 8),
                _buildTabItem(1, Icons.grid_view_outlined, Icons.grid_view, "Gallery"),
              ],
            ),

            // Center Build FAB (Actually part of the row but styled differently)
            GestureDetector(
              onTap: onBuildPressed,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: CamperAIColors.leatherTan,
                  shape: BoxShape.circle,
                  boxShadow: CamperAIShadows.goldGlow(opacity: 0.3),
                ),
                child: const Icon(Icons.add, color: CamperAIColors.soleBlack, size: 28),
              ),
            ),

            // Right Group
            Row(
              children: [
                _buildTabItem(2, Icons.bookmark_outline, Icons.bookmark, "Saved"), // Placeholder for History/Saved
                const SizedBox(width: 8),
                _buildTabItem(3, Icons.settings_outlined, Icons.settings, "Settings"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(int index, IconData icon, IconData activeIcon, String label) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onTabSelected(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? CamperAIColors.canvasWhite : CamperAIColors.laceGray,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
