import 'package:flutter/material.dart';
import 'screens/home/home_screen.dart';
import 'screens/wizard/wizard_screen.dart';
import 'screens/gallery/gallery_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'widgets/nav/floating_glass_dock.dart';

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
      body: Stack(
        children: [
          // Current screen
          // We don't use clean bubble background anymore.
          // The Theme background is solid/dark.
          Positioned.fill(
            child: _screens[_currentIndex],
          ),

          // Floating Dock
          FloatingGlassDock(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() => _currentIndex = index);
            },
          ),
        ],
      ),
    );
  }
}
