import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/terrace_theme.dart';

class GlassDock extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final VoidCallback onCenterTap;

  const GlassDock({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onCenterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.all(TerraceSpacing.xl),
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              color: TerraceColors.surface.withValues(alpha: 0.7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _NavItem(
                    icon: Icons.explore_outlined,
                    label: 'Explore',
                    isSelected: selectedIndex == 0,
                    onTap: () => onItemSelected(0),
                  ),
                  _NavItem(
                    icon: Icons.photo_library_outlined,
                    label: 'Gallery',
                    isSelected: selectedIndex == 1,
                    onTap: () => onItemSelected(1),
                  ),
                  _CenterButton(onTap: onCenterTap),
                  _NavItem(
                    icon: Icons.history_outlined,
                    label: 'History',
                    isSelected: selectedIndex == 2,
                    onTap: () => onItemSelected(2),
                  ),
                  _NavItem(
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
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? TerraceColors.metallicGold : TerraceColors.laceGray,
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TerraceText.small.copyWith(
              color: isSelected ? TerraceColors.metallicGold : TerraceColors.laceGray,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _CenterButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CenterButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: TerraceGradients.primaryCta,
          shape: BoxShape.circle,
          boxShadow: TerraceShadows.goldGlow(opacity: 0.5),
        ),
        child: const Icon(
          Icons.add_rounded,
          color: TerraceColors.soleBlack,
          size: 32,
        ),
      ),
    );
  }
}
