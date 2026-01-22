import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'services/preferences_service.dart';
import 'src/constant.dart';
import 'splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize preferences
  await PreferencesService.instance.init();

  // Initialize RevenueCat
  await initRevenueCat();

  runApp(const RooftopLoungeApp());
}

class RooftopLoungeApp extends StatelessWidget {
  const RooftopLoungeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rooftop Lounge AI',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
