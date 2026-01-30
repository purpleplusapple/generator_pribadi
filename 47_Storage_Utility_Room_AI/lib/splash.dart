import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/storage_theme.dart';
import 'onboards.dart';
import 'root_shell.dart';
import 'src/app_assets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _loadingText = "Analyzing storage potential...";

  @override
  void initState() {
    super.initState();
    _cycleLoadingText();
    _navigateAfterSplash();
  }

  void _cycleLoadingText() {
    const variants = [
      "Analyzing storage potential...",
      "Calibrating shelving systems...",
      "Organizing utility zones...",
      "Loading pro-grade styles...",
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

    final next = onboardingDone ? const RootShell() : const OnboardingScreen();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => next),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StorageColors.bg0,
      body: Stack(
        children: [
          // Background Grid
          Positioned.fill(
            child: CustomPaint(
              painter: GridPainter(),
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: StorageColors.surface,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: StorageColors.line, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: StorageColors.primaryLime.withValues(alpha: 0.1),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: Image.asset(AppAssets.appIcon),
                  ),
                ),
                const SizedBox(height: 32),

                // Text
                Text(
                  "STORAGE ROOM AI",
                  style: StorageTheme.darkTheme.textTheme.displaySmall,
                ),
                const SizedBox(height: 8),
                Text(
                  "PRO ORGANIZATION & UTILITY",
                  style: TextStyle(
                    color: StorageColors.primaryLime,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                  ),
                ),

                const SizedBox(height: 60),

                // Loader
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    color: StorageColors.primaryLime,
                    strokeWidth: 3,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _loadingText,
                  style: StorageTheme.darkTheme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = StorageColors.line.withValues(alpha: 0.3)
      ..strokeWidth = 1;

    const double spacing = 40;

    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
