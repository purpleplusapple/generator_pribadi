import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:retail_store_boutique_ai/theme/boutique_theme.dart';

class FloatingGlassDock extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onCreateTap;

  const FloatingGlassDock({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
    required this.onCreateTap,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 32, left: 32, right: 32),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              height: 72,
              decoration: BoxDecoration(
                color: BoutiqueColors.bg0.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: BoutiqueColors.line.withValues(alpha: 0.5),
                  width: 1,
                ),
                boxShadow: BoutiqueShadows.card,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTabItem(0, Icons.storefront_outlined, Icons.storefront),

                  // Center Create Button
                  GestureDetector(
                    onTap: onCreateTap,
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: BoutiqueColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: BoutiqueShadows.goldGlow(opacity: 0.5),
                      ),
                      child: Icon(
                        Icons.add,
                        color: BoutiqueColors.bg0,
                        size: 32,
                      ),
                    ),
                  ),

                  _buildTabItem(1, Icons.history_edu, Icons.history_edu), // Using history index as 1 for now in UI logic, mapped to real index later
                  _buildTabItem(2, Icons.settings_outlined, Icons.settings),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(int index, IconData iconOff, IconData iconOn) {
    // Map UI index to Tab index.
    // UI: 0=Home, 1=History, 2=Settings
    // Create is separate.

    final isSelected = currentIndex == index;
    return IconButton(
      onPressed: () => onTabSelected(index),
      icon: Icon(
        isSelected ? iconOn : iconOff,
        color: isSelected ? BoutiqueColors.ink0 : BoutiqueColors.ink1.withValues(alpha: 0.5),
        size: 26,
      ),
    );
  }
}
