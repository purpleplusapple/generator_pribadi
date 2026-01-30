// Barbershop AI splash
import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:barbershop_ai/theme/barber_theme.dart';

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
  late final AnimationController _bgCtrl;
  late final AnimationController _fadeInCtrl;

  late final Animation<double> _fadeIn;
  late final Animation<double> _logoScale;
  late final Animation<double> _taglineSlide;

  String _loadingText = "Setting up your barbershop workspace…";

  @override
  void initState() {
    super.initState();

    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat(reverse: true);

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

    _taglineSlide = Tween<double>(begin: 14, end: 0).animate(
      CurvedAnimation(
        parent: _fadeInCtrl,
        curve: Curves.easeOutCubic,
      ),
    );

    _cycleLoadingText();
    _navigateAfterSplash();
  }

  void _cycleLoadingText() {
    const variants = [
      "Selecting premium materials…",
      "Calibrating lighting setups…",
      "Organizing grooming stations…",
      "Polishing chrome details…",
      "Preparing luxury finishes…",
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
        : const OnboardingScreen(); // We might need to rename Onboards too later

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
    _bgCtrl.dispose();
    _fadeInCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bg = BarberTheme.bg0;
    const primary = BarberTheme.primary;

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          // Background
          Positioned.fill(
             child: Container(color: bg),
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
                                color: Colors.black.withOpacity(0.45),
                                blurRadius: 26,
                                offset: const Offset(0, 12),
                              ),
                              BoxShadow(
                                color: primary.withOpacity(0.22),
                                blurRadius: 32,
                                spreadRadius: 1,
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
                          "Barbershop AI",
                          style: TextStyle(
                            color: BarberTheme.ink0,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Transform.translate(
                          offset: Offset(0, _taglineSlide.value),
                          child: const Text(
                            "Design premium grooming spaces with AI.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: BarberTheme.muted,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Loading indicator
                        SizedBox(
                          width: 200,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(999),
                            child: LinearProgressIndicator(
                              minHeight: 4,
                              backgroundColor: BarberTheme.surface2,
                              valueColor:
                              AlwaysStoppedAnimation<Color>(primary),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 260),
                          transitionBuilder: (child, anim) => FadeTransition(
                            opacity: anim,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 0.15),
                                end: Offset.zero,
                              ).animate(anim),
                              child: child,
                            ),
                          ),
                          child: Text(
                            _loadingText,
                            key: ValueKey(_loadingText),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: BarberTheme.muted,
                              fontSize: 11.5,
                            ),
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

// Minimal placeholder for AnimatedBackdrop to avoid errors if I deleted it
class AnimatedBackdrop extends StatelessWidget {
  final AnimationController ctrl;
  const AnimatedBackdrop({super.key, required this.ctrl});
  @override
  Widget build(BuildContext context) {
    return Container(color: BarberTheme.bg0);
  }
}
