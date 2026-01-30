import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_class_ai/theme/app_theme.dart'; // Updated import

import 'root_shell.dart';
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

  // ================== QUESTIONS (Study Class AI) ==================

  final List<_Question> _questions = [
    _Question(
      keyName: 'q_role',
      title: 'What best describes you?',
      subtitle: 'We tailor the study space to your needs.',
      options: [
        'Student – High School/Uni',
        'Professional – Home Office',
        'Teacher – Classroom Setup',
        'Lifelong Learner – Hobby Desk',
      ],
    ),
    _Question(
      keyName: 'q_goal',
      title: 'What is your main goal?',
      subtitle: 'Prioritizing what matters most.',
      options: [
        'Maximize focus & productivity',
        'Create a cozy reading nook',
        'Organize books & supplies',
        'Professional video call backdrop',
      ],
    ),
    _Question(
      keyName: 'q_space',
      title: 'What space are you transforming?',
      subtitle: 'From small corners to full rooms.',
      options: [
        'Bedroom Corner',
        'Dedicated Home Office',
        'Dorm Room',
        'Classroom / Shared Space',
      ],
    ),
    _Question(
      keyName: 'q_style',
      title: 'Which vibe do you prefer?',
      subtitle: 'This sets your baseline aesthetic.',
      options: [
        'Dark Academia (Moody, Vintage)',
        'Modern Minimal (Clean, White)',
        'Scandinavian (Warm Wood, Bright)',
        'Tech Pro (Dark, RGB, Screen-heavy)',
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
      final text =
      (idx >= 0 && idx < q.options.length) ? q.options[idx] : '';
      await p.setString(q.keyName, text);
    }
  }

  Future<void> _finish() async {
    setState(() {
      _isFinalizing = true;
      _overlayAnim.forward(from: 0);
    });

    final steps = [
      'Analyzing your study habits...',
      'Optimizing lighting & ergonomics...',
      'Preparing your focus zone...',
    ];
    for (final _ in steps) {
      await Future.delayed(const Duration(milliseconds: 750));
    }

    await _saveAll();

    // Soft upsell
    if (mounted) await openPaywallFromUserAction(context);

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

  Future<void> _showInterstitial([int minMs = 450, int maxMs = 900]) async {
    setState(() {
      _isOverlayLoading = true;
      _overlayAnim.forward(from: 0);
    });
    final ms = math.Random().nextInt(maxMs - minMs + 1) + minMs;
    await Future.delayed(Duration(milliseconds: ms));
    if (!mounted) return;
    setState(() => _isOverlayLoading = false);
  }

  void _next() async {
    FocusScope.of(context).unfocus();

    if (_page == 1 && _nameCtl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter your name to continue.")));
      return;
    }
    if (_page >= 2) {
      final q = _questions[_page - 2];
      if (_answers[q.keyName] == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select an option.")));
        return;
      }
    }

    if (_onLastQuestion) {
      await _showInterstitial(550, 900);
      await _finish();
    } else {
      if (_page >= 1) await _showInterstitial();
      _pg.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _prev() {
    if (_page == 0) return;
    FocusScope.of(context).unfocus();
    _pg.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  String _stepLabel() {
    final step = _page + 1;
    return 'Step $step of $_totalPages';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StudyAIColors.bg0,
      body: Stack(
        children: [
          // Background
          Positioned.fill(
             child: Container(
               decoration: const BoxDecoration(
                 gradient: LinearGradient(
                   begin: Alignment.topLeft,
                   end: Alignment.bottomRight,
                   colors: [StudyAIColors.bg0, StudyAIColors.bg1],
                 ),
               ),
             ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.school, color: StudyAIColors.primary),
                      const SizedBox(width: 8),
                      Text("Study Class AI", style: StudyAIText.h3),
                      const Spacer(),
                      _buildPremiumBadge(),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: PageView.builder(
                    controller: _pg,
                    physics: const NeverScrollableScrollPhysics(), // Force buttons
                    itemCount: _totalPages,
                    itemBuilder: (_, idx) {
                      if (idx == 0) return const _IntroPage();
                      if (idx == 1) return _NamePage(controller: _nameCtl, focusNode: _nameFocus);
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
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      if (_page > 0)
                        TextButton(onPressed: _prev, child: const Text("Back")),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: _next,
                        child: Text(_onLastQuestion ? "Start Designing" : "Next"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Loading Overlay
           if (_isOverlayLoading || _isFinalizing)
              Positioned.fill(
                child: Container(
                  color: Colors.black54,
                  child: const Center(child: CircularProgressIndicator(color: StudyAIColors.primary)),
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildPremiumBadge() {
    return ValueListenableBuilder<bool>(
      valueListenable: premiumListenable,
      builder: (_, isPro, __) {
        if (!isPro) return const SizedBox.shrink();
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: StudyAIColors.primary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: StudyAIColors.primary),
          ),
          child: Text("PREMIUM", style: StudyAIText.label.copyWith(color: StudyAIColors.primary)),
        );
      },
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
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.menu_book, size: 80, color: StudyAIColors.primary),
          const SizedBox(height: 24),
          Text("Welcome to Study Class AI", textAlign: TextAlign.center, style: StudyAIText.h1),
          const SizedBox(height: 16),
          Text(
            "Transform your desk, dorm, or classroom into a premium study space using AI.",
            textAlign: TextAlign.center,
            style: StudyAIText.body,
          ),
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
          Text("What's your name?", style: StudyAIText.h2),
          const SizedBox(height: 24),
          TextField(
            controller: controller,
            focusNode: focusNode,
            textAlign: TextAlign.center,
            style: StudyAIText.h3,
            decoration: const InputDecoration(
              hintText: "Enter Name",
              border: OutlineInputBorder(),
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
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 40),
        Text(question.title, textAlign: TextAlign.center, style: StudyAIText.h2),
        if (question.subtitle != null) ...[
          const SizedBox(height: 8),
          Text(question.subtitle!, textAlign: TextAlign.center, style: StudyAIText.bodySmall),
        ],
        const SizedBox(height: 32),
        ...List.generate(question.options.length, (i) {
          final isSel = selectedIndex == i;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () => onSelect(i),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSel ? StudyAIColors.primary.withValues(alpha: 0.15) : StudyAIColors.surface,
                  border: Border.all(color: isSel ? StudyAIColors.primary : StudyAIColors.line),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSel ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                      color: isSel ? StudyAIColors.primary : StudyAIColors.muted,
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(question.options[i], style: StudyAIText.bodyMedium)),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
