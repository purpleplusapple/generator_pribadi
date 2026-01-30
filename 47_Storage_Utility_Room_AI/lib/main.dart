import 'package:flutter/material.dart';
import 'theme/storage_theme.dart';
import 'services/preferences_service.dart';
import 'src/constant.dart';
import 'splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize preferences
  await PreferencesService.instance.init();

  // Initialize RevenueCat
  try {
    await initRevenueCat();
  } catch (e) {
    print("RevenueCat init error (expected in sandbox): $e");
  }

  runApp(const StorageUtilityRoomApp());
}

class StorageUtilityRoomApp extends StatelessWidget {
  const StorageUtilityRoomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Storage Utility Room AI',
      theme: StorageTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
