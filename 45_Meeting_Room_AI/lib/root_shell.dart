import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'theme/meeting_room_theme.dart';
import 'theme/meeting_tokens.dart';
import 'widgets/clean_bubble_background.dart';
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

  // Screens for each tab (excluding Wizard which is modal)
  final List<Widget> _screens = [
    const HomeScreen(),
    const GalleryScreen(),
    const SettingsScreen(),
  ];

  void _onFabPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const WizardScreen(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MeetingTokens.bg0,
      body: Stack(
        children: [
          // Background
          const Positioned.fill(
            child: CleanBubbleBackground(),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Top Segmented Navigation
                _buildTopNav(),

                // Body
                Expanded(
                  child: IndexedStack(
                    index: _currentIndex,
                    children: _screens,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onFabPressed,
        backgroundColor: MeetingTokens.accent,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text("NEW ROOM"),
        elevation: 4,
      ),
    );
  }

  Widget _buildTopNav() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Brand Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: MeetingTokens.surface2,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: MeetingTokens.line),
            ),
            child: const Icon(Icons.meeting_room_rounded, color: MeetingTokens.ink0),
          ),
          const SizedBox(width: 16),

          // Segments
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: MeetingTokens.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: MeetingTokens.line.withValues(alpha: 0.5)),
              ),
              child: Row(
                children: [
                  _buildSegment("COMMAND", 0),
                  _buildSegment("ARCHIVE", 1),
                  _buildSegment("SYSTEM", 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegment(String label, int index) {
    final isSelected = _currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isSelected ? MeetingTokens.surface2 : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected ? [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
            ] : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? MeetingTokens.ink0 : MeetingTokens.muted,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
