import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:balcony_terrace_ai/theme/terrace_theme.dart';
import 'package:balcony_terrace_ai/theme/design_tokens.dart';

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

  // ================== QUESTIONS (Terrace AI) ==================

  final List<_Question> _questions = [
    _Question(
      keyName: 'q_space',
      title: 'What space are you styling?',
      subtitle: 'We tailor the design to your layout.',
      options: [
        'Apartment Balcony',
        'Rooftop Terrace',
        'Backyard Patio',
        'Small Porch / Entryway',
      ],
    ),
    _Question(
      keyName: 'q_goal',
      title: 'What is your main goal?',
      subtitle: 'This helps us prioritize elements.',
      options: [
        'Create a Cozy Lounge',
        'Green Oasis (Many Plants)',
        'Dining & Social Space',
        'Private Retreat',
      ],
    ),
    _Question(
      keyName: 'q_mood',
      title: 'Which vibe do you prefer?',
      subtitle: 'We will use this as your baseline.',
      options: [
        'Warm & Rustic (Lanterns)',
        'Modern Minimal (Sleek)',
        'Tropical Jungle (Lush)',
        'Industrial Urban (Edgy)',
      ],
    ),
    _Question(
      keyName: 'q_budget',
      title: 'What is your project budget?',
      subtitle: 'We suggest materials that fit.',
      options: [
        'Budget / DIY Friendly',
        'Moderate Makeover',
        'Premium Renovation',
        'Luxury High-End',
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
      'Analyzing your space type…',
      'Selecting night garden elements…',
      'Preparing your terrace workspace…',
    ];
    for (final _ in steps) {
      await Future.delayed(const Duration(milliseconds: 750));
    }

    await _saveAll();

    // Soft upsell
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
      _showRequiredSnackBar("Please complete this step to continue.");
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
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _showRequiredSnackBar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: DesignTokens.surface,
        content: Text(message, style: const TextStyle(color: DesignTokens.ink0)),
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
    if (pageIndex == 0) return true; // Intro
    if (pageIndex == 1) {
      return _nameCtl.text.trim().isNotEmpty;
    }
    final q = _questions[pageIndex - 2];
    return _answers[q.keyName] != null;
  }

  String _stepLabel() {
    final step = _page + 1;
    return 'Step $step of $_totalPages';
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
      backgroundColor: DesignTokens.bg0,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            // Background
            Positioned.fill(
              child: AnimatedBackdrop(ctrl: _dotAnim),
            ),

            SafeArea(
              child: Column(
                children: [
                  // Top bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                    child: Row(
                      children: [
                        const Icon(Icons.deck, color: DesignTokens.primary, size: 28),
                        const SizedBox(width: 8),
                        const Text(
                          "Balcony Terrace AI",
                          style: TextStyle(
                            color: DesignTokens.ink0,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          ),
                        ),
                        const Spacer(),
                        ValueListenableBuilder<bool>(
                          valueListenable: premiumListenable,
                          builder: (_, isPro, __) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: isPro ? DesignTokens.accent.withOpacity(0.2) : Colors.white10,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                isPro ? "PREMIUM" : "FREE",
                                style: TextStyle(
                                  color: isPro ? DesignTokens.accent : Colors.white70,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // Progress bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor: Colors.white10,
                        valueColor: const AlwaysStoppedAnimation(DesignTokens.primary),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      _stepLabel(),
                      style: const TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ),

                  // Pages
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
                        if (idx == 1) {
                          return _NamePage(
                            controller: _nameCtl,
                            focusNode: _nameFocus,
                          );
                        }
                        final q = _questions[idx - 2];
                        final selectedIdx = _answers[q.keyName];
                        return _QuestionPage(
                          question: q,
                          selectedIndex: selectedIdx,
                          onSelect: (int i) {
                            HapticFeedback.selectionClick();
                            setState(() => _answers[q.keyName] = i);
                          },
                        );
                      },
                    ),
                  ),

                  // Bottom CTA
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Row(
                      children: [
                        if (_page > 0)
                          SizedBox(
                            width: 110,
                            height: 46,
                            child: GlassButton(
                              label: "Back",
                              icon: Icons.arrow_back,
                              onTap: _prev,
                            ),
                          ),
                        if (_page > 0) const SizedBox(width: 10),
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: GlassButton(
                              primary: true,
                              icon: _onLastQuestion ? Icons.lock : Icons.arrow_forward,
                              label: _onLastQuestion ? "Start designing" : "Next",
                              onTap: _next,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            if (_isOverlayLoading || _isFinalizing)
              Positioned.fill(
                child: Container(
                  color: Colors.black54,
                  child: const Center(child: CircularProgressIndicator(color: DesignTokens.primary)),
                ),
              ),
          ],
        ),
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.deck, size: 80, color: DesignTokens.primary),
            SizedBox(height: 20),
            Text(
              "Balcony Terrace AI",
              textAlign: TextAlign.center,
              style: TextStyle(color: DesignTokens.ink0, fontSize: 26, fontWeight: FontWeight.w900),
            ),
            SizedBox(height: 8),
            Text(
              "Upload a photo of your outdoor space and let AI transform it into a cozy night oasis.",
              textAlign: TextAlign.center,
              style: TextStyle(color: DesignTokens.ink1, height: 1.35),
            ),
          ],
        ),
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Let's personalize your terrace",
              textAlign: TextAlign.center,
              style: TextStyle(color: DesignTokens.ink0, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: controller,
              focusNode: focusNode,
              style: const TextStyle(color: DesignTokens.ink0),
              decoration: InputDecoration(
                hintText: "Enter your name",
                hintStyle: const TextStyle(color: DesignTokens.muted),
                filled: true,
                fillColor: DesignTokens.surface2,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ],
        ),
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(question.title, textAlign: TextAlign.center, style: const TextStyle(color: DesignTokens.ink0, fontSize: 22, fontWeight: FontWeight.bold)),
            if (question.subtitle != null) ...[
               const SizedBox(height: 8),
               Text(question.subtitle!, textAlign: TextAlign.center, style: const TextStyle(color: DesignTokens.muted)),
            ],
            const SizedBox(height: 18),
            ...List.generate(question.options.length, (i) {
              final isSel = selectedIndex == i;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  onTap: () => onSelect(i),
                  tileColor: isSel ? DesignTokens.primary.withOpacity(0.1) : DesignTokens.surface2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(color: isSel ? DesignTokens.primary : Colors.transparent),
                  ),
                  title: Text(question.options[i], style: TextStyle(color: isSel ? DesignTokens.primary : DesignTokens.ink0, fontWeight: FontWeight.bold)),
                  leading: Icon(isSel ? Icons.radio_button_checked : Icons.radio_button_unchecked, color: isSel ? DesignTokens.primary : DesignTokens.muted),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class AnimatedBackdrop extends StatelessWidget {
  final AnimationController ctrl;
  const AnimatedBackdrop({super.key, required this.ctrl});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [DesignTokens.bg0, DesignTokens.bg1],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}

class GlassButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool primary;
  final VoidCallback? onTap;
  const GlassButton({super.key, required this.label, required this.icon, this.primary = false, this.onTap});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: primary ? DesignTokens.primary : DesignTokens.surface2,
        foregroundColor: primary ? DesignTokens.bg0 : DesignTokens.ink0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}
