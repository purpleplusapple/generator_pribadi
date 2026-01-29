import 'package:flutter/material.dart';
import 'theme/terrace_theme.dart';
import 'services/preferences_service.dart';
import 'src/constant.dart';
import 'splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize preferences
  await PreferencesService.instance.init();

  // Initialize RevenueCat
  await initRevenueCat();

  runApp(const BalconyTerraceApp());
}

class BalconyTerraceApp extends StatelessWidget {
  const BalconyTerraceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Balcony Terrace AI',
      theme: terraceTheme,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
