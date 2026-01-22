import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/app_theme.dart';

import 'root_shell.dart';
// import 'src/app_assets.dart'; // Removing asset dependency for now
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
      keyName: 'q_type',
      title: 'What space are we styling?',
      subtitle: 'We tailor the vibe to your structure.',
      options: [
        'Urban Rooftop Deck',
        'Apartment Balcony',
        'Hotel Sky Terrace',
        'Backyard Patio',
      ],
    ),
    _Question(
      keyName: 'q_goal',
      title: 'What is the main purpose?',
      subtitle: 'How will you use the space?',
      options: [
        'Lounge & Chill',
        'Parties & Events',
        'Romantic Dining',
        'Green Garden Oasis',
      ],
    ),
    _Question(
      keyName: 'q_vibe',
      title: 'Choose your aesthetic',
      subtitle: 'Select a base mood.',
      options: [
        'Midnight Luxury (Dark & Gold)',
        'Tropical Night (Green & Warm)',
        'Neon Cyber (Cyberpunk)',
        'Minimal Zen (Stone & Wood)',
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
    final canContinue = _canContinueForPage(_page);
    if (!canContinue) return; // Add shake/toast here if needed

    if (_onLastQuestion) {
      await _finish();
    } else {
      _pg.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  void _prev() {
    if (_page == 0) return;
    FocusScope.of(context).unfocus();
    _pg.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  bool _canContinueForPage(int pageIndex) {
    if (pageIndex == 0) return true;
    if (pageIndex == 1) return _nameCtl.text.trim().isNotEmpty;
    final q = _questions[pageIndex - 2];
    return _answers[q.keyName] != null;
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
    return Scaffold(
      backgroundColor: DesignTokens.bg0,
      body: Stack(
        children: [
          Positioned.fill(child: Container(color: DesignTokens.bg0)),
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.nightlife, color: DesignTokens.primary, size: 28),
                      const SizedBox(width: 8),
                      Text("Rooftop Lounge AI", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontFamily: 'DM Serif Display', color: DesignTokens.ink0)),
                    ],
                  ),
                ),
                // Progress
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: LinearProgressIndicator(
                    value: (_page + 1) / _totalPages,
                    backgroundColor: DesignTokens.surface,
                    valueColor: const AlwaysStoppedAnimation(DesignTokens.primary),
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
                      final q = _questions[idx - 2];
                      return _QuestionPage(
                        question: q,
                        selectedIndex: _answers[q.keyName],
                        onSelect: (i) => setState(() => _answers[q.keyName] = i),
                      );
                    },
                  ),
                ),
                // Footer
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      if (_page > 0)
                        TextButton(onPressed: _prev, child: const Text('Back', style: TextStyle(color: DesignTokens.ink1))),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: _next,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: DesignTokens.primary,
                          foregroundColor: DesignTokens.bg0,
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
            Positioned.fill(
              child: Container(
                color: Colors.black87,
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: DesignTokens.primary),
                      SizedBox(height: 16),
                      Text('Preparing your lounge...', style: TextStyle(color: DesignTokens.ink0)),
                    ],
                  ),
                ),
              ),
            ),
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

class _IntroPage extends StatelessWidget {
  const _IntroPage();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.deck, size: 80, color: DesignTokens.primary),
          const SizedBox(height: 24),
          Text("Transform Your Rooftop", style: Theme.of(context).textTheme.displaySmall?.copyWith(fontFamily: 'DM Serif Display', color: DesignTokens.ink0), textAlign: TextAlign.center),
          const SizedBox(height: 16),
          const Text("Turn any outdoor space into a luxury lounge with AI. Upload a photo and choose your vibe.", style: TextStyle(color: DesignTokens.ink1, fontSize: 16), textAlign: TextAlign.center),
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
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("What's your name?", style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: DesignTokens.ink0)),
          const SizedBox(height: 24),
          TextField(
            controller: controller,
            style: const TextStyle(color: DesignTokens.ink0),
            decoration: InputDecoration(
              hintText: 'Enter name',
              hintStyle: TextStyle(color: DesignTokens.ink1.withOpacity(0.5)),
              filled: true,
              fillColor: DesignTokens.surface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
          Text(question.title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: DesignTokens.ink0), textAlign: TextAlign.center),
          if (question.subtitle != null) ...[
            const SizedBox(height: 8),
            Text(question.subtitle!, style: const TextStyle(color: DesignTokens.ink1), textAlign: TextAlign.center),
          ],
          const SizedBox(height: 24),
          ...List.generate(question.options.length, (i) {
             final isSel = i == selectedIndex;
             return Padding(
               padding: const EdgeInsets.only(bottom: 12),
               child: InkWell(
                 onTap: () => onSelect(i),
                 child: Container(
                   padding: const EdgeInsets.all(16),
                   decoration: BoxDecoration(
                     color: isSel ? DesignTokens.primary.withOpacity(0.2) : DesignTokens.surface,
                     border: Border.all(color: isSel ? DesignTokens.primary : DesignTokens.line),
                     borderRadius: BorderRadius.circular(12),
                   ),
                   child: Row(
                     children: [
                       Expanded(child: Text(question.options[i], style: TextStyle(color: isSel ? DesignTokens.primary : DesignTokens.ink0, fontWeight: FontWeight.bold))),
                       if (isSel) const Icon(Icons.check, color: DesignTokens.primary),
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
