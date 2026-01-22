import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/app_theme.dart';
import 'onboards.dart';
import 'root_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _loadingText = "Preparing Rooftop Lounge AI...";

  @override
  void initState() {
    super.initState();
    _cycleLoadingText();
    _navigateAfterSplash();
  }

  void _cycleLoadingText() {
    const variants = [
      "Mixing cocktails...",
      "Dimming the lights...",
      "Checking the skyline...",
      "Preparing luxury textures...",
      "Polishing the glass...",
    ];
    int i = 0;
    Timer.periodic(const Duration(milliseconds: 900), (timer) {
      if (!mounted) { timer.cancel(); return; }
      setState(() => _loadingText = variants[i % variants.length]);
      i++;
    });
  }

  Future<void> _navigateAfterSplash() async {
    final prefs = await SharedPreferences.getInstance();
    final bool onboardingDone = prefs.getBool('onboarding_done') ?? false;
    await Future.delayed(const Duration(milliseconds: 2000));
    if (!mounted) return;

    final next = onboardingDone ? const RootShell() : const OnboardingScreen();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => next));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.bg0,
      body: Stack(
        children: [
          Positioned.fill(child: Container(color: DesignTokens.bg0)),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 120, height: 120,
                  decoration: BoxDecoration(
                    color: DesignTokens.surface,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: DesignTokens.primary.withOpacity(0.3), blurRadius: 30, spreadRadius: 5),
                    ],
                  ),
                  child: const Icon(Icons.nightlife, size: 60, color: DesignTokens.primary),
                ),
                const SizedBox(height: 24),
                Text("Rooftop Lounge AI", style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontFamily: 'DM Serif Display', color: DesignTokens.ink0)),
                const SizedBox(height: 8),
                const Text("Redesign your nights", style: TextStyle(color: DesignTokens.ink1, letterSpacing: 1.5)),
                const SizedBox(height: 48),
                SizedBox(
                  width: 200,
                  child: LinearProgressIndicator(backgroundColor: DesignTokens.surface, color: DesignTokens.primary),
                ),
                const SizedBox(height: 16),
                Text(_loadingText, style: const TextStyle(color: DesignTokens.ink1, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
