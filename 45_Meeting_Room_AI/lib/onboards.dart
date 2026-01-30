import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meeting_room_ai/theme/meeting_room_theme.dart';

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

  // ================== QUESTIONS (Meeting Room AI) ==================

  final List<_Question> _questions = [
    _Question(
      keyName: 'q_experience',
      title: 'What describes your shoe situation?',
      subtitle: 'We tailor the space to your needs.',
      options: [
        'Homeowner – planning a remodel',
        'Renter – looking for inspiration',
        'Designer – creating for clients',
        'Builder – designing new homes',
      ],
    ),
    _Question(
      keyName: 'q_goal',
      title: 'What is your main goal?',
      subtitle: 'This helps us prioritize the design.',
      options: [
        'Create an efficient home shoe room',
        'Design a multi-purpose closet space',
        'Maximize storage and organization',
        'Visualize a premium shoe area',
      ],
    ),
    _Question(
      keyName: 'q_category',
      title: 'What space are you transforming?',
      subtitle: 'You can change this anytime later.',
      options: [
        'Dedicated shoe room',
        'Closet or small closet space',
        'Garage or basement area',
        'Kitchen or hallway nook',
        'Outdoor / mudroom area',
      ],
    ),
    _Question(
      keyName: 'q_style',
      title: 'Which aesthetic speaks to you?',
      subtitle: 'We will use this as your baseline mood.',
      options: [
        'Modern Clean (white, minimal)',
        'Scandinavian Utility (light wood)',
        'Industrial Minimal (concrete, metal)',
        'Warm Cozy (wood accents)',
        'Bright White (all white, crisp)',
      ],
    ),
    _Question(
      keyName: 'q_budget',
      title: 'What is your project budget?',
      subtitle: 'We suggest elements that fit your range.',
      options: [
        'Budget-friendly / DIY',
        'Balanced: invest in key items',
        'Flexible: focus on function',
        'Premium / Luxury finishes',
      ],
    ),
    _Question(
      keyName: 'q_flow',
      title: 'How do you plan to use Meeting Room AI?',
      subtitle: 'Aligning speed vs detail for you.',
      options: [
        'Quick inspiration & ideas',
        'Detailed room planning',
        'Visualizing for clients',
        'Comparing different layouts',
      ],
    ),
    _Question(
      keyName: 'q_detail',
      title: 'What matters most in the design?',
      subtitle: 'We balance these elements.',
      options: [
        'Storage & organization',
        'Appliance layout & flow',
        'Materials & finishes',
        'Lighting & brightness',
      ],
    ),
    _Question(
      keyName: 'q_vibe',
      title: 'How should the space feel?',
      subtitle: 'The mood of the room is key.',
      options: [
        'Clean & Fresh',
        'Bright & Efficient',
        'Warm & Inviting',
        'Sleek & Modern',
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
      'Understanding your shoe goals…',
      'Optimizing storage & layout…',
      'Preparing your sleek display workspace…',
    ];
    for (final _ in steps) {
      await Future.delayed(const Duration(milliseconds: 750));
    }

    await _saveAll();

    // Soft upsell ke paywall setelah onboarding
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
        backgroundColor: Colors.black.withValues(alpha: 0.92),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: Row(
          children: [
            const Icon(
              Icons.warning,
              color: Color(0xFFFB7185),
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

    const primary = MeetingAIColors.leatherTan;
    const secondary = MeetingAIColors.metallicGold;
    const accentSoft = MeetingAIColors.laceGray;
    const bg = MeetingAIColors.soleBlack;

    return Scaffold(
      backgroundColor: bg,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            // Animated backdrop
            Positioned.fill(
              child: AnimatedBackdrop(
                ctrl: _dotAnim,
              ),
            ),

            // Blur + overlay
            Positioned.fill(
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        bg.withValues(alpha: 0.97),
                        const Color(0xFF132835).withValues(alpha: 0.96),
                        const Color(0xFF0D1F2D).withValues(alpha: 0.96),
                      ],
                    ),
                  ),
                ),
              ),
            ),

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
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.08),
                            ),
                            color: primary.withValues(alpha: 0.12),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Image.asset(
                            AppAssets.appIcon,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "Meeting Room AI",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            letterSpacing: 0.1,
                          ),
                        ),
                        const Spacer(),
                        ValueListenableBuilder<bool>(
                          valueListenable: premiumListenable,
                          builder: (_, isPro, __) {
                            final chipColor = isPro
                                ? secondary.withValues(alpha: 0.16)
                                : Colors.white.withValues(alpha: 0.06);
                            final borderColor =
                            isPro ? secondary : Colors.white24;
                            final iconColor =
                            isPro ? secondary : Colors.white70;
                            final textColor =
                            isPro ? secondary : Colors.white70;
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: chipColor,
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                  color: borderColor,
                                  width: 0.9,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isPro
                                        ? Icons.verified
                                        : Icons.person,
                                    size: 14,
                                    color: iconColor,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    isPro ? "PREMIUM" : "FREE",
                                    style: TextStyle(
                                      color: textColor,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 11.5,
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
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor: Colors.white.withValues(alpha: 0.10),
                        valueColor: const AlwaysStoppedAnimation(primary),
                      ),
                    ),
                  ),

                  // Step labels + dots
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Column(
                      children: [
                        Text(
                          _stepLabel(),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        if (_questionLabel().isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            _questionLabel(),
                            style: const TextStyle(
                              color: Colors.white38,
                              fontSize: 11,
                            ),
                          ),
                        ],
                        const SizedBox(height: 6),
                        _PageDots(
                          total: _totalPages,
                          index: _page,
                          controller: _dotAnim,
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

                  const SizedBox(height: 4),
                  const _TipTicker(),

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
                              icon: _onLastQuestion
                                  ? Icons.lock
                                  : Icons.arrow_forward,
                              label: _onLastQuestion
                                  ? "Start designing"
                                  : "Next",
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

            // Loading / Finalizing overlay
            if (_isOverlayLoading || _isFinalizing)
              AnimatedBuilder(
                animation: _overlayAnim,
                builder: (_, __) {
                  final msg = _isFinalizing
                      ? _finalStepText()
                      : _randomLoadingText();
                  return Opacity(
                    opacity: Curves.easeOut.transform(_overlayAnim.value),
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.40),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: BackdropFilter(
                              filter: ui.ImageFilter.blur(
                                sigmaX: 18,
                                sigmaY: 18,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      primary.withValues(alpha: 0.10),
                                      accentSoft.withValues(alpha: 0.06),
                                      Colors.black.withValues(alpha: 0.70),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const CupertinoActivityIndicator(radius: 13),
                                const SizedBox(height: 14),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 32.0),
                                  child: Text(
                                    msg,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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

  String _randomLoadingText() {
    const msgs = [
      'Analyzing layout & storage flow…',
      'Optimizing appliance placement…',
      'Preparing sleek display options…',
      'Setting up before/after space…',
      'Tuning organization for efficiency…',
    ];
    return msgs[DateTime.now().second % msgs.length];
  }

  String _finalStepText() {
    const steps = [
      'Locking in your shoe preferences…',
      'Securing your Meeting Room AI workspace…',
      'Getting ready for your first design…',
    ];
    final i = (DateTime.now().millisecond ~/ 500) % steps.length;
    return steps[i];
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
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Meeting Room AI",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.3,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Upload a photo and let AI create a clean, organized shoe space with previews you can save and share.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  height: 1.35,
                ),
              ),
            ],
          ),
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
    final isFilled = controller.text.trim().isNotEmpty;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Let's personalize your space",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "What should we call you inside Meeting Room AI?",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 18),
              AnimatedScale(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutBack,
                scale: isFilled ? 1.02 : 1.0,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isFilled
                          ? MeetingAIColors.leatherTan
                          : Colors.white24,
                      width: isFilled ? 1.2 : 0.8,
                    ),
                  ),
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    onTap: () => HapticFeedback.selectionClick(),
                    textInputAction: TextInputAction.done,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: const InputDecoration(
                      hintText: "Enter your name",
                      hintStyle: TextStyle(color: Colors.white54),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
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
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 780),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                question.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              if (question.subtitle != null) ...[
                const SizedBox(height: 8),
                Text(
                  question.subtitle!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
              const SizedBox(height: 18),
              ...List.generate(
                question.options.length,
                    (i) {
                  final isSel = selectedIndex == i;
                  final txt = question.options[i];
                  final delay = 60 * i;
                  return _StaggeredItem(
                    delayMs: 140 + delay,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOut,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: isSel ? 0.10 : 0.06),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSel
                              ? MeetingAIColors.leatherTan
                              : Colors.white24,
                          width: isSel ? 1.2 : 0.8,
                        ),
                      ),
                      child: ListTile(
                        onTap: () => onSelect(i),
                        leading: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          transitionBuilder: (c, a) => ScaleTransition(
                            scale: CurvedAnimation(
                              parent: a,
                              curve: Curves.easeOutBack,
                            ),
                            child: c,
                          ),
                          child: Icon(
                            isSel
                                ? Icons.verified
                                : Icons.circle_outlined,
                            key: ValueKey(isSel),
                            color: isSel
                                ? MeetingAIColors.leatherTan
                                : Colors.white54,
                          ),
                        ),
                        title: Text(
                          txt,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StaggeredItem extends StatefulWidget {
  final Widget child;
  final int delayMs;
  const _StaggeredItem({
    required this.child,
    this.delayMs = 0,
  });

  @override
  State<_StaggeredItem> createState() => _StaggeredItemState();
}

class _StaggeredItemState extends State<_StaggeredItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 360),
  );
  late final Animation<double> _opacity =
  CurvedAnimation(parent: _c, curve: Curves.easeOut);
  late final Animation<double> _scale = Tween(begin: .98, end: 1.0).animate(
    CurvedAnimation(parent: _c, curve: Curves.easeOutBack),
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(milliseconds: widget.delayMs),
          () {
        if (mounted) _c.forward();
      },
    );
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: ScaleTransition(
        scale: _scale,
        child: widget.child,
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  final int total;
  final int index;
  final AnimationController controller;
  const _PageDots({
    required this.total,
    required this.index,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        total,
            (i) {
          final active = i == index;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            height: 6,
            width: active ? 18 : 6,
            decoration: BoxDecoration(
              color: active
                  ? MeetingAIColors.leatherTan
                  : Colors.white24,
              borderRadius: BorderRadius.circular(99),
            ),
          );
        },
      ),
    );
  }
}

class _TipTicker extends StatefulWidget {
  const _TipTicker();
  @override
  State<_TipTicker> createState() => _TipTickerState();
}

class _TipTickerState extends State<_TipTicker> {
  static const tips = [
    'Tip: Clear the area as much as possible before taking a photo.',
    'Tip: Use natural light to capture the true feel of the room.',
    'Tip: Capture the entire wall or corner you want to transform.',
    'Tip: Think about where you want to place your appliances.',
  ];
  int i = 0;

  @override
  void initState() {
    super.initState();
    _cycle();
  }

  void _cycle() async {
    while (mounted) {
      await Future.delayed(const Duration(milliseconds: 1400));
      if (!mounted) break;
      setState(() => i = (i + 1) % tips.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (c, a) => FadeTransition(
        opacity: a,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, .2),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(parent: a, curve: Curves.easeOut),
          ),
          child: c,
        ),
      ),
      child: Padding(
        key: ValueKey(i),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          tips[i],
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

/// Animated backdrop for animation
class AnimatedBackdrop extends StatelessWidget {
  final AnimationController ctrl;
  const AnimatedBackdrop({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topLeft,
          radius: 1.2,
          colors: [
            MeetingAIColors.leatherTan, // aqua
            MeetingAIColors.soleBlack,
          ],
        ),
      ),
    );
  }
}

/// Glass button
class GlassButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool primary;
  final VoidCallback? onTap;

  const GlassButton({
    super.key,
    required this.label,
    required this.icon,
    this.primary = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = primary ? MeetingAIColors.leatherTan : Colors.white70;

    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.28),
              ),
              color: primary
                  ? color.withValues(alpha: 0.18)
                  : Colors.white.withValues(alpha: 0.06),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
