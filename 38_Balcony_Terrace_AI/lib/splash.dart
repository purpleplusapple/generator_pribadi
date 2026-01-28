// Balcony Terrace AI splash → routes to onboarding once, then RootShell
import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:balcony_terrace_ai/theme/balcony_terrace_ai_theme.dart';

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

  String _loadingText = "Preparing your Balcony Terrace AI workspace…";

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
      "Organizing storage solutions…",
      "Optimizing terrace flow…",
      "Preparing clean design space…",
      "Setting up utility features…",
      "Loading fresh layouts…",
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
    _bgCtrl.dispose();
    _fadeInCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bg = TerraceAIColors.soleBlack;
    const primary = TerraceAIColors.leatherTan;

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          // Animated dark backdrop
          Positioned.fill(
            child: AnimatedBackdrop(ctrl: _bgCtrl),
          ),

          // Blur + vignette
          Positioned.fill(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.35),
                      Colors.black.withValues(alpha: 0.88),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
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
                              BoxShadow(
                                color: primary.withValues(alpha: 0.22),
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
                          "Balcony Terrace AI",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Transform.translate(
                          offset: Offset(0, _taglineSlide.value),
                          child: const Text(
                            "Upload a photo and explore clean, organized terrace spaces with AI.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
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
                              backgroundColor:
                              Colors.white.withValues(alpha: 0.10),
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
                              color: Colors.white54,
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

          // Bottom trust label
          Positioned(
            left: 0,
            right: 0,
            bottom: 24,
            child: Opacity(
              opacity: 0.82,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.verified_user,
                    size: 14,
                    color: Color(0xFF9CA3AF),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Your room photos stay private and are only used to generate terrace designs.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 9.5,
                    ),
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
