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

  runApp(const StudyClassAIApp());
}

class StudyClassAIApp extends StatelessWidget {
  const StudyClassAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Class AI',
      theme: studyClassAITheme,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
