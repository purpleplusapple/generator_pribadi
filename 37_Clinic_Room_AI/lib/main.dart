import 'package:flutter/material.dart';
import 'theme/clinic_theme.dart';
import 'services/preferences_service.dart';
import 'src/constant.dart';
import 'splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize preferences
  await PreferencesService.instance.init();

  // Initialize RevenueCat
  await initRevenueCat();

  runApp(const ClinicRoomAIApp());
}

class ClinicRoomAIApp extends StatelessWidget {
  const ClinicRoomAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clinic Room AI',
      theme: clinicTheme,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
