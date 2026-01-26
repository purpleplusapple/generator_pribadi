// lib/root_shell.dart
// App shell with Floating Glass Dock navigation

import 'package:flutter/material.dart';
import 'theme/boutique_theme.dart';
import 'widgets/floating_glass_dock.dart';
import 'widgets/create_bottom_sheet.dart';
import 'screens/home/home_screen.dart';
import 'screens/gallery/gallery_screen.dart';
import 'screens/settings/settings_screen.dart';

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _currentIndex = 0;

  // Screens for each tab (excluding Create which is a modal)
  final List<Widget> _screens = [
    const HomeScreen(),
    const GalleryScreen(),
    const SettingsScreen(),
  ];

  void _onTabSelected(int index) {
    setState(() => _currentIndex = index);
  }

  void _showCreateSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const CreateBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: BoutiqueColors.bg0,
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: BoutiqueGradients.background,
              ),
            ),
          ),

          // Current screen
          IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),

          // Floating Dock
          FloatingGlassDock(
            currentIndex: _currentIndex,
            onTabSelected: _onTabSelected,
            onCreateTap: _showCreateSheet,
          ),
        ],
      ),
    );
  }
}
