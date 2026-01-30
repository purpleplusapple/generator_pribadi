// lib/root_shell.dart
// App shell with Floating Glass Dock

import 'package:flutter/material.dart';
import 'theme/camper_theme.dart';
import 'widgets/nav/floating_glass_dock.dart';
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
  // 0: Home, 1: Gallery, 2: Saved (Gallery placeholder), 3: Settings
  final List<Widget> _screens = [
    const HomeScreen(),
    const GalleryScreen(),
    const GalleryScreen(), // Placeholder for Saved
    const SettingsScreen(),
  ];

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onBuildPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const WizardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: CamperAIColors.soleBlack,
      body: Stack(
        children: [
          // Background (Plain dark for premium feel)
          Container(color: CamperAIColors.bg0),

          // Current screen
          IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),

          // Floating Dock at bottom center
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: FloatingGlassDock(
              selectedIndex: _currentIndex,
              onTabSelected: _onTabSelected,
              onBuildPressed: _onBuildPressed,
            ),
          ),
        ],
      ),
    );
  }
}
