import 'package:flutter/material.dart';
import 'theme/guest_theme.dart';
import 'screens/home/guest_welcome_screen.dart';
import 'screens/gallery/guest_history_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/wizard/guest_wizard_screen.dart';

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _screens = [
    const GuestWelcomeScreen(),
    const GuestHistoryScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GuestAIColors.warmLinen,
      appBar: AppBar(
        title: _buildSegmentedNav(),
        centerTitle: true,
        backgroundColor: GuestAIColors.warmLinen,
        elevation: 0,
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Control via segments
        children: _screens,
      ),
      floatingActionButton: _currentIndex != 2 ? FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const GuestWizardScreen()),
          );
        },
        backgroundColor: GuestAIColors.brass,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add, size: 20),
        label: Text("Design Room", style: GuestAIText.button.copyWith(color: Colors.white)),
        elevation: 4,
      ) : null,
    );
  }

  Widget _buildSegmentedNav() {
    return Container(
      height: 40,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: GuestAIColors.softSurface,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: GuestAIColors.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSegment("Inspire", 0),
          _buildSegment("History", 1),
          _buildSegment("Settings", 2),
        ],
      ),
    );
  }

  Widget _buildSegment(String label, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() => _currentIndex = index);
        _pageController.jumpToPage(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? GuestAIColors.pureWhite : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected ? [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4),
          ] : [],
        ),
        child: Text(
          label,
          style: isSelected
              ? GuestAIText.bodyMedium.copyWith(color: GuestAIColors.inkTitle)
              : GuestAIText.bodyMedium.copyWith(color: GuestAIColors.muted),
        ),
      ),
    );
  }
}
