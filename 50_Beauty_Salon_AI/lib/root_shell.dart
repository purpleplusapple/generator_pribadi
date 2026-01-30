import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/beauty_home_dashboard.dart';
import 'screens/history/salon_portfolio_page.dart';
import 'screens/wizard/beauty_wizard_screen.dart';
import 'theme/beauty_theme.dart';
import 'widgets/nav/floating_glass_dock.dart';

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    // 0: Home
    BeautyHomeDashboard(onCreateTap: () {}), // Callbacks handled by Dock usually
    // 1: Portfolio
    const SalonPortfolioPage(),
    // 2: Trends (Placeholder)
    const Center(child: Text('Trends Coming Soon')),
    // 3: Settings (Placeholder)
    const Center(child: Text('Settings')),
  ];

  void _onTabSelected(int index) {
    HapticFeedback.lightImpact();
    setState(() => _currentIndex = index);
  }

  void _onCreateTap() {
    HapticFeedback.mediumImpact();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const BeautyWizardScreen(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BeautyTheme.bg0,
      body: Stack(
        children: [
          // 1. Current Page
          IndexedStack(
            index: _currentIndex,
            children: _pages.map((p) {
               // If Home, pass callback (hacky fix since I instantiated it in list)
               if (p is BeautyHomeDashboard) {
                 return BeautyHomeDashboard(onCreateTap: _onCreateTap);
               }
               return p;
            }).toList(),
          ),

          // 2. Floating Dock (Bottom)
          FloatingGlassDock(
            selectedIndex: _currentIndex,
            onItemSelected: _onTabSelected,
            onCenterFabTap: _onCreateTap,
          ),

          // 3. Floating FAB (Top of Dock)
          GlassDockFab(onTap: _onCreateTap),
        ],
      ),
    );
  }
}
