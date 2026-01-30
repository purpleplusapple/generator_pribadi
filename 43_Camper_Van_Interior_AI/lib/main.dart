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

  runApp(const CamperVanInteriorAIApp());
}

class CamperVanInteriorAIApp extends StatelessWidget {
  const CamperVanInteriorAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camper Van Interior AI',
      theme: camperTheme,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
