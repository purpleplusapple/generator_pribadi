import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/storage_theme.dart';

class FloatingDock extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final VoidCallback onCreateTap;

  const FloatingDock({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onCreateTap,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.fromLTRB(24, 0, 24, 32),
        height: 72,
        decoration: BoxDecoration(
          color: StorageColors.surface.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: StorageColors.line.withValues(alpha: 0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(Icons.dashboard_rounded, "Dash", 0),
                _buildNavItem(Icons.inventory_2_rounded, "History", 1),

                // Center FAB
                GestureDetector(
                  onTap: onCreateTap,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: StorageColors.primaryLime,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: StorageColors.primaryLime.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      color: Colors.black,
                      size: 28,
                    ),
                  ),
                ),

                _buildNavItem(Icons.bookmark_rounded, "Saved", 2),
                _buildNavItem(Icons.settings_rounded, "Settings", 3),
              ],
            ),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? StorageColors.ink0 : StorageColors.muted,
            size: 24,
          ),
          const SizedBox(height: 4),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: isSelected ? 1.0 : 0.0,
            child: Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: StorageColors.primaryLime,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
