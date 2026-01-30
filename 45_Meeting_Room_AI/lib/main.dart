import 'package:flutter/material.dart';
import 'theme/meeting_room_theme.dart';
import 'services/preferences_service.dart';
import 'src/constant.dart';
import 'splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize preferences
  await PreferencesService.instance.init();

  // Initialize RevenueCat
  await initRevenueCat();

  runApp(const MeetingRoomAIApp());
}

class MeetingRoomAIApp extends StatelessWidget {
  const MeetingRoomAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meeting Room AI',
      theme: meetingRoomAITheme,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
