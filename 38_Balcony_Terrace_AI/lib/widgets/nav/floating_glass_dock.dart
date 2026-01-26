import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/design_tokens.dart';

class FloatingGlassDock extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const FloatingGlassDock({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32, left: 16, right: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 72,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: DesignTokens.surface.withOpacity(0.85),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: DesignTokens.ink0.withOpacity(0.1),
                width: 1,
              ),
              boxShadow: DesignTokens.shadowSoft,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _DockItem(
                  icon: Icons.explore_outlined,
                  selectedIcon: Icons.explore,
                  label: 'Explore',
                  isSelected: selectedIndex == 0,
                  onTap: () => onItemSelected(0),
                ),
                _DockItem(
                  icon: Icons.add_circle_outline,
                  selectedIcon: Icons.add_circle,
                  label: 'Create',
                  isSelected: selectedIndex == 1,
                  isProminent: true,
                  onTap: () => onItemSelected(1),
                ),
                _DockItem(
                  icon: Icons.history,
                  selectedIcon: Icons.history,
                  label: 'History',
                  isSelected: selectedIndex == 2,
                  onTap: () => onItemSelected(2),
                ),
                _DockItem(
                  icon: Icons.settings_outlined,
                  selectedIcon: Icons.settings,
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
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final bool isProminent;
  final VoidCallback onTap;

  const _DockItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    this.isProminent = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? DesignTokens.primary : DesignTokens.muted;
    final iconData = isSelected ? selectedIcon : icon;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isProminent)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected ? DesignTokens.primary : DesignTokens.surface2,
                  shape: BoxShape.circle,
                  boxShadow: isSelected ? DesignTokens.shadowGlowAmber : [],
                ),
                child: Icon(
                  iconData,
                  color: isSelected ? DesignTokens.bg0 : DesignTokens.ink0,
                  size: 24,
                ),
              )
            else
              Icon(
                iconData,
                color: color,
                size: 26,
              ),
            if (!isProminent) ...[
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
          ],
        ),
      ),
    );
  }
}
