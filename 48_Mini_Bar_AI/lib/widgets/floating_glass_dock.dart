// lib/widgets/floating_glass_dock.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/mini_bar_theme.dart';
import '../theme/design_tokens.dart';

class FloatingGlassDock extends StatelessWidget {
  final int currentIndex;
  final Function(int) onIndexChanged;

  const FloatingGlassDock({
    super.key,
    required this.currentIndex,
    required this.onIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 32, left: 16, right: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(MiniBarRadii.k30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: MiniBarGlass.blurSigma, sigmaY: MiniBarGlass.blurSigma),
            child: Container(
              height: 72,
              decoration: BoxDecoration(
                color: MiniBarColors.surface2.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(MiniBarRadii.k30),
                border: Border.all(color: MiniBarColors.line.withValues(alpha: 0.5)),
                boxShadow: MiniBarShadows.deep,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _NavItem(
                    icon: Icons.chair_outlined,
                    activeIcon: Icons.chair,
                    label: 'Lounge',
                    isActive: currentIndex == 0,
                    onTap: () => onIndexChanged(0),
                  ),
                  _CreateFab(
                    isActive: currentIndex == 1,
                    onTap: () => onIndexChanged(1),
                  ),
                  _NavItem(
                    icon: Icons.collections_bookmark_outlined,
                    activeIcon: Icons.collections_bookmark,
                    label: 'Gallery',
                    isActive: currentIndex == 2,
                    onTap: () => onIndexChanged(2),
                  ),
                  _NavItem(
                    icon: Icons.tune_outlined,
                    activeIcon: Icons.tune,
                    label: 'Settings',
                    isActive: currentIndex == 3,
                    onTap: () => onIndexChanged(3),
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
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 60,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? MiniBarColors.primary : MiniBarColors.muted,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isActive ? MiniBarColors.primary : MiniBarColors.muted,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateFab extends StatelessWidget {
  final bool isActive;
  final VoidCallback onTap;

  const _CreateFab({required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: MiniBarColors.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: MiniBarColors.primary.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Icon(
          Icons.add,
          color: MiniBarColors.bg0,
          size: 30,
        ),
      ),
    );
  }
}
