import 'package:flutter/material.dart';
import 'theme/boutique_theme.dart';
import 'services/preferences_service.dart';
import 'src/constant.dart';
import 'splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize preferences
  await PreferencesService.instance.init();

  // Initialize RevenueCat
  await initRevenueCat();

  runApp(const RetailStoreBoutiqueApp());
}

class RetailStoreBoutiqueApp extends StatelessWidget {
  const RetailStoreBoutiqueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Retail Store Boutique AI',
      theme: boutiqueTheme,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
