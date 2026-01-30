// lib/onboards.dart
// Barbershop AI Onboarding

import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/barber_theme.dart';

import 'root_shell.dart';
import 'src/app_assets.dart';
import 'src/constant.dart' show openPaywallFromUserAction, premiumListenable;

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pg = PageController();
  int _page = 0;

  final TextEditingController _nameCtl = TextEditingController();
  final FocusNode _nameFocus = FocusNode();

  bool _isOverlayLoading = false;
  bool _isFinalizing = false;

  late final AnimationController _overlayAnim =
  AnimationController(vsync: this, duration: const Duration(milliseconds: 260));
  late final AnimationController _dotAnim =
  AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))
    ..repeat();

  final List<_Question> _questions = [
    _Question(
      keyName: 'q_role',
      title: 'Who are you?',
      subtitle: 'We tailor the experience to your role.',
      options: [
        'Shop Owner',
        'Professional Barber',
        'Interior Designer',
        'Student / Enthusiast',
      ],
    ),
    _Question(
      keyName: 'q_goal',
      title: 'What is your main goal?',
      subtitle: 'This helps us prioritize the design.',
      options: [
        'Open a new shop',
        'Remodel existing space',
        'Create a home studio',
        'Visualize for clients',
      ],
    ),
    _Question(
      keyName: 'q_vibe',
      title: 'What\'s your preferred vibe?',
      subtitle: 'Select a baseline aesthetic.',
      options: [
        'Classic Heritage (Leather & Wood)',
        'Modern Minimal (Clean & Bright)',
        'Industrial (Concrete & Metal)',
        'Luxury Lounge (Dark & Gold)',
      ],
    ),
    _Question(
      keyName: 'q_budget',
      title: 'What is your budget range?',
      subtitle: 'We suggest finishes that fit.',
      options: [
        'DIY / Startup',
        'Standard Commercial',
        'Premium / High-End',
        'Unlimited / Luxury',
      ],
    ),
  ];

  final Map<String, int> _answers = {};

  int get _totalPages => 2 + _questions.length; // Intro + Name + Qs
  bool get _onLastQuestion => _page == (_totalPages - 1);

  @override
  void initState() {
    super.initState();
    _preloadName();
  }

  Future<void> _preloadName() async {
    final p = await SharedPreferences.getInstance();
    final existing = p.getString('user_name');
    if (existing != null && existing.isNotEmpty) {
      _nameCtl.text = existing;
    }
  }

  Future<void> _saveAll() async {
    final p = await SharedPreferences.getInstance();
    await p.setBool('onboarding_done', true);
    await p.setString('user_name', _nameCtl.text.trim());

    for (final q in _questions) {
      final idx = _answers[q.keyName] ?? -1;
      await p.setInt('${q.keyName}_index', idx);
    }
  }

  Future<void> _finish() async {
    setState(() {
      _isFinalizing = true;
      _overlayAnim.forward(from: 0);
    });

    final steps = [
      'Analyzing shop dimensions…',
      'Calibrating lighting presets…',
      'Preparing your design studio…',
    ];
    for (final _ in steps) {
      await Future.delayed(const Duration(milliseconds: 750));
    }

    await _saveAll();
    await openPaywallFromUserAction(context);

    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 420),
        pageBuilder: (_, __, ___) => const RootShell(),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(
          opacity: CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
          child: child,
        ),
      ),
          (_) => false,
    );
  }

  Future<void> _showInterstitial() async {
    setState(() {
      _isOverlayLoading = true;
      _overlayAnim.forward(from: 0);
    });
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _isOverlayLoading = false);
  }

  void _next() async {
    FocusScope.of(context).unfocus();

    if (_page == 1 && _nameCtl.text.trim().isEmpty) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter your name")));
       return;
    }
    if (_page >= 2 && _answers[_questions[_page-2].keyName] == null) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select an option")));
       return;
    }

    if (_onLastQuestion) {
      await _finish();
    } else {
      if (_page >= 1) await _showInterstitial();
      _pg.nextPage(duration: const Duration(milliseconds: 320), curve: Curves.easeOutCubic);
    }
  }

  void _prev() {
    if (_page == 0) return;
    _pg.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BarberTheme.bg0,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            // Background
            Positioned.fill(
              child: Container(
                color: BarberTheme.bg0,
              ),
            ),

            // Content
            SafeArea(
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(AppAssets.appIcon, width: 40, height: 40),
                        ),
                        const SizedBox(width: 12),
                        Text("Barbershop AI", style: BarberTheme.themeData.textTheme.titleLarge?.copyWith(color: BarberTheme.ink0)),
                      ],
                    ),
                  ),

                  // Progress
                  LinearProgressIndicator(
                     value: (_page + 1) / _totalPages,
                     backgroundColor: BarberTheme.surface,
                     color: BarberTheme.primary,
                  ),

                  Expanded(
                    child: PageView.builder(
                      controller: _pg,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (i) => setState(() => _page = i),
                      itemCount: _totalPages,
                      itemBuilder: (_, idx) {
                        if (idx == 0) return const _IntroPage();
                        if (idx == 1) return _NamePage(controller: _nameCtl, focusNode: _nameFocus);
                        return _QuestionPage(
                          question: _questions[idx - 2],
                          selectedIndex: _answers[_questions[idx - 2].keyName],
                          onSelect: (i) => setState(() => _answers[_questions[idx - 2].keyName] = i),
                        );
                      },
                    ),
                  ),

                  // Footer
                   Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        if (_page > 0)
                          IconButton.filledTonal(onPressed: _prev, icon: const Icon(Icons.arrow_back)),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: _next,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: BarberTheme.primary,
                            foregroundColor: BarberTheme.bg0,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          ),
                          child: Text(_onLastQuestion ? "Start Designing" : "Next"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

             if (_isOverlayLoading || _isFinalizing)
              Container(color: Colors.black87, child: const Center(child: CircularProgressIndicator(color: BarberTheme.primary))),
          ],
        ),
      ),
    );
  }
}

class _IntroPage extends StatelessWidget {
  const _IntroPage();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Welcome to Barbershop AI", textAlign: TextAlign.center, style: BarberTheme.themeData.textTheme.displayMedium),
          const SizedBox(height: 16),
          Text("Design your dream barbershop interior in seconds using professional AI models.", textAlign: TextAlign.center, style: BarberTheme.themeData.textTheme.bodyLarge),
        ],
      ),
    );
  }
}

class _NamePage extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  const _NamePage({required this.controller, required this.focusNode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("What's your name?", style: BarberTheme.themeData.textTheme.displaySmall),
           const SizedBox(height: 24),
           TextField(
             controller: controller,
             focusNode: focusNode,
             decoration: InputDecoration(
               hintText: "Enter your name",
               fillColor: BarberTheme.surface,
               filled: true,
               border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
             ),
           ),
        ],
      ),
    );
  }
}

class _QuestionPage extends StatelessWidget {
  final _Question question;
  final int? selectedIndex;
  final ValueChanged<int> onSelect;
  const _QuestionPage({required this.question, required this.selectedIndex, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(question.title, style: BarberTheme.themeData.textTheme.headlineMedium, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(question.subtitle ?? "", style: BarberTheme.themeData.textTheme.bodyMedium, textAlign: TextAlign.center),
          const SizedBox(height: 32),
          ...List.generate(question.options.length, (i) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () => onSelect(i),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: selectedIndex == i ? BarberTheme.primary.withOpacity(0.2) : BarberTheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: selectedIndex == i ? BarberTheme.primary : BarberTheme.line),
                ),
                child: Row(
                  children: [
                    Icon(selectedIndex == i ? Icons.radio_button_checked : Icons.radio_button_off, color: selectedIndex == i ? BarberTheme.primary : BarberTheme.muted),
                    const SizedBox(width: 16),
                    Text(question.options[i], style: BarberTheme.themeData.textTheme.bodyLarge),
                  ],
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }
}

class _Question {
  final String keyName;
  final String title;
  final String? subtitle;
  final List<String> options;
  const _Question({required this.keyName, required this.title, this.subtitle, required this.options});
}
