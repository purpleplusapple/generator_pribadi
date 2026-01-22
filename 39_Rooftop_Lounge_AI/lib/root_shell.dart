import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/home/home_screen.dart';
import 'screens/gallery/gallery_screen.dart';
import 'widgets/nav/floating_glass_dock.dart';
import 'widgets/create_bottom_sheet.dart';

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const GalleryScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onCreateTapped() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const CreateBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: DesignTokens.bg0,
      body: Stack(
        children: [
          // Screen
          IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),

          // Dock
          FloatingGlassDock(
            currentIndex: _currentIndex,
            onItemSelected: _onItemTapped,
            onCreateTap: _onCreateTapped,
          ),
        ],
      ),
    );
  }
}
