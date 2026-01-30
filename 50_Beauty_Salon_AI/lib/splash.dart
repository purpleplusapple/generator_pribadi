// Beauty Salon AI splash
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/beauty_theme.dart';
import 'root_shell.dart';
import 'onboards.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _loadingText = "Preparing your Beauty Salon AI workspace…";

  @override
  void initState() {
    super.initState();
    _cycleLoadingText();
    _navigateAfterSplash();
  }

  void _cycleLoadingText() {
    const variants = [
      "Mixing color palettes...",
      "Polishing surfaces...",
      "Adjusting lighting...",
      "Preparing salon layouts...",
      "Loading beauty trends...",
    ];
    int i = 0;
    Timer.periodic(const Duration(milliseconds: 900), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
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

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => next),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BeautyTheme.bg0,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: BeautyTheme.primary,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: BeautyTheme.primary.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(Icons.spa, size: 64, color: Colors.white),
            ),
            const SizedBox(height: 24),
            Text(
              "Beauty Salon AI",
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: BeautyTheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _loadingText,
              style: const TextStyle(color: BeautyTheme.muted),
            ),
            const SizedBox(height: 32),
            const SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                color: BeautyTheme.primary,
                backgroundColor: BeautyTheme.surface2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
