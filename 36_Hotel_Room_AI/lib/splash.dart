// Hotel Room AI splash → routes to onboarding once, then RootShell
import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hotel_room_ai/theme/hotel_room_ai_theme.dart';

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

  String _loadingText = "Preparing your design studio...";

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
      "Curating luxury textures...",
      "Setting mood lighting...",
      "Browsing fabric collection...",
      "Preparing design palette...",
      "Opening studio...",
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
    // Option A: Linen Theme
    const bg = HotelAIColors.bg0;
    const primary = HotelAIColors.primary;
    const ink = HotelAIColors.ink0;

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          // Background Texture (Subtle Gradient)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  HotelAIColors.bg0,
                  HotelAIColors.primarySoft.withValues(alpha: 0.3),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
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
                                color: HotelAIColors.primary.withValues(alpha: 0.2),
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
                        const SizedBox(height: 24),
                        Text(
                          "Hotel Room AI",
                          style: HotelAIText.h1.copyWith(
                            color: ink,
                            fontSize: 32,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Transform.translate(
                          offset: Offset(0, _taglineSlide.value),
                          child: Text(
                            "Design your perfect suite.",
                            textAlign: TextAlign.center,
                            style: HotelAIText.body.copyWith(
                              color: HotelAIColors.muted,
                              fontSize: 16,
                            ),
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
                              backgroundColor: HotelAIColors.primarySoft,
                              valueColor: AlwaysStoppedAnimation<Color>(primary),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
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
                            style: HotelAIText.caption,
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
            bottom: 32,
            child: Opacity(
              opacity: 0.82,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.lock_outline_rounded,
                    size: 16,
                    color: HotelAIColors.muted,
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Your photos are private and processed securely.",
                    textAlign: TextAlign.center,
                    style: HotelAIText.caption.copyWith(fontSize: 11),
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
