// lib/onboards.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:camper_van_interior_ai/theme/camper_tokens.dart';
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
  final TextEditingController _nameCtl = TextEditingController();

  final List<_Question> _questions = [
    _Question(
      keyName: 'q_experience',
      title: 'What represents you?',
      subtitle: 'Tailoring the experience to your skills.',
      options: ['DIY First-Timer', 'Van Life Enthusiast', 'Professional Builder', 'Dreamer / Planner'],
    ),
    _Question(
      keyName: 'q_vehicle',
      title: 'What is your base vehicle?',
      subtitle: 'We optimize layouts for space.',
      options: ['Sprinter / Transit (High Roof)', 'Promaster / Boxer', 'Small Van (Metris/Connect)', 'Skoolie / Box Truck'],
    ),
    _Question(
      keyName: 'q_goal',
      title: 'Primary use of the van?',
      subtitle: 'Function follows form.',
      options: ['Full-time Living', 'Weekend Adventure', 'Mobile Office', 'Family Travels'],
    ),
  ];

  final Map<String, int> _answers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CamperTokens.bg0,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
               padding: const EdgeInsets.all(24),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   const Text("Camper Van AI", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: CamperTokens.ink0)),
                   Text("Step ${_page + 1}/${_questions.length + 2}", style: const TextStyle(color: CamperTokens.muted)),
                 ],
               ),
            ),

            // Content
            Expanded(
              child: PageView(
                controller: _pg,
                physics: const NeverScrollableScrollPhysics(), // Force buttons
                children: [
                  _IntroPage(onNext: _next),
                  _NamePage(controller: _nameCtl, onNext: _next),
                  ..._questions.map((q) => _QuestionPage(
                    question: q,
                    onSelect: (idx) {
                      setState(() => _answers[q.keyName] = idx);
                      _next();
                    }
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _next() async {
    if (_page < _questions.length + 1) {
      _pg.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      setState(() => _page++);
    } else {
       // Finish
       final prefs = await SharedPreferences.getInstance();
       await prefs.setBool('onboarding_done', true);
       if (mounted) Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const RootShell()));
    }
  }
}

class _Question {
  final String keyName;
  final String title;
  final String subtitle;
  final List<String> options;
  const _Question({required this.keyName, required this.title, required this.subtitle, required this.options});
}

class _IntroPage extends StatelessWidget {
  final VoidCallback onNext;
  const _IntroPage({required this.onNext});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(AppAssets.appIcon, width: 120, height: 120),
        const SizedBox(height: 32),
        Text("Welcome to Van Studio", style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: CamperTokens.ink0)),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text("Design your dream camper van conversion with AI assistance.", textAlign: TextAlign.center, style: TextStyle(color: CamperTokens.ink1)),
        ),
        const SizedBox(height: 48),
        ElevatedButton(
          onPressed: onNext,
          style: ElevatedButton.styleFrom(
             backgroundColor: CamperTokens.primary,
             foregroundColor: Colors.black,
             padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16)
          ),
          child: const Text("Get Started"),
        )
      ],
    );
  }
}

class _NamePage extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onNext;
  const _NamePage({required this.controller, required this.onNext});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("What should we call you?", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: CamperTokens.ink0)),
          const SizedBox(height: 24),
          TextField(
            controller: controller,
            style: const TextStyle(color: CamperTokens.ink0),
            decoration: InputDecoration(
              filled: true,
              fillColor: CamperTokens.surface,
              hintText: "Your Name",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(onPressed: onNext, style: ElevatedButton.styleFrom(backgroundColor: CamperTokens.primary, foregroundColor: Colors.black), child: const Text("Continue"))
        ],
      ),
    );
  }
}

class _QuestionPage extends StatelessWidget {
  final _Question question;
  final Function(int) onSelect;
  const _QuestionPage({required this.question, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
         Text(question.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: CamperTokens.ink0), textAlign: TextAlign.center),
         const SizedBox(height: 8),
         Text(question.subtitle, style: const TextStyle(color: CamperTokens.muted), textAlign: TextAlign.center),
         const SizedBox(height: 32),
         ...question.options.asMap().entries.map((e) => Padding(
           padding: const EdgeInsets.only(bottom: 12),
           child: InkWell(
             onTap: () => onSelect(e.key),
             child: Container(
               padding: const EdgeInsets.all(20),
               decoration: BoxDecoration(
                 color: CamperTokens.surface,
                 borderRadius: BorderRadius.circular(16),
                 border: Border.all(color: CamperTokens.line),
               ),
               child: Text(e.value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: CamperTokens.ink0), textAlign: TextAlign.center),
             ),
           ),
         ))
      ],
    );
  }
}
