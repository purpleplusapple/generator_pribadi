import 'package:flutter/material.dart';
import 'theme/beauty_salon_ai_theme.dart';
import 'services/preferences_service.dart';
import 'src/constant.dart';
import 'splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize preferences
  await PreferencesService.instance.init();

  // Initialize RevenueCat
  await initRevenueCat();

  runApp(const BeautySalonAIApp());
}

class BeautySalonAIApp extends StatelessWidget {
  const BeautySalonAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beauty Salon AI',
      theme: beautySalonAITheme,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
