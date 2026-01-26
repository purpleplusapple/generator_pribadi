// Retail Store Boutique AI splash
import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:retail_store_boutique_ai/theme/boutique_theme.dart';

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

  String _loadingText = "Curating boutique elements…";

  @override
  void initState() {
    super.initState();

    _fadeInCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
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
      "Polishing marble surfaces…",
      "Adjusting track lighting…",
      "Arranging display tables…",
      "Selecting velvet textures…",
      "Preparing luxury snapshot…",
    ];
    int i = 0;

    Timer.periodic(const Duration(milliseconds: 1000), (timer) {
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
        transitionDuration: const Duration(milliseconds: 800),
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
      backgroundColor: BoutiqueColors.bg0,
      body: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: BoutiqueGradients.background,
              ),
            ),
          ),

          // Subtle Gold Glow
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: BoutiqueColors.primary.withValues(alpha: 0.1),
                filter: ui.ImageFilter.blur(sigmaX: 80, sigmaY: 80),
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
                  // App Icon
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: BoutiqueShadows.goldGlow(opacity: 0.2),
                      border: Border.all(
                        color: BoutiqueColors.primary.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.asset(
                        AppAssets.appIcon,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  Text(
                    "RETAIL STORE",
                    style: BoutiqueText.h3.copyWith(
                      letterSpacing: 3,
                      color: BoutiqueColors.primary,
                    ),
                  ),
                  Text(
                    "BOUTIQUE AI",
                    style: BoutiqueText.h1.copyWith(
                      fontWeight: FontWeight.w300,
                      color: BoutiqueColors.ink0,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Subtitle
                  Text(
                    "Luxury Makeover & Merchandising",
                    style: BoutiqueText.caption.copyWith(
                      letterSpacing: 1,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Loading
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(BoutiqueColors.primary),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    _loadingText,
                    style: BoutiqueText.caption,
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
