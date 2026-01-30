import 'package:flutter/material.dart';
import 'theme/guest_theme.dart';
import 'services/preferences_service.dart';
import 'src/constant.dart';
import 'splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize preferences
  await PreferencesService.instance.init();

  // Initialize RevenueCat
  await initRevenueCat();

  runApp(const GuestRoomAIApp());
}

class GuestRoomAIApp extends StatelessWidget {
  const GuestRoomAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guest Room AI',
      theme: guestThemeData,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
