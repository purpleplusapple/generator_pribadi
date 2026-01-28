import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/terrace_theme.dart';

class GlassDock extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const GlassDock({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: TerraceAISpacing.xl,
        vertical: TerraceAISpacing.lg,
      ),
      height: 80,
      decoration: BoxDecoration(
        color: TerraceAIColors.glassFill,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: TerraceAIShadows.modal,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(Icons.explore_rounded, 'Explore', 0),
              _buildCreateButton(),
              _buildNavItem(Icons.grid_view_rounded, 'Gallery', 2), // Index 2 matches old GalleryScreen
              // Note: Settings was 3. We can keep it or move it.
              // Let's keep 4 items but center Create implies 5 slots or 3.
              // If we do Explore | Create | Gallery, that's 3.
              // Let's add Settings as 4th but maybe visually balanced?
              // Or just Explore, Gallery, Settings with Create floating above?
              // The request said: "Explore / Create / History / Settings".
              // Center Create implies: Explore, History | Create | Settings ?? No, usually 4 items + center.
              // Let's do: Explore, Gallery | Create | Settings. (3 items + Create)
              // Wait, indices need to match RootShell tabs.
              // RootShell: Home(0), Wizard(1), Gallery(2), Settings(3).
              // So Create maps to Index 1 (Wizard).
              _buildNavItem(Icons.settings_rounded, 'Settings', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? TerraceAIColors.ink0 : TerraceAIColors.muted,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TerraceAIText.small.copyWith(
                color: isSelected ? TerraceAIColors.ink0 : TerraceAIColors.muted,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateButton() {
    return GestureDetector(
      onTap: () => onTap(1), // Index 1 is Wizard
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: TerraceAIGradients.primaryCta,
          shape: BoxShape.circle,
          boxShadow: TerraceAIShadows.emeraldGlow(opacity: 0.4),
        ),
        child: const Icon(
          Icons.add_rounded,
          color: TerraceAIColors.bg0,
          size: 32,
        ),
      ),
    );
  }
}
