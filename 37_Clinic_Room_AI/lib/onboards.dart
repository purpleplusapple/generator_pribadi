import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:clinic_room_ai/theme/clinic_theme.dart';
import 'root_shell.dart';
import 'src/app_assets.dart';
import 'src/constant.dart' show openPaywallFromUserAction;
import 'widgets/primary_button.dart';
import 'widgets/clinical_card.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pg = PageController();
  int _page = 0;
  final TextEditingController _nameCtl = TextEditingController();
  final Map<String, int> _answers = {};

  final List<_Question> _questions = [
    _Question(
      keyName: 'q_role',
      title: 'What is your role?',
      subtitle: 'We tailor the experience to your profession.',
      options: [
        'Doctor / Clinic Owner',
        'Interior Designer',
        'Practice Manager',
        'Patient Experience Specialist',
      ],
    ),
    _Question(
      keyName: 'q_goal',
      title: 'What is your main goal?',
      subtitle: 'This helps us prioritize the design parameters.',
      options: [
        'Modernize outdated aesthetic',
        'Improve patient workflow',
        'Maximize hygiene & safety',
        'Create a calming atmosphere',
      ],
    ),
    _Question(
      keyName: 'q_space',
      title: 'What space are you designing?',
      subtitle: 'Different rooms have different standards.',
      options: [
        'Examination Room',
        'Waiting Area / Reception',
        'Dental Suite',
        'Consultation Office',
        'Surgical / Procedure Room',
      ],
    ),
    _Question(
      keyName: 'q_style',
      title: 'Which aesthetic fits best?',
      subtitle: 'Choose a baseline mood.',
      options: [
        'Sterile Minimalist (White/clean)',
        'Warm & Reassuring (Wood/soft)',
        'Modern High-Tech (Sleek/metal)',
        'Child-Friendly (Playful/safe)',
      ],
    ),
    _Question(
      keyName: 'q_budget',
      title: 'Project Tier?',
      subtitle: 'We suggest finishes that match.',
      options: [
        'Standard Medical Grade',
        'Premium Private Practice',
        'Luxury Boutique Clinic',
      ],
    ),
  ];

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
      final text = (idx >= 0 && idx < q.options.length) ? q.options[idx] : '';
      await p.setString(q.keyName, text);
    }
  }

  Future<void> _finish() async {
    await _saveAll();
    await openPaywallFromUserAction(context); // Optional soft upsell

    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const RootShell()),
      (_) => false,
    );
  }

  void _next() async {
    FocusScope.of(context).unfocus();

    if (_page == 1 && _nameCtl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your name to continue.")),
      );
      return;
    } else if (_page >= 2) {
      final q = _questions[_page - 2];
      if (_answers[q.keyName] == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please choose an answer for \"${q.title}\".")),
        );
        return;
      }
    }

    if (_onLastQuestion) {
      await _finish();
    } else {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ClinicColors.bg0,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                   Icon(Icons.local_hospital_rounded, color: ClinicColors.primary, size: 28),
                   const SizedBox(width: 8),
                   Text("Clinic Room AI", style: ClinicText.h3),
                   const Spacer(),
                   Container(
                     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                     decoration: BoxDecoration(
                       color: ClinicColors.primarySoft,
                       borderRadius: BorderRadius.circular(12),
                     ),
                     child: Text("Setup", style: ClinicText.small.copyWith(color: ClinicColors.primary)),
                   ),
                ],
              ),
            ),

            // Progress
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (_page + 1) / _totalPages,
                  backgroundColor: ClinicColors.line,
                  color: ClinicColors.primary,
                  minHeight: 4,
                ),
              ),
            ),

            // Page Content
            Expanded(
              child: PageView.builder(
                controller: _pg,
                physics: const NeverScrollableScrollPhysics(), // Force using buttons
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

            // Footer Buttons
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: ClinicColors.line)),
              ),
              child: Row(
                children: [
                  if (_page > 0)
                    TextButton(
                      onPressed: _prev,
                      child: Text("Back", style: ClinicText.button.copyWith(color: ClinicColors.ink1)),
                    ),
                  if (_page > 0) const SizedBox(width: 16),
                  Expanded(
                    child: PrimaryButton(
                      label: _onLastQuestion ? "Complete Setup" : "Next",
                      onPressed: _next,
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

class _IntroPage extends StatelessWidget {
  const _IntroPage();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: ClinicShadows.card,
            ),
            child: Icon(Icons.auto_awesome, size: 48, color: ClinicColors.primary),
          ),
          const SizedBox(height: 32),
          Text(
            "Welcome to Clinic Room AI",
            textAlign: TextAlign.center,
            style: ClinicText.h1,
          ),
          const SizedBox(height: 16),
          Text(
            "Design professional medical spaces in seconds. Upload a photo, choose a style, and let AI optimize your clinic layout.",
            textAlign: TextAlign.center,
            style: ClinicText.body.copyWith(color: ClinicColors.ink2),
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
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("What should we call you?", style: ClinicText.h2),
          const SizedBox(height: 24),
          TextField(
            controller: controller,
            textAlign: TextAlign.center,
            style: ClinicText.h3,
            decoration: InputDecoration(
              hintText: "Enter your name",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: ClinicColors.line),
              ),
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

  const _QuestionPage({
    required this.question,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(question.title, style: ClinicText.h2, textAlign: TextAlign.center),
          if (question.subtitle != null) ...[
            const SizedBox(height: 8),
            Text(question.subtitle!, style: ClinicText.body.copyWith(color: ClinicColors.ink2), textAlign: TextAlign.center),
          ],
          const SizedBox(height: 32),
          ...List.generate(question.options.length, (i) {
            final isSel = selectedIndex == i;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ClinicalCard(
                onTap: () => onSelect(i),
                backgroundColor: isSel ? ClinicColors.primarySoft : Colors.white,
                borderColor: isSel ? ClinicColors.primary : ClinicColors.line,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        question.options[i],
                        style: ClinicText.bodyMedium.copyWith(
                          color: isSel ? ClinicColors.primary : ClinicColors.ink1,
                          fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                        ),
                      ),
                    ),
                    if (isSel) Icon(Icons.check_circle, color: ClinicColors.primary),
                  ],
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
  const _Question({
    required this.keyName,
    required this.title,
    this.subtitle,
    required this.options,
  });
}
