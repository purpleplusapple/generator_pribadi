// Beauty Salon AI Onboarding
import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/beauty_theme.dart';

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
      keyName: 'q_experience',
      title: 'Your role?',
      subtitle: 'We tailor the experience.',
      options: [
        'Salon Owner',
        'Interior Designer',
        'Beauty Professional',
        'Just Browsing',
      ],
    ),
    _Question(
      keyName: 'q_goal',
      title: 'Main goal?',
      subtitle: 'Help us prioritize.',
      options: [
        'Total Remodel',
        'Fresh Inspiration',
        'Visualizing Layouts',
        'Client Proposals',
      ],
    ),
    _Question(
      keyName: 'q_style',
      title: 'Preferred Aesthetic?',
      subtitle: 'Your starting point.',
      options: [
        'Luxury & Glam',
        'Minimalist & Clean',
        'Cozy & Warm',
        'Industrial & Edgy',
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
  }

  Future<void> _finish() async {
    setState(() {
      _isFinalizing = true;
      _overlayAnim.forward(from: 0);
    });

    await Future.delayed(const Duration(milliseconds: 1500));
    await _saveAll();
    await openPaywallFromUserAction(context);

    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const RootShell()),
      (_) => false,
    );
  }

  void _next() async {
    FocusScope.of(context).unfocus();
    if (_onLastQuestion) {
      await _finish();
    } else {
      _pg.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _prev() {
    if (_page == 0) return;
    FocusScope.of(context).unfocus();
    _pg.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _pg.dispose();
    _nameCtl.dispose();
    _nameFocus.dispose();
    _overlayAnim.dispose();
    _dotAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bg = BeautyTheme.bg0;
    const primary = BeautyTheme.primary;

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Text(
                        "Beauty Salon AI",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: BeautyTheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      if (_page > 0)
                        Text(
                          "Step ${_page + 1}/$_totalPages",
                          style: const TextStyle(color: BeautyTheme.muted),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pg,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (i) => setState(() => _page = i),
                    itemCount: _totalPages,
                    itemBuilder: (_, idx) {
                      if (idx == 0) return const _IntroPage();
                      if (idx == 1) return _NamePage(controller: _nameCtl);
                      return _QuestionPage(
                        question: _questions[idx - 2],
                        selectedIndex: _answers[_questions[idx - 2].keyName],
                        onSelect: (i) => setState(() => _answers[_questions[idx - 2].keyName] = i),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      if (_page > 0)
                        TextButton(
                          onPressed: _prev,
                          child: const Text('Back', style: TextStyle(color: BeautyTheme.muted)),
                        ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: _next,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        ),
                        child: Text(_onLastQuestion ? 'Get Started' : 'Next'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          if (_isFinalizing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}

class _IntroPage extends StatelessWidget {
  const _IntroPage();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: BeautyTheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.star_outline, size: 64, color: BeautyTheme.primary),
          ),
          const SizedBox(height: 24),
          const Text(
            "Welcome",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: BeautyTheme.ink0),
          ),
          const SizedBox(height: 16),
          const Text(
            "Design the salon of your dreams with AI. Upload a photo and apply luxury styles in seconds.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: BeautyTheme.ink1, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _NamePage extends StatelessWidget {
  final TextEditingController controller;
  const _NamePage({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("What should we call you?", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          TextField(
            controller: controller,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              hintText: "Your Name",
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
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
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(question.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text(question.subtitle!, style: const TextStyle(color: BeautyTheme.muted)),
          const SizedBox(height: 32),
          ...List.generate(question.options.length, (i) {
            final isSel = selectedIndex == i;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () => onSelect(i),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSel ? BeautyTheme.primary.withOpacity(0.1) : Colors.white,
                    border: Border.all(color: isSel ? BeautyTheme.primary : BeautyTheme.line),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Text(question.options[i], style: TextStyle(
                        fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                        color: isSel ? BeautyTheme.primary : BeautyTheme.ink1,
                      )),
                      const Spacer(),
                      if (isSel) const Icon(Icons.check, color: BeautyTheme.primary),
                    ],
                  ),
                ),
              ),
            );
          }),
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
