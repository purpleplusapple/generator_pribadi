import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hotel_room_ai/theme/hotel_room_ai_theme.dart';

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

  // ================== QUESTIONS (Hotel Room AI) ==================

  final List<_Question> _questions = [
    _Question(
      keyName: 'q_role',
      title: 'What describes you best?',
      subtitle: 'We tailor the design language to you.',
      options: [
        'Hotel Owner / Manager',
        'Interior Designer',
        'Hospitality Consultant',
        'Homeowner (Suite Style)',
      ],
    ),
    _Question(
      keyName: 'q_goal',
      title: 'What is your main goal?',
      subtitle: 'This helps us prioritize the output.',
      options: [
        'Renovate an existing room',
        'Visualize new concepts',
        'Refresh decor & lighting',
        'Maximize small spaces',
      ],
    ),
    _Question(
      keyName: 'q_room_type',
      title: 'What room type are you designing?',
      subtitle: 'Different rooms have different needs.',
      options: [
        'Standard / Deluxe Room',
        'Luxury Suite / Penthouse',
        'Lobby / Reception Area',
        'Bathroom / Spa',
      ],
    ),
    _Question(
      keyName: 'q_style',
      title: 'Which aesthetic fits your brand?',
      subtitle: 'We will use this as your baseline mood.',
      options: [
        'Modern Luxury (Sleek, Dark)',
        'Boutique Warmth (Linen, Wood)',
        'Coastal Resort (Light, Airy)',
        'Classic Heritage (Rich, Ornate)',
        'Industrial Chic (Raw, Edgy)',
      ],
    ),
    _Question(
      keyName: 'q_budget',
      title: 'What is the target tier?',
      subtitle: 'We suggest finishes that fit.',
      options: [
        'Budget / Economy',
        'Mid-Range Business',
        'Premium / Upscale',
        'Ultra-Luxury / 5-Star',
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

    final goalIdx = _answers['q_goal'];
    if (goalIdx != null) {
      await p.setString(
        'onboarding_intent',
        _questions.firstWhere((q) => q.keyName == 'q_goal').options[goalIdx],
      );
    }
  }

  Future<void> _finish() async {
    setState(() {
      _isFinalizing = true;
      _overlayAnim.forward(from: 0);
    });

    final steps = [
      'Calibrating design engine…',
      'Loading material textures…',
      'Opening your design studio…',
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
        _showRequiredSnackBar("Please enter your name to continue.");
      } else if (_page >= 2) {
        final q = _questions[_page - 2];
        _showRequiredSnackBar(
          "Please choose one answer for \"${q.title}\" before continuing.",
        );
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
        backgroundColor: HotelAIColors.error,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: Row(
          children: [
            const Icon(
              Icons.warning,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
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

  String _questionLabel() {
    if (_page < 2) return '';
    final qIndex = _page - 1;
    return 'Question $qIndex of ${_questions.length}';
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

    // Theme Colors
    const primary = HotelAIColors.primary;
    const bg = HotelAIColors.bg0;
    const ink = HotelAIColors.ink0;

    return Scaffold(
      backgroundColor: bg,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  // Top bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                            boxShadow: HotelAIShadows.soft,
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.asset(
                              AppAssets.appIcon,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "Hotel Room AI",
                          style: HotelAIText.h3.copyWith(
                            color: ink,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        ValueListenableBuilder<bool>(
                          valueListenable: premiumListenable,
                          builder: (_, isPro, __) {
                            final chipColor = isPro
                                ? HotelAIColors.accent.withValues(alpha: 0.1)
                                : HotelAIColors.ink0.withValues(alpha: 0.05);
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: chipColor,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isPro
                                        ? Icons.verified
                                        : Icons.person_outline,
                                    size: 14,
                                    color: isPro ? HotelAIColors.accent : HotelAIColors.muted,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    isPro ? "PREMIUM" : "FREE",
                                    style: TextStyle(
                                      color: isPro ? HotelAIColors.accent : HotelAIColors.muted,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // Progress bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 4,
                        backgroundColor: HotelAIColors.ink0.withValues(alpha: 0.05),
                        valueColor: const AlwaysStoppedAnimation(primary),
                      ),
                    ),
                  ),

                  // Step labels
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Column(
                      children: [
                        Text(
                          _stepLabel(),
                          style: HotelAIText.caption,
                        ),
                      ],
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

                  const SizedBox(height: 8),

                  // Bottom CTA
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                    child: Row(
                      children: [
                        if (_page > 0)
                          SizedBox(
                            width: 100,
                            child: OutlinedButton(
                              onPressed: _prev,
                              child: const Text("Back"),
                            ),
                          ),
                        if (_page > 0) const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _next,
                            child: Text(
                                _onLastQuestion ? "Start Designing" : "Next"
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Loading / Finalizing overlay
            if (_isOverlayLoading || _isFinalizing)
              AnimatedBuilder(
                animation: _overlayAnim,
                builder: (_, __) {
                  final msg = _isFinalizing
                      ? "Finalizing setup..."
                      : "Saving...";
                  return Opacity(
                    opacity: Curves.easeOut.transform(_overlayAnim.value),
                    child: Container(
                      color: HotelAIColors.bg1.withValues(alpha: 0.9),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CupertinoActivityIndicator(radius: 14),
                            const SizedBox(height: 16),
                            Text(
                              msg,
                              style: HotelAIText.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

// ================== MODELS & UI WIDGETS ==================

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
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: HotelAIColors.bg1,
                borderRadius: BorderRadius.circular(24),
                boxShadow: HotelAIShadows.soft,
              ),
              child: Column(
                children: [
                  Text(
                    "Welcome to Hotel Room AI",
                    textAlign: TextAlign.center,
                    style: HotelAIText.h2,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Transform any room into a luxury hotel suite using professional AI design models.",
                    textAlign: TextAlign.center,
                    style: HotelAIText.body.copyWith(
                      color: HotelAIColors.muted,
                    ),
                  ),
                ],
              ),
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
  const _NamePage({
    required this.controller,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Let's personalize your studio",
              textAlign: TextAlign.center,
              style: HotelAIText.h2,
            ),
            const SizedBox(height: 8),
            Text(
              "How should we address you?",
              textAlign: TextAlign.center,
              style: HotelAIText.body.copyWith(color: HotelAIColors.muted),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: controller,
              focusNode: focusNode,
              textAlign: TextAlign.center,
              style: HotelAIText.h3,
              decoration: InputDecoration(
                hintText: "Enter your name",
                hintStyle: TextStyle(color: HotelAIColors.muted.withValues(alpha: 0.5)),
                fillColor: HotelAIColors.bg1,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
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

  const _QuestionPage({
    required this.question,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            Text(
              question.title,
              textAlign: TextAlign.center,
              style: HotelAIText.h2,
            ),
            if (question.subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                question.subtitle!,
                textAlign: TextAlign.center,
                style: HotelAIText.body.copyWith(color: HotelAIColors.muted),
              ),
            ],
            const SizedBox(height: 32),
            ...List.generate(
              question.options.length,
                  (i) {
                final isSel = selectedIndex == i;
                final txt = question.options[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () => onSelect(i),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: isSel ? HotelAIColors.primary : HotelAIColors.bg1,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSel ? HotelAIColors.primary : HotelAIColors.line,
                        ),
                        boxShadow: isSel ? HotelAIShadows.floating : HotelAIShadows.soft,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              txt,
                              style: HotelAIText.bodyMedium.copyWith(
                                color: isSel ? Colors.white : HotelAIColors.ink0,
                              ),
                            ),
                          ),
                          if (isSel)
                            const Icon(Icons.check, color: Colors.white, size: 20),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
