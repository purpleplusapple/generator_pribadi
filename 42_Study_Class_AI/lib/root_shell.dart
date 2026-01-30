import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
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

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(onCreateTap: () => _navigateTo(1)),
      const WizardScreen(),
      const GalleryScreen(),
      const SettingsScreen(),
    ];
  }

  void _navigateTo(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: StudyAIColors.bg0,
      body: Stack(
        children: [
          // Background
          const Positioned.fill(
            child: CleanBubbleBackground(),
          ),
          // Screen
          IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
          // Floating Dock
          Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: _buildFloatingDock(),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingDock() {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: StudyAIColors.surface.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(36),
        border: Border.all(
          color: StudyAIColors.line.withValues(alpha: 0.5),
        ),
        boxShadow: StudyAIShadows.elevated,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(0, Icons.dashboard_outlined, Icons.dashboard, 'Home'),
          _buildNavItem(1, Icons.add_circle_outline, Icons.add_circle, 'Create', isProminent: true),
          _buildNavItem(2, Icons.photo_library_outlined, Icons.photo_library, 'Library'),
          _buildNavItem(3, Icons.settings_outlined, Icons.settings, 'Settings'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon, String label, {bool isProminent = false}) {
    final isSelected = _currentIndex == index;

    if (isProminent) {
      return GestureDetector(
        onTap: () => _navigateTo(index),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: StudyAIColors.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: StudyAIColors.primary.withValues(alpha: 0.4),
                blurRadius: 12,
                spreadRadius: 2,
              )
            ],
          ),
          child: Icon(activeIcon, color: StudyAIColors.bg0, size: 28),
        ),
      );
    }

    return GestureDetector(
      onTap: () => _navigateTo(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSelected ? activeIcon : icon,
            color: isSelected ? StudyAIColors.primary : StudyAIColors.muted,
            size: 24,
          ),
          const SizedBox(height: 4),
          if (isSelected)
            Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: StudyAIColors.primary,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
