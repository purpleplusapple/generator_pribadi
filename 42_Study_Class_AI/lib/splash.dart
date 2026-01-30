import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_class_ai/theme/app_theme.dart';
import 'onboards.dart';
import 'root_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkNextScreen();
  }

  Future<void> _checkNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final onboardingDone = prefs.getBool('onboarding_done') ?? false;

    if (onboardingDone) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const RootShell()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StudyAIColors.bg0,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: StudyAIColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: StudyAIColors.primary.withValues(alpha: 0.5),
                    blurRadius: 32,
                  ),
                ],
              ),
              child: const Icon(Icons.school_rounded, size: 64, color: StudyAIColors.bg0),
            ),
            const SizedBox(height: 24),
            Text(
              'Study Class AI',
              style: StudyAIText.h1.copyWith(color: StudyAIColors.ink0),
            ),
            const SizedBox(height: 8),
            Text(
              'Premium Academic Design',
              style: StudyAIText.bodyMedium.copyWith(color: StudyAIColors.muted),
            ),
          ],
        ),
      ),
    );
  }
}
