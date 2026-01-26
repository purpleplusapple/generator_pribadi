// Retail Store Boutique AI Onboarding
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:retail_store_boutique_ai/theme/boutique_theme.dart';

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

  // ================== QUESTIONS (Retail Boutique AI) ==================

  final List<_Question> _questions = [
    _Question(
      keyName: 'q_store_type',
      title: 'What type of store are you designing?',
      subtitle: 'We customize displays for your products.',
      options: [
        'Fashion Boutique (Clothing)',
        'Cosmetics / Beauty Store',
        'Luxury Accessories / Jewelry',
        'Concept Store / Lifestyle',
        'Pop-up Store',
      ],
    ),
    _Question(
      keyName: 'q_goal',
      title: 'What is your primary goal?',
      subtitle: 'Focus the AI on what matters most.',
      options: [
        'Complete Store Makeover',
        'Merchandising & Display Update',
        'Window Display Design',
        'Lighting & Ambience Upgrade',
      ],
    ),
    _Question(
      keyName: 'q_vibe',
      title: 'Choose your desired aesthetic',
      subtitle: 'Select the mood for your boutique.',
      options: [
        'Dark Luxury (Black & Gold)',
        'Modern Minimalist (Clean)',
        'Industrial Chic (Raw)',
        'Soft Pastel (Dreamy)',
        'Avant-Garde (Bold)',
      ],
    ),
    _Question(
      keyName: 'q_audience',
      title: 'Who is your target customer?',
      subtitle: 'Align the design with your clientele.',
      options: [
        'High-End Luxury Shoppers',
        'Trend-Conscious Gen Z',
        'Professional / Modern',
        'Eco-Conscious / Natural',
      ],
    ),
  ];

  final Map<String, int> _answers = {};

  int get _totalPages => 2 + _questions.length; // Intro + Name + Qs
  bool get _onLastQuestion => _page == (_totalPages - 1);

  @override
  void initState() {
    super.initState();
    _nameFocus.addListener(() {
      if (_nameFocus.hasFocus) HapticFeedback.selectionClick();
    });
    _nameCtl.addListener(() {
      if (_nameCtl.text.length == 1 || _nameCtl.text.length % 5 == 0) {
        HapticFeedback.selectionClick();
      }
      setState(() {});
    });
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
      'Calibrating lighting model…',
      'Selecting premium materials…',
      'Finalizing boutique snapshot…',
    ];
    for (final _ in steps) {
      await Future.delayed(const Duration(milliseconds: 750));
    }

    await _saveAll();
    await openPaywallFromUserAction(context);

    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
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

    final canContinue = _canContinueForPage(_page);
    if (!canContinue) {
      HapticFeedback.heavyImpact();
      if (_page == 1) {
        _showRequiredSnackBar("Please enter your brand name.");
      } else if (_page >= 2) {
        _showRequiredSnackBar("Please select an option.");
      }
      return;
    }

    HapticFeedback.lightImpact();

    if (_onLastQuestion) {
      await _showInterstitial(550, 900);
      await _finish();
    } else {
      final shouldLoad = _page >= 1;
      if (shouldLoad) await _showInterstitial();
      _pg.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _showRequiredSnackBar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: BoutiqueColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Text(
          message,
          style: BoutiqueText.body.copyWith(color: BoutiqueColors.ink0),
        ),
      ),
    );
  }

  void _prev() {
    if (_page == 0) return;
    HapticFeedback.selectionClick();
    FocusScope.of(context).unfocus();
    _pg.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
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
    final progress = (_page + 1) / _totalPages;

    return Scaffold(
      backgroundColor: BoutiqueColors.bg0,
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Container(decoration: const BoxDecoration(gradient: BoutiqueGradients.background)),
          ),

          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    children: [
                       Image.asset(AppAssets.appIcon, width: 32, height: 32),
                       const SizedBox(width: 12),
                       Text("RETAIL BOUTIQUE AI", style: BoutiqueText.h3.copyWith(fontSize: 14, letterSpacing: 1.5)),
                    ],
                  ),
                ),

                // Progress
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 2,
                    backgroundColor: BoutiqueColors.surface,
                    valueColor: AlwaysStoppedAnimation(BoutiqueColors.primary),
                  ),
                ),

                // Content
                Expanded(
                  child: PageView.builder(
                    controller: _pg,
                    physics: const ClampingScrollPhysics(),
                    onPageChanged: (i) {
                      FocusScope.of(context).unfocus();
                      setState(() => _page = i);
                    },
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

                // Footer CTA
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      if (_page > 0)
                        IconButton(onPressed: _prev, icon: const Icon(Icons.arrow_back, color: BoutiqueColors.muted)),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: _next,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: BoutiqueColors.primary,
                          foregroundColor: BoutiqueColors.bg0,
                        ),
                        child: Text(_onLastQuestion ? "COMPLETE PROFILE" : "CONTINUE"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          if (_isOverlayLoading || _isFinalizing)
             Container(
               color: Colors.black54,
               child: const Center(child: CircularProgressIndicator()),
             )
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
  const _Question({
    required this.keyName,
    required this.title,
    this.subtitle,
    required this.options,
  });
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
          Text("Welcome to\nRetail Boutique AI", textAlign: TextAlign.center, style: BoutiqueText.h1),
          const SizedBox(height: 16),
          Text("Transform your store into a high-end editorial space. Visual merchandising and layout optimization.", textAlign: TextAlign.center, style: BoutiqueText.body.copyWith(color: BoutiqueColors.muted)),
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
          Text("What is your brand name?", style: BoutiqueText.h2),
          const SizedBox(height: 24),
          TextField(
            controller: controller,
            focusNode: focusNode,
            style: BoutiqueText.h3,
            decoration: InputDecoration(
              hintText: "Enter brand name",
              filled: true,
              fillColor: BoutiqueColors.surface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
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
        Text(question.title, style: BoutiqueText.h2),
        if (question.subtitle != null) ...[
          const SizedBox(height: 8),
          Text(question.subtitle!, style: BoutiqueText.body.copyWith(color: BoutiqueColors.muted)),
        ],
        const SizedBox(height: 32),
        ...List.generate(question.options.length, (i) {
          final isSel = selectedIndex == i;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () => onSelect(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSel ? BoutiqueColors.primary.withValues(alpha: 0.2) : BoutiqueColors.surface,
                  border: Border.all(color: isSel ? BoutiqueColors.primary : Colors.transparent),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(child: Text(question.options[i], style: BoutiqueText.bodyMedium.copyWith(color: isSel ? BoutiqueColors.primary : BoutiqueColors.ink1))),
                    if (isSel) const Icon(Icons.check, color: BoutiqueColors.primary),
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
