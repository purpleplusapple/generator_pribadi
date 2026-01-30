import 'package:flutter/material.dart';
import 'theme/mini_bar_theme.dart';
import 'services/preferences_service.dart';
import 'src/constant.dart';
import 'splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await PreferencesService.instance.init();
  await initRevenueCat();

  runApp(const MiniBarAIApp());
}

class MiniBarAIApp extends StatelessWidget {
  const MiniBarAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Bar AI',
      theme: miniBarTheme,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
