// lib/root_shell.dart
import 'package:flutter/material.dart';
import 'widgets/floating_glass_dock.dart';
import 'widgets/ambient_glow_background.dart';
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

  final List<Widget> _screens = [
    const HomeScreen(),
    const WizardScreen(),
    const GalleryScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Allows content to flow behind the dock
      body: Stack(
        children: [
          const Positioned.fill(child: AmbientGlowBackground()),
          SafeArea(
            bottom: false,
            child: IndexedStack(
              index: _currentIndex,
              children: _screens,
            ),
          ),
          FloatingGlassDock(
            currentIndex: _currentIndex,
            onIndexChanged: (index) => setState(() => _currentIndex = index),
          ),
        ],
      ),
    );
  }
}
