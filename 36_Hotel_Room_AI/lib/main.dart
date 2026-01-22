import 'package:flutter/material.dart';
import 'theme/hotel_room_ai_theme.dart';
import 'services/preferences_service.dart';
import 'src/constant.dart';
import 'splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize preferences
  await PreferencesService.instance.init();

  // Initialize RevenueCat
  await initRevenueCat();

  runApp(const HotelRoomAIApp());
}

class HotelRoomAIApp extends StatelessWidget {
  const HotelRoomAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hotel Room AI',
      theme: hotelRoomAITheme,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
