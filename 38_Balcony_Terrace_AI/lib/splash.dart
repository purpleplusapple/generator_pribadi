import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:balcony_terrace_ai/theme/terrace_theme.dart';
import 'package:balcony_terrace_ai/theme/design_tokens.dart';

import 'onboards.dart';
import 'root_shell.dart';
import 'src/app_assets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _fadeInCtrl;
  late final Animation<double> _fadeIn;

  String _loadingText = "Preparing your Terrace workspace…";

  @override
  void initState() {
    super.initState();

    _fadeInCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    _fadeIn = CurvedAnimation(
      parent: _fadeInCtrl,
      curve: Curves.easeOutCubic,
    );

    _cycleLoadingText();
    _navigateAfterSplash();
  }

  void _cycleLoadingText() {
    const variants = [
      "Gathering night lights…",
      "Planting virtual greenery…",
      "Arranging cozy furniture…",
      "Setting the mood…",
    ];
    int i = 0;

    Timer.periodic(const Duration(milliseconds: 1200), (timer) {
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

    await Future.delayed(const Duration(milliseconds: 2500));
    if (!mounted) return;

    final next = onboardingDone
        ? const RootShell()
        : const OnboardingScreen();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 650),
        reverseTransitionDuration: const Duration(milliseconds: 380),
        pageBuilder: (_, __, ___) => next,
        transitionsBuilder: (_, anim, __, child) {
          return FadeTransition(opacity: anim, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _fadeInCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.bg0,
      body: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    DesignTokens.bg0,
                    DesignTokens.primarySoft.withOpacity(0.3),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // Center Content
          Center(
            child: FadeTransition(
              opacity: _fadeIn,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: DesignTokens.surface,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: DesignTokens.shadowGlowAmber,
                    ),
                    child: const Icon(Icons.deck, size: 64, color: DesignTokens.primary),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Balcony Terrace AI",
                    style: terraceTheme.textTheme.displaySmall?.copyWith(
                      color: DesignTokens.ink0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Transform your outdoor space into a night oasis.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: DesignTokens.ink1,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const CircularProgressIndicator(color: DesignTokens.primary),
                  const SizedBox(height: 16),
                  Text(
                    _loadingText,
                    style: const TextStyle(color: DesignTokens.muted),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
