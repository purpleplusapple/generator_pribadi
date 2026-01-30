import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/camper_tokens.dart';

class FloatingGlassDock extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const FloatingGlassDock({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.fromLTRB(24, 0, 24, 34),
        height: 72,
        decoration: BoxDecoration(
          color: CamperTokens.bg1.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(36),
          border: Border.all(color: CamperTokens.line.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(36),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _DockItem(
                  icon: Icons.explore_outlined,
                  selectedIcon: Icons.explore,
                  label: "Explore",
                  isSelected: currentIndex == 0,
                  onTap: () => onTap(0),
                ),
                _DockItem(
                  icon: Icons.construction_outlined,
                  selectedIcon: Icons.construction,
                  label: "Build",
                  isSelected: currentIndex == 1,
                  isFab: true,
                  onTap: () => onTap(1),
                ),
                _DockItem(
                  icon: Icons.photo_library_outlined,
                  selectedIcon: Icons.photo_library,
                  label: "Gallery",
                  isSelected: currentIndex == 2,
                  onTap: () => onTap(2),
                ),
                _DockItem(
                  icon: Icons.settings_outlined,
                  selectedIcon: Icons.settings,
                  label: "Settings",
                  isSelected: currentIndex == 3,
                  onTap: () => onTap(3),
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
  final bool isFab;
  final VoidCallback onTap;

  const _DockItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    this.isFab = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? CamperTokens.primary : CamperTokens.muted;

    if (isFab) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: isSelected ? CamperTokens.primary : CamperTokens.surface2,
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? CamperTokens.primary : CamperTokens.line,
              width: 1,
            ),
            boxShadow: isSelected ? [
              BoxShadow(
                color: CamperTokens.primary.withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              )
            ] : null,
          ),
          child: Icon(
            isSelected ? selectedIcon : icon,
            color: isSelected ? Colors.black : CamperTokens.ink0,
            size: 24,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSelected ? selectedIcon : icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
