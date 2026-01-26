import 'package:flutter/material.dart';
import 'theme/design_tokens.dart';
import 'widgets/nav/floating_glass_dock.dart';
import 'screens/home/terrace_home_screen.dart';
import 'screens/wizard/terrace_wizard_screen.dart';
import 'screens/gallery/terrace_history_screen.dart';
import 'screens/settings/settings_screen.dart';

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _currentIndex = 0;

  // Screens for the "Tab" views (excluding Create which is a modal)
  // We map indices:
  // 0 -> Home
  // 1 -> Create (Modal) - Not a tab
  // 2 -> History
  // 3 -> Settings

  // Actual widgets to show for the underlying view.
  // We'll treat Home as default.
  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return const TerraceHomeScreen();
      case 2:
        return const TerraceHistoryScreen();
      case 3:
        return const SettingsScreen();
      default:
        return const TerraceHomeScreen();
    }
  }

  void _onDockItemTapped(int index) {
    if (index == 1) {
      // Show Create Sheet
      _showCreateSheet();
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  void _showCreateSheet() {
    // We treat the "Sheet" requirement as a full-screen modal flow for the complex wizard
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const TerraceWizardScreen(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: DesignTokens.bg0,
      body: Stack(
        children: [
          // Content
          _getScreen(_currentIndex),

          // Dock
          Align(
            alignment: Alignment.bottomCenter,
            child: FloatingGlassDock(
              selectedIndex: _currentIndex,
              onItemSelected: _onDockItemTapped,
            ),
          ),
        ],
      ),
    );
  }
}
