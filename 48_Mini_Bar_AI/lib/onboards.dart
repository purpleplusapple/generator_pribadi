// lib/onboards.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/mini_bar_theme.dart';
import 'theme/design_tokens.dart';
import 'root_shell.dart';
import 'src/app_assets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pg = PageController();
  int _page = 0;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What kind of host are you?',
      'options': ['Casual Mixer', 'Cocktail Enthusiast', 'Wine Collector', 'Party Thrower'],
    },
    {
      'question': 'What space are we working with?',
      'options': ['Living Room Corner', 'Dedicated Room', 'Kitchen Nook', 'Outdoor Patio'],
    },
    {
      'question': 'Pick your vibe',
      'options': ['Speakeasy Dark', 'Modern Bright', 'Tropical Resort', 'Classic Pub'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MiniBarColors.bg0,
      body: Stack(
        children: [
           Positioned.fill(
             child: Opacity(opacity: 0.1, child: SvgPicture.asset(AppAssets.appIcon, fit: BoxFit.cover)),
           ),
           SafeArea(
             child: Column(
               children: [
                 const SizedBox(height: 24),
                 LinearProgressIndicator(
                   value: (_page + 1) / (_questions.length + 1),
                   color: MiniBarColors.primary,
                   backgroundColor: MiniBarColors.surface
                 ),
                 Expanded(
                   child: PageView(
                     controller: _pg,
                     physics: const NeverScrollableScrollPhysics(),
                     children: [
                       _buildIntro(),
                       ..._questions.map((q) => _buildQuestion(q)),
                     ],
                   ),
                 ),
               ],
             ),
           ),
        ],
      ),
    );
  }

  Widget _buildIntro() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Welcome to the Lounge', style: MiniBarText.h1, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Text('Let\'s design a bar that fits your style and space.', style: MiniBarText.body, textAlign: TextAlign.center),
          const SizedBox(height: 48),
          ElevatedButton(
            onPressed: () {
              setState(() => _page++);
              _pg.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
            },
            child: const Text('Get Started'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestion(Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(data['question'], style: MiniBarText.h2, textAlign: TextAlign.center),
          const SizedBox(height: 32),
          ...data['options'].map<Widget>((opt) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: OutlinedButton(
              onPressed: () async {
                if (_page < _questions.length) {
                  setState(() => _page++);
                  _pg.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
                } else {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('onboarding_done', true);
                  if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const RootShell()));
                }
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(opt),
            ),
          )).toList(),
        ],
      ),
    );
  }
}
