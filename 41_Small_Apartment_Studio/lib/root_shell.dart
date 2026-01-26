import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'theme/apartment_tokens.dart';
import 'screens/home/home_screen.dart';
import 'screens/gallery/gallery_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/wizard/wizard_screen.dart'; // Assuming we'll create this or it exists

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
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ApartmentTokens.bg0,
      appBar: AppBar(
        backgroundColor: ApartmentTokens.bg0,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 60,
        title: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 340),
          child: CupertinoSlidingSegmentedControl<int>(
            groupValue: _currentIndex,
            backgroundColor: ApartmentTokens.line.withOpacity(0.5),
            thumbColor: ApartmentTokens.primary,
            children: {
              0: _buildSegment('Explore', 0),
              1: _buildSegment('Saved', 1),
              2: _buildSegment('Settings', 2),
            },
            onValueChanged: (val) {
              if (val != null) {
                setState(() => _currentIndex = val);
              }
            },
          ),
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      floatingActionButton: _currentIndex == 0 ? FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const WizardScreen()),
          );
        },
        backgroundColor: ApartmentTokens.primary,
        icon: const Icon(Icons.add_home_work_rounded, color: Colors.white),
        label: const Text('New Studio', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ) : null,
    );
  }

  Widget _buildSegment(String text, int index) {
    final isSelected = _currentIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : ApartmentTokens.ink1,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
