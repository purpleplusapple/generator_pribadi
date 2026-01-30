// lib/root_shell.dart
// Barbershop AI Scaffold with Floating Glass Dock

import 'package:flutter/material.dart';
import 'theme/barber_theme.dart';
import 'widgets/floating_glass_dock.dart';
import 'screens/home/home_screen.dart';
import 'screens/wizard/wizard_screen.dart';
import 'screens/gallery/gallery_screen.dart';
import 'screens/settings/settings_screen.dart';

class BarberScaffold extends StatefulWidget {
  const BarberScaffold({super.key});

  @override
  State<BarberScaffold> createState() => _BarberScaffoldState();
}

class _BarberScaffoldState extends State<BarberScaffold> {
  int _currentIndex = 0;

  // Screens for each tab
  // 0: Shop (Home)
  // 1: Create (Wizard) - Center Highlight
  // 2: Gallery
  // 3: Settings
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
      backgroundColor: BarberTheme.bg0,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Current Screen
          _screens[_currentIndex],

          // Floating Dock
          FloatingGlassDock(
            currentIndex: _currentIndex,
            onTabSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ],
      ),
    );
  }
}

// Keeping this class name for now to avoid breaking imports in main.dart or splash.dart
// that expect RootShell. We simply redirect to BarberScaffold.
class RootShell extends StatelessWidget {
  const RootShell({super.key});

  @override
  Widget build(BuildContext context) {
    return const BarberScaffold();
  }
}
