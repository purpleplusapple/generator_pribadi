// lib/splash.dart
import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:camper_van_interior_ai/theme/camper_tokens.dart';

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
  late final AnimationController _pulseCtrl;
  late final AnimationController _fadeInCtrl;

  late final Animation<double> _fadeIn;
  late final Animation<double> _logoScale;

  String _loadingText = "Preparing your conversion studio...";

  @override
  void initState() {
    super.initState();

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _fadeInCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 720),
    )..forward();

    _fadeIn = CurvedAnimation(
      parent: _fadeInCtrl,
      curve: Curves.easeOutCubic,
    );

    _logoScale = Tween<double>(begin: 0.94, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeInCtrl,
        curve: Curves.easeOutBack,
      ),
    );

    _cycleLoadingText();
    _navigateAfterSplash();
  }

  void _cycleLoadingText() {
    const variants = [
      "Loading cabinetry textures...",
      "Calibrating floor plans...",
      "Preparing lighting engines...",
      "Optimizing solar layouts...",
      "Starting Van Studio...",
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

    await Future.delayed(const Duration(milliseconds: 1900));
    if (!mounted) return;

    final next = onboardingDone
        ? const RootShell()
        : const OnboardingScreen();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 650),
        pageBuilder: (_, __, ___) => next,
        transitionsBuilder: (_, anim, __, child) {
          return FadeTransition(opacity: anim, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _fadeInCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CamperTokens.bg0,
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [CamperTokens.bg0, CamperTokens.bg1],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Center logo + brand + loading
          Center(
            child: AnimatedBuilder(
              animation: Listenable.merge([_pulseCtrl, _fadeInCtrl]),
              builder: (context, _) {
                final pulseScale = 1.0 + (_pulseCtrl.value * 0.02);
                final scale = _logoScale.value * pulseScale;

                return Opacity(
                  opacity: _fadeIn.value,
                  child: Transform.scale(
                    scale: scale,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // App icon / brand image
                        Container(
                          width: 104,
                          height: 104,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.45),
                                blurRadius: 26,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(22),
                            child: Image.asset(
                              AppAssets.appIcon,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          "Camper Van Interior AI",
                          style: TextStyle(
                            color: CamperTokens.ink0,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Visualize your dream build in seconds.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: CamperTokens.muted,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Loading indicator
                        SizedBox(
                          width: 200,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(999),
                            child: const LinearProgressIndicator(
                              minHeight: 4,
                              backgroundColor: CamperTokens.surface,
                              valueColor:
                              AlwaysStoppedAnimation<Color>(CamperTokens.primary),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _loadingText,
                          key: ValueKey(_loadingText),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: CamperTokens.muted,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
