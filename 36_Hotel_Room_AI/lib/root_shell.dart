// lib/root_shell.dart
// App shell with bottom navigation
// Updated for Option A: Boutique Linen

import 'package:flutter/material.dart';
import 'theme/hotel_room_ai_theme.dart';
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
    const WizardScreen(), // We might want to launch this as a modal, but for now keeping as tab 1
    const GalleryScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: HotelAIColors.bg0,
      body: IndexedStack( // Use IndexedStack to preserve state
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: HotelAIColors.bg1,
        border: const Border(
          top: BorderSide(
            color: HotelAIColors.line,
            width: 1,
          ),
        ),
        boxShadow: HotelAIShadows.soft,
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.dashboard_outlined,
                activeIcon: Icons.dashboard_rounded,
                label: 'Studio',
                index: 0,
              ),
              _buildNavItem(
                icon: Icons.auto_fix_high_outlined,
                activeIcon: Icons.auto_fix_high_rounded,
                label: 'Create',
                index: 1,
              ),
              _buildNavItem(
                icon: Icons.collections_bookmark_outlined,
                activeIcon: Icons.collections_bookmark_rounded,
                label: 'Gallery',
                index: 2,
              ),
              _buildNavItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person_rounded,
                label: 'Profile',
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
    required IconData activeIcon,
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
              isSelected ? activeIcon : icon,
              color: isSelected
                  ? HotelAIColors.primary
                  : HotelAIColors.muted,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: HotelAIText.caption.copyWith(
                color: isSelected
                    ? HotelAIColors.primary
                    : HotelAIColors.muted,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
