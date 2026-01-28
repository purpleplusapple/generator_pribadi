// lib/root_shell.dart
// App shell with floating glass dock

import 'package:flutter/material.dart';
import 'theme/terrace_theme.dart';
import 'widgets/night_bokeh_background.dart';
import 'widgets/glass_dock.dart';
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
      backgroundColor: TerraceAIColors.bg0,
      body: Stack(
        children: [
          // Animated background
          const Positioned.fill(
            child: NightBokehBackground(),
          ),
          // Current screen
          IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),

          // Floating Dock
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: GlassDock(
                currentIndex: _currentIndex,
                onTap: (index) {
                  setState(() => _currentIndex = index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
