import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/barber_theme.dart';

class FloatingGlassDock extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  const FloatingGlassDock({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
        height: 72,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: BarberTheme.surface.withOpacity(0.8),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _DockItem(
                    icon: Icons.storefront_outlined,
                    activeIcon: Icons.storefront_rounded,
                    label: 'Shop',
                    isActive: currentIndex == 0,
                    onTap: () => onTabSelected(0),
                  ),
                  _DockItem(
                    icon: Icons.add_circle_outline_rounded,
                    activeIcon: Icons.add_circle_rounded,
                    label: 'Create',
                    isActive: currentIndex == 1,
                    onTap: () => onTabSelected(1),
                    isHighlight: true,
                  ),
                  _DockItem(
                    icon: Icons.collections_bookmark_outlined,
                    activeIcon: Icons.collections_bookmark_rounded,
                    label: 'Gallery',
                    isActive: currentIndex == 2,
                    onTap: () => onTabSelected(2),
                  ),
                  _DockItem(
                    icon: Icons.settings_outlined,
                    activeIcon: Icons.settings_rounded,
                    label: 'Settings',
                    isActive: currentIndex == 3,
                    onTap: () => onTabSelected(3),
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

class _DockItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final bool isHighlight;

  const _DockItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.isHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? BarberTheme.primary : BarberTheme.muted;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.all(isHighlight ? 12 : 8),
            decoration: isHighlight && isActive
                ? BoxDecoration(
                    color: BarberTheme.primary.withOpacity(0.2),
                    shape: BoxShape.circle,
                  )
                : const BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                  ),
            child: Icon(
              isActive ? activeIcon : icon,
              color: isHighlight && isActive ? BarberTheme.primary : color,
              size: isHighlight ? 28 : 24,
            ),
          ),
          if (!isHighlight) ...[
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
