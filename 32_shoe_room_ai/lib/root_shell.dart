// lib/root_shell.dart
// App shell with bottom navigation

import 'package:flutter/material.dart';
import 'theme/shoe_room_ai_theme.dart';
import 'widgets/clean_bubble_background.dart';
import 'screens/home/home_screen.dart';
import 'screens/wizard/wizard_screen.dart';
import 'screens/gallery/gallery_screen.dart';
import 'screens/settings/settings_screen.dart';

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _currentIndex = 0;

  // Screens for each tab
  final List<Widget> _screens = [
    const HomeScreen(),
    const WizardScreen(),
    const GalleryScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: ShoeAIColors.soleBlack,
      body: Stack(
        children: [
          // Animated background
          const Positioned.fill(
            child: CleanBubbleBackground(),
          ),
          // Current screen
          _screens[_currentIndex],
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: ShoeAIColors.soleBlack.withValues(alpha: 0.8),
        border: Border(
          top: BorderSide(
            color: ShoeAIColors.canvasWhite.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                index: 0,
              ),
              _buildNavItem(
                icon: Icons.auto_fix_high_rounded,
                label: 'Wizard',
                index: 1,
              ),
              _buildNavItem(
                icon: Icons.grid_view_rounded,
                label: 'Gallery',
                index: 2,
              ),
              _buildNavItem(
                icon: Icons.settings_rounded,
                label: 'Settings',
                index: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _currentIndex = index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? ShoeAIColors.leatherTan
                  : ShoeAIColors.canvasWhite.withValues(alpha: 0.5),
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: ShoeAIText.small.copyWith(
                color: isSelected
                    ? ShoeAIColors.leatherTan
                    : ShoeAIColors.canvasWhite.withValues(alpha: 0.5),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
