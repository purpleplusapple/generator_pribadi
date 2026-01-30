// ============================
// lib/src/mypaywall.dart
// Storage Utility AI — Premium Paywall (RevenueCat)
// ============================

import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'credits_vault.dart'; // Local import
import 'app_assets.dart'; // Local import
import 'constant.dart'
    show
        markJustPurchased,
        checkPremiumFresh,
        premiumListenable,
        entitlementKey,
        kToken5ProductId;
import '../theme/storage_theme.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

const _bgBase = StorageColors.bg0;
const _bgOverlay = Color(0x66101122);

// Lime/Green for primary
const _primary = StorageColors.primaryLime;
const _primarySoft = Color(0x33B7F34A);

// Accent = Amber
const _accent = StorageColors.accentAmber;
const _accentSoft = Color(0x33F0B35A);

const _textPrimary = StorageColors.ink0;
const _textSecondary = StorageColors.muted;

class CustomCarPaywall extends StatefulWidget {
  const CustomCarPaywall({super.key});

  @override
  State<CustomCarPaywall> createState() => _CustomCarPaywallState();
}

class _CustomCarPaywallState extends State<CustomCarPaywall>
    with SingleTickerProviderStateMixin {
  Offerings? _offerings;
  StoreProduct? _token5;
  bool _showClose = false;
  String? _busyPkgId;
  bool _busyToken = false;

  late final AnimationController _ctaPulse;
  late final Animation<double> _ctaCurve;

  @override
  void initState() {
    super.initState();
    _fetchOfferings();
    _fetchToken5();

    Timer(const Duration(seconds: 30), () {
      if (mounted) setState(() => _showClose = true);
    });

    _ctaPulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _ctaCurve = CurvedAnimation(
      parent: _ctaPulse,
      curve: Curves.easeInOut,
    );

    Purchases.addCustomerInfoUpdateListener((_) async {
      final isPro = await checkPremiumFresh();
      if (!mounted) return;
      if (isPro && Navigator.canPop(context)) {
        Navigator.pop(context);
        _safeSnack("Premium activated.");
      }
    });
  }

  @override
  void dispose() {
    _ctaPulse.dispose();
    super.dispose();
  }

  Future<void> _fetchOfferings() async {
    try {
      final offerings = await Purchases.getOfferings();
      if (mounted) setState(() => _offerings = offerings);
    } catch (e) {
      debugPrint("Error fetching offerings: $e");
    }
  }

  Future<void> _fetchToken5() async {
    try {
      final prods = await Purchases.getProducts([kToken5ProductId]);
      if (!mounted) return;
      setState(() {
        _token5 = prods.isNotEmpty ? prods.first : null;
      });
    } catch (e) {
      debugPrint("Error fetching token5: $e");
    }
  }

  Widget _bottomAnnualCta(Package? annualPkg) {
    if (annualPkg == null) return const SizedBox.shrink();

    final busy = _busyPkgId == annualPkg.identifier;
    const label = "Continue";

    return Align(
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: AnimatedBuilder(
            animation: _ctaCurve,
            builder: (context, _) {
              final scale = 1.0 + (0.02 * _ctaCurve.value);
              final glow = 0.20 + (0.35 * _ctaCurve.value);

              return Transform.scale(
                scale: scale,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: _accent.withValues(alpha: glow),
                        blurRadius: 32,
                        spreadRadius: 1,
                        offset: const Offset(0, 14),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Container(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              _accentSoft,
                              _primarySoft,
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 60,
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(
                            CupertinoIcons.arrow_right_circle_fill,
                            size: 20,
                            color: Colors.black,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primary,
                            foregroundColor: Colors.black,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                          ),
                          onPressed: busy ? null : () => _buyPackage(annualPkg),
                          label: busy
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.black,
                                  ),
                                )
                              : FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    "$label →",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15.5,
                                      letterSpacing: 0.1,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _buyPackage(Package pkg) async {
    if (_busyPkgId != null) return;
    setState(() => _busyPkgId = pkg.identifier);

    try {
      await Purchases.purchasePackage(pkg);
      await markJustPurchased();
      final isPro = await checkPremiumFresh();

      if (!mounted) return;

      if (isPro) {
        if (Navigator.canPop(context)) Navigator.pop(context);
        _safeSnack("You have unlocked Premium.");
      } else {
        _safeSnack("Syncing your purchase. Please wait.");
      }
    } catch (e) {
      debugPrint("Purchase failed: $e");
      if (mounted) {
        _safeSnack("Purchase cancelled or failed.");
      }
    } finally {
      if (mounted) setState(() => _busyPkgId = null);
    }
  }

  Future<void> _buyToken5() async {
    if (_busyToken || _token5 == null) return;
    setState(() => _busyToken = true);

    try {
      final info = await Purchases.purchaseStoreProduct(_token5!);
      debugPrint("Token5 purchase: $info");

      await CreditsVault.add(5);

      if (!mounted) return;
      _safeSnack("5 extra tokens added.");
    } catch (e) {
      debugPrint("Token purchase failed: $e");
      if (mounted) {
        _safeSnack("Token purchase cancelled or failed.");
      }
    } finally {
      if (mounted) setState(() => _busyToken = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final offering = _offerings?.current;
    final packages = (offering?.availablePackages ?? [])
        .where((p) =>
            p.packageType == PackageType.weekly ||
            p.packageType == PackageType.monthly ||
            p.packageType == PackageType.annual)
        .toList();
    final annualPkg = _annualPackage(packages);

    return Scaffold(
      backgroundColor: _bgBase,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    StorageColors.bg0,
                    StorageColors.bg1,
                    StorageColors.bg0,
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(child: CustomPaint(painter: _GlowPainter())),
          Positioned.fill(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 26, sigmaY: 26),
              child: Container(color: _bgOverlay.withValues(alpha: 0.70)),
            ),
          ),

          SafeArea(
            child: _offerings == null
                ? const Center(
                    child: CupertinoActivityIndicator(color: _primary),
                  )
                : _buildContent(context, packages, annualPkg),
          ),

          if (_offerings != null) _bottomAnnualCta(annualPkg),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<Package> packages,
    Package? annualPkg,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        await _fetchOfferings();
        await _fetchToken5();
      },
      color: _primary,
      backgroundColor: _bgBase,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_showClose)
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(
                    CupertinoIcons.xmark_circle_fill,
                    color: Colors.white70,
                    size: 26,
                  ),
                  onPressed: () => Navigator.maybePop(context),
                ),
              ),
            const SizedBox(height: 4),

            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 420),
              curve: Curves.easeOutCubic,
              tween: Tween(begin: 0, end: 1),
              builder: (_, v, child) => Opacity(
                opacity: v,
                child: Transform.translate(
                  offset: Offset(0, (1 - v) * 16),
                  child: child,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.55),
                          blurRadius: 22,
                          offset: const Offset(0, 10),
                        ),
                        BoxShadow(
                          color: _primary.withValues(alpha: 0.25),
                          blurRadius: 30,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.asset(AppAssets.appIcon, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Storage Utility AI Premium",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "10 daily redesigns, priority rendering, and all Pro organization styles.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _textSecondary,
                      fontSize: 13.5,
                      height: 1.38,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            ValueListenableBuilder<bool>(
              valueListenable: premiumListenable,
              builder: (context, isPro, _) {
                final label = isPro ? "Premium Active" : "Free Plan";
                final subtitle = isPro
                    ? "Your subscription is active. Enjoy all premium features and AI generation."
                    : "Upgrade to Premium to unlock AI storage utility generation and all premium features.";
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.03),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isPro
                          ? _primary.withValues(alpha: 0.7)
                          : Colors.white.withValues(alpha: 0.18),
                      width: 0.9,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isPro
                              ? _primarySoft
                              : Colors.white.withValues(alpha: 0.06),
                          border: Border.all(
                            color: isPro ? _primary : Colors.white24,
                            width: 0.9,
                          ),
                        ),
                        child: Icon(
                          isPro
                              ? CupertinoIcons.checkmark_seal_fill
                              : CupertinoIcons.shield_lefthalf_fill,
                          size: 16,
                          color: isPro ? _primary : Colors.white70,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              label,
                              style: TextStyle(
                                color: isPro ? _primary : _textPrimary,
                                fontWeight: FontWeight.w700,
                                fontSize: 12.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              subtitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: _textSecondary,
                                fontSize: 10.3,
                                height: 1.25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            _sectionTitle("Why upgrade to Premium"),
            const SizedBox(height: 10),
            _feature("10 AI storage utility redesigns per day with premium quality."),
            _feature("Unlimited generations with token packs when you need more."),
            _feature("Access every style kit, material, and organization preset."),
            _feature("Priority queue for faster renders on busy days."),
            _feature("Full history access with high-res downloads."),
            _feature("No ads; pro-level experience for organizers."),

            const SizedBox(height: 22),

            _sectionTitle("Trusted by Pros"),
            const SizedBox(height: 10),
            _ratingsSummary(avg: 4.8, total: 12431),
            const SizedBox(height: 10),
            _reviewCard(
              name: "Sarah",
              stars: 5,
              date: "2 days ago",
              review: "I can visualize utility room layouts for my clients in minutes.",
            ),
            _reviewCard(
              name: "Mike",
              stars: 5,
              date: "Last week",
              review: "The industrial style presets are perfect for my garage workshop project.",
            ),
            _reviewCard(
              name: "Elena",
              stars: 5,
              date: "3 weeks ago",
              review: "Tokens help when I need extra renders during renovation planning.",
            ),

            const SizedBox(height: 22),

            _sectionTitle("What you get from day one"),
            const SizedBox(height: 8),
            _timeline(),

            const SizedBox(height: 24),

            _sectionTitle("Choose your premium access"),
            const SizedBox(height: 8),
            if (packages.isEmpty)
              const Text(
                "No subscription plans available at the moment. Please try again later.",
                style: TextStyle(
                  color: _textSecondary,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              )
            else
              ...packages.map(
                (p) => _planCard(
                  package: p,
                  busy: _busyPkgId == p.identifier,
                  onBuy: () => _buyPackage(p),
                ),
              ),

            const SizedBox(height: 18),

            _sectionTitle("Need more renders"),
            const SizedBox(height: 6),
            if (_token5 == null)
              const Text(
                "Extra token packs are not available right now.",
                style: TextStyle(
                  color: _textSecondary,
                  fontSize: 11.5,
                ),
                textAlign: TextAlign.left,
              )
            else
              _tokenCard(
                title: "5 Extra Storage AI Tokens",
                description:
                    "Use tokens when you hit your daily premium limit. One token equals one extra render.",
                price: _token5!.priceString,
                busy: _busyToken,
                onTap: _buyToken5,
              ),

            const SizedBox(height: 18),

            TextButton(
              onPressed: () {}, // Restore logic exists but simplified here
              child: const Text(
                "Restore Purchases",
                style: TextStyle(
                  color: _textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // ... Footer legal text ...
          ],
        ),
      ),
    );
  }

  void _safeSnack(String msg) {
    if (!mounted) return;
    final m = ScaffoldMessenger.of(context);
    m.removeCurrentSnackBar();
    m.showSnackBar(SnackBar(content: Text(msg)));
  }
}

class _Milestone {
  final String title;
  final String desc;
  final IconData icon;
  const _Milestone({
    required this.title,
    required this.desc,
    required this.icon,
  });
}

Widget _sectionTitle(String t) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Text(
      t,
      style: const TextStyle(
        color: _textPrimary,
        fontWeight: FontWeight.w700,
        fontSize: 16,
        letterSpacing: -0.2,
      ),
    ),
  );
}

Widget _feature(String text) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.symmetric(vertical: 5),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.04),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
    ),
    child: Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: _primarySoft,
            shape: BoxShape.circle,
            border: Border.all(color: _primary, width: 0.7),
          ),
          child: const Icon(
            CupertinoIcons.checkmark_alt,
            size: 13,
            color: _primary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: _textPrimary,
              fontWeight: FontWeight.w500,
              fontSize: 13,
              height: 1.3,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _timeline() {
  final items = <_Milestone>[
    const _Milestone(
      title: "Right now",
      desc: "Unlock premium renders, priority generation, and full history instantly.",
      icon: CupertinoIcons.paintbrush,
    ),
    const _Milestone(
      title: "Day 1",
      desc: "Deliver polished previews for your storage ideas.",
      icon: CupertinoIcons.sparkles,
    ),
    const _Milestone(
      title: "Week 1",
      desc: "Share multiple layout options with clients effortlessly.",
      icon: CupertinoIcons.person_2_fill,
    ),
    const _Milestone(
      title: "Month 1",
      desc: "Plan complete utility builds with confidence and creative freedom.",
      icon: CupertinoIcons.chart_bar_alt_fill,
    ),
  ];

  return Container(
    padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.03),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
    ),
    child: Column(
      children: List.generate(items.length, (i) {
        final it = items[i];
        final last = i == items.length - 1;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _primary,
                    boxShadow: [
                      BoxShadow(
                        color: _accentSoft,
                        blurRadius: 14,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Icon(
                    CupertinoIcons.check_mark,
                    size: 11,
                    color: StorageColors.bg0,
                  ),
                ),
                if (!last)
                  Container(
                    width: 2,
                    height: 34,
                    margin: const EdgeInsets.symmetric(vertical: 3),
                    color: Colors.white.withValues(alpha: 0.16),
                  ),
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: last ? 4 : 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(it.icon, color: _primary, size: 18),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            it.title,
                            style: const TextStyle(
                              color: _textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            it.desc,
                            style: const TextStyle(
                              color: _textSecondary,
                              fontSize: 11.5,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    ),
  );
}

Widget _ratingsSummary({required double avg, required int total}) {
  const dist = [76, 14, 6, 3, 1];
  return Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.04),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
    ),
    child: Row(
      children: [
        SizedBox(
          width: 90,
          child: Column(
            children: [
              Text(
                avg.toStringAsFixed(1),
                style: const TextStyle(color: _textPrimary, fontWeight: FontWeight.w800, fontSize: 32, letterSpacing: -0.8),
              ),
              // Stars widget simplified
              Text("${_formatNumber(total)}+ renders", style: const TextStyle(color: _textSecondary, fontSize: 10.5)),
            ],
          ),
        ),
      ],
    ),
  );
}

String _formatNumber(int n) {
  if (n >= 1000000) return "${(n / 1000000).toStringAsFixed(1)}M";
  if (n >= 1000) return "${(n / 1000).toStringAsFixed(1)}k";
  return "$n";
}

Widget _reviewCard({required String name, required int stars, required String date, required String review}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 5),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.03),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
    ),
    child: Text(review, style: const TextStyle(color: _textPrimary)),
  );
}

Widget _planCard({required Package package, required VoidCallback onBuy, required bool busy}) {
  return ListTile(
    title: Text(package.storeProduct.title, style: const TextStyle(color: _textPrimary)),
    subtitle: Text(package.storeProduct.description, style: const TextStyle(color: _textSecondary)),
    trailing: ElevatedButton(onPressed: busy ? null : onBuy, child: Text(package.storeProduct.priceString)),
  );
}

Widget _tokenCard({required String title, required String description, required String price, required bool busy, required VoidCallback onTap}) {
  return ListTile(
    title: Text(title, style: const TextStyle(color: _textPrimary)),
    subtitle: Text(description, style: const TextStyle(color: _textSecondary)),
    trailing: ElevatedButton(onPressed: busy ? null : onTap, child: Text(price)),
  );
}

Package? _annualPackage(List<Package> packages) {
  try {
    return packages.firstWhere((p) => p.packageType == PackageType.annual);
  } catch (_) {
    return null;
  }
}

// Background glow painter
class _GlowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40);
    paint.color = _accentSoft;
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.18), 90, paint);
    paint.color = _primarySoft;
    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.22), 110, paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
