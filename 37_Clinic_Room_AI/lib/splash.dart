// Clinic Room AI splash → routes to onboarding once, then RootShell
import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:clinic_room_ai/theme/clinic_theme.dart';

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

  String _loadingText = "Preparing your Clinic Room AI workspace…";

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
      "Analyzing sanitary layouts…",
      "Optimizing patient flow…",
      "Loading medical design standards…",
      "Preparing lighting models…",
      "Initializing AI architect…",
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
        reverseTransitionDuration: const Duration(milliseconds: 380),
        pageBuilder: (_, __, ___) => next,
        transitionsBuilder: (_, anim, __, child) {
          final curved = CurvedAnimation(
            parent: anim,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          );
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.04),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
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
      backgroundColor: ClinicColors.bg0,
      body: Stack(
        children: [
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
                            boxShadow: ClinicShadows.card,
                            color: Colors.white,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(22),
                            child: Icon(Icons.local_hospital_rounded, size: 60, color: ClinicColors.primary),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Clinic Room AI",
                          style: ClinicText.h1.copyWith(color: ClinicColors.ink0),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            "Upload a photo and explore professional medical spaces with AI.",
                            textAlign: TextAlign.center,
                            style: ClinicText.body.copyWith(color: ClinicColors.ink2),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Loading indicator
                        SizedBox(
                          width: 200,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(999),
                            child: LinearProgressIndicator(
                              minHeight: 4,
                              backgroundColor: ClinicColors.line,
                              valueColor: AlwaysStoppedAnimation<Color>(ClinicColors.primary),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 260),
                          child: Text(
                            _loadingText,
                            key: ValueKey(_loadingText),
                            textAlign: TextAlign.center,
                            style: ClinicText.caption,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom trust label
          Positioned(
            left: 0,
            right: 0,
            bottom: 24,
            child: Opacity(
              opacity: 0.6,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.security,
                    size: 14,
                    color: ClinicColors.ink2,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "HIPAA Compliant Design Standards",
                    textAlign: TextAlign.center,
                    style: ClinicText.small,
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
