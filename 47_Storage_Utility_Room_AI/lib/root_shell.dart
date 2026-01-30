import 'package:flutter/material.dart';
import 'theme/storage_theme.dart';
import 'widgets/floating_dock.dart';
import 'screens/home/utility_dashboard.dart';
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

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
  }

  void _onCreateTap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const WizardScreen(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Screens
    final List<Widget> screens = [
      UtilityDashboard(onQuickStartTap: _onCreateTap),
      const GalleryScreen(), // Placeholder for Inventory/History
      const Center(child: Text("Saved (Coming Soon)")), // Placeholder
      const SettingsScreen(),
    ];

    return Scaffold(
      backgroundColor: StorageColors.bg0,
      body: Stack(
        children: [
          // Screen Content
          Positioned.fill(
            child: screens[_currentIndex],
          ),

          // Floating Dock
          FloatingDock(
            currentIndex: _currentIndex,
            onTap: _onNavTap,
            onCreateTap: _onCreateTap,
          ),
        ],
      ),
    );
  }
}
