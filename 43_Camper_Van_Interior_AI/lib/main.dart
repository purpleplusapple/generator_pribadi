import 'package:flutter/material.dart';
import 'theme/camper_theme.dart';
import 'services/preferences_service.dart';
import 'src/constant.dart';
import 'splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize preferences
  await PreferencesService.instance.init();

  // Initialize RevenueCat
  await initRevenueCat();

  runApp(const CamperVanAIApp());
}

class CamperVanAIApp extends StatelessWidget {
  const CamperVanAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camper Van AI',
      theme: camperVanTheme,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
