// lib/splash.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/mini_bar_theme.dart';
import 'theme/design_tokens.dart';
import 'onboards.dart';
import 'root_shell.dart';
import 'src/app_assets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final done = prefs.getBool('onboarding_done') ?? false;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => done ? const RootShell() : const OnboardingScreen())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MiniBarColors.bg0,
      body: Stack(
        children: [
          // Amber Glow
          Positioned(
            top: -100, left: -100,
            child: Container(
              width: 300, height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: MiniBarColors.primary.withValues(alpha: 0.2),
                boxShadow: const [BoxShadow(blurRadius: 100, color: MiniBarColors.primarySoft)],
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(MiniBarRadii.k24),
                  child: SvgPicture.asset(AppAssets.appIcon, width: 120, height: 120),
                ),
                const SizedBox(height: 24),
                Text('Mini Bar AI', style: MiniBarText.h1),
                const SizedBox(height: 8),
                Text('Speakeasy Luxury at Home', style: MiniBarText.body.copyWith(color: MiniBarColors.muted)),
                const SizedBox(height: 48),
                const CircularProgressIndicator(color: MiniBarColors.primary),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
