import 'package:flutter/material.dart';
import 'theme/shoe_room_ai_theme.dart';
import 'services/preferences_service.dart';
import 'src/constant.dart';
import 'splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize preferences
  await PreferencesService.instance.init();
  
  // Initialize RevenueCat
  await initRevenueCat();
  
  runApp(const ShoeRoomAIApp());
}

class ShoeRoomAIApp extends StatelessWidget {
  const ShoeRoomAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shoe Room AI',
      theme: shoeRoomAITheme,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
