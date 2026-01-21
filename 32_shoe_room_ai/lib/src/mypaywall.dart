// ============================
// lib/src/mypaywall.dart
// Shoe Room AI — Premium Paywall (RevenueCat)
// ============================

import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoe_room_ai/src/credits_vault.dart';
import 'package:shoe_room_ai/src/app_assets.dart';
import 'package:shoe_room_ai/src/constant.dart'
    show
        markJustPurchased,
        checkPremiumFresh,
        premiumListenable,
        entitlementKey,
        kToken5ProductId;
import 'package:shoe_room_ai/theme/shoe_room_ai_theme.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

const _bgBase = ShoeAIColors.pitBlack;
const _bgOverlay = Color(0x66101122);

// Neon teal/green for primary
const _primary = Color(0xFF00E5FF);
const _primarySoft = Color(0x3300E5FF);

// Accent = hazard orange (matches accentGradient)
const _accent = Color(0xFFFF8A00);
const _accentSoft = Color(0x33FF8A00);

const _textPrimary = ShoeAIColors.textMain;
const _textSecondary = ShoeAIColors.textMuted;

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

    // Delay close untuk fokus UX
    Timer(const Duration(seconds: 30), () {
      if (mounted) setState(() => _showClose = true);
    });

    // CTA pulse
    _ctaPulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _ctaCurve = CurvedAnimation(
      parent: _ctaPulse,
      curve: Curves.easeInOut,
    );

    // Auto-close jika premium aktif dari tempat lain
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

  // =================== Data fetch ===================

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
  // ===== Bottom CTA (Annual Highlight) =======================================

  Widget _bottomAnnualCta(Package? annualPkg) {
    // Kalau tidak ada annual package, jangan render apa-apa
    if (annualPkg == null) {
      return const SizedBox.shrink();
    }

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
                      // Gradient underlay (soft aura)
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
                      // Main CTA button
                      SizedBox(
                        height: 60,
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(
                            CupertinoIcons.arrow_right_circle_fill,
                            size: 20,
                            color: _bgBase,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primary,
                            foregroundColor: _bgBase,
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
                                    color: _bgBase,
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
                      // Subtle border shimmer
                      Positioned.fill(
                        child: IgnorePointer(
                          child: Opacity(
                            opacity: 0.18 + (0.18 * _ctaCurve.value),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.18),
                                  width: 1,
                                ),
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
  // =================== Purchase handlers ===================

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
        _safeSnack("You have unlocked Shoe Room AI Premium.");
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
      _safeSnack("5 extra Shoe Room AI tokens added.");
    } catch (e) {
      debugPrint("Token purchase failed: $e");
      if (mounted) {
        _safeSnack("Token purchase cancelled or failed.");
      }
    } finally {
      if (mounted) setState(() => _busyToken = false);
    }
  }

  Future<void> _restorePurchases() async {
    try {
      await Purchases.restorePurchases();
      await Purchases.invalidateCustomerInfoCache();
      final isPro = await checkPremiumFresh();
      if (!mounted) return;
      _safeSnack(
        isPro
            ? "Purchases restored. Premium is active."
            : "Purchases restored. No active subscription found.",
      );
      if (isPro && Navigator.canPop(context)) Navigator.pop(context);
    } catch (e) {
      debugPrint("Restore failed: $e");
      if (mounted) _safeSnack("Restore failed. Please try again.");
    }
  }

  // =================== UI ===================

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
          // Background gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF020817),
                    Color(0xFF030712),
                    Color(0xFF020817),
                  ],
                ),
              ),
            ),
          ),
          // Glow blobs
          Positioned.fill(child: CustomPaint(painter: _GlowPainter())),
          // Blur overlay
          Positioned.fill(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 26, sigmaY: 26),
              child: Container(color: _bgOverlay.withValues(alpha: 0.70)),
            ),
          ),

          // Content
          SafeArea(
            child: _offerings == null
                ? const Center(
                    child: CupertinoActivityIndicator(color: _primary),
                  )
                : _buildContent(context, packages, annualPkg),
          ),

          // Bottom CTA
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
            // Close button (delayed)
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

            // Logo + headline
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
                    "Shoe Room AI Premium",
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
                    "10 daily redesigns, priority rendering, and all style options for your perfect shoe space.",
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

            // Live entitlement status
            ValueListenableBuilder<bool>(
              valueListenable: premiumListenable,
              builder: (context, isPro, _) {
                final label = isPro ? "Premium Active" : "Free Plan";
                final subtitle = isPro
                    ? "Your \"$entitlementKey\" entitlement is active. Enjoy all premium features and AI generation."
                    : "Upgrade to Premium to unlock AI shoe room generation and all premium features.";
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

            // Value props
            _sectionTitle("Why upgrade to Premium"),
            const SizedBox(height: 10),
            _feature(
              "10 AI shoe room redesigns per day with premium quality.",
            ),
            _feature(
              "Unlimited generations with token packs when you need more.",
            ),
            _feature(
              "Access every style kit, body kit, wheels, and paint preset.",
            ),
            _feature(
              "Priority queue for faster custom builds on busy days.",
            ),
            _feature(
              "Full history access with high-res downloads of your builds.",
            ),
            _feature(
              "No ads; pro-level experience for enthusiasts planning their dream car builds.",
            ),

            const SizedBox(height: 22),

            // Social proof
            _sectionTitle("Trusted by tuners and collectors"),
            const SizedBox(height: 10),
            _ratingsSummary(avg: 4.8, total: 12431),
            const SizedBox(height: 10),
            _reviewCard(
              name: "Ken",
              stars: 5,
              date: "2 days ago",
              review:
                  "I can present two build looks in minutes and iterate with clients fast.",
            ),
            _reviewCard(
              name: "Dina",
              stars: 5,
              date: "Last week",
              review:
                  "Premium lets me export every preset in high-res for my client decks.",
            ),
            _reviewCard(
              name: "Andi",
              stars: 5,
              date: "3 weeks ago",
              review:
                  "Tokens help when I need extra renders during busy design sprints.",
            ),

            const SizedBox(height: 22),

            // Timeline
            _sectionTitle("What you get from day one"),
            const SizedBox(height: 8),
            _timeline(),

            const SizedBox(height: 24),

            // Plans
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

            // Tokens
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
                title: "5 Extra Shoe Room AI Tokens",
                description:
                    "Use tokens when you hit your daily premium limit. One token equals one extra render.",
                price: _token5!.priceString,
                busy: _busyToken,
                onTap: _buyToken5,
              ),

            const SizedBox(height: 18),

            // Restore + Legal
            TextButton(
              onPressed: _restorePurchases,
              child: const Text(
                "Restore Purchases",
                style: TextStyle(
                  color: _textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Subscriptions renew automatically unless cancelled at least 24 hours before the end of the current period. "
              "Manage or cancel anytime in your App Store settings. Token packs are one-time and not refundable.",
              style: TextStyle(
                color: _textSecondary,
                fontSize: 10.5,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 18,
              children: [
                _linkText(
                  "Terms of Use",
                  "https://vibesinterior.com/terms.php",
                ),
                _linkText(
                  "Privacy Policy",
                  "https://vibesinterior.com/privacy.php",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // =================== Small helpers ===================

  void _safeSnack(String msg) {
    if (!mounted) return;
    final m = ScaffoldMessenger.of(context);
    m.removeCurrentSnackBar();
    m.showSnackBar(SnackBar(content: Text(msg)));
  }
}

// ===== Shared UI bits tuned for Shoe Room AI ===========================

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
      desc:
          "Unlock premium car renders, priority generation, and full history instantly.",
      icon: CupertinoIcons.paintbrush,
    ),
    const _Milestone(
      title: "Day 1",
      desc: "Deliver polished previews for your build ideas.",
      icon: CupertinoIcons.sparkles,
    ),
    const _Milestone(
      title: "Week 1",
      desc:
          "Share multiple build options with friends or clients effortlessly.",
      icon: CupertinoIcons.person_2_fill,
    ),
    const _Milestone(
      title: "Month 1",
      desc:
          "Plan complete custom builds with confidence and creative freedom.",
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
                    color: _bgBase,
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

Widget _ratingsSummary({
  required double avg,
  required int total,
}) {
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
                style: const TextStyle(
                  color: _textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 32,
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: 4),
              _stars(avg),
              const SizedBox(height: 6),
              Text(
                "${_formatNumber(total)}+ renders",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: _textSecondary,
                  fontSize: 10.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            children: List.generate(5, (i) {
              final star = 5 - i;
              final pct = dist[i] / 100.0;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    SizedBox(
                      width: 26,
                      child: Text(
                        "$star★",
                        style: const TextStyle(
                          color: _textSecondary,
                          fontSize: 10.5,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: Stack(
                          children: [
                            Container(
                              height: 7,
                              color: Colors.white.withValues(alpha: 0.08),
                            ),
                            FractionallySizedBox(
                              widthFactor: pct,
                              child: Container(
                                height: 7,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      _primary,
                                      _accent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    SizedBox(
                      width: 32,
                      child: Text(
                        "${dist[i]}%",
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: _textSecondary,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    ),
  );
}

Widget _stars(double rating) {
  final full = rating.floor();
  final half = (rating - full) >= 0.5;
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: List.generate(5, (i) {
      if (i < full) {
        return const Icon(
          CupertinoIcons.star_fill,
          color: _primary,
          size: 14,
        );
      } else if (i == full && half) {
        return const Icon(
          CupertinoIcons.star_lefthalf_fill,
          color: _primary,
          size: 14,
        );
      } else {
        return const Icon(
          CupertinoIcons.star,
          color: _primary,
          size: 14,
        );
      }
    }),
  );
}

String _formatNumber(int n) {
  if (n >= 1000000) {
    return "${(n / 1000000).toStringAsFixed(1)}M";
  }
  if (n >= 1000) {
    return "${(n / 1000).toStringAsFixed(1)}k";
  }
  return "$n";
}

Widget _reviewCard({
  required String name,
  required int stars,
  required String date,
  required String review,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 5),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.03),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _primarySoft,
            border: Border.all(color: _primary, width: 0.7),
          ),
          alignment: Alignment.center,
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : "?",
            style: const TextStyle(
              color: _textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: const TextStyle(
                        color: _textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                  _stars(stars.toDouble()),
                  const SizedBox(width: 4),
                  Text(
                    date,
                    style: const TextStyle(
                      color: _textSecondary,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                review,
                style: const TextStyle(
                  color: _textPrimary,
                  fontSize: 11.5,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _planCard({
  required Package package,
  required VoidCallback onBuy,
  required bool busy,
}) {
  final type = package.packageType;
  final title = _getPlanTitle(type);
  final desc = _getPlanDescription(type);
  final price = package.storeProduct.priceString;
  final isBest = type == PackageType.annual;

  return Container(
    margin: const EdgeInsets.symmetric(vertical: 6),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: Colors.white.withValues(alpha: isBest ? 0.09 : 0.05),
      border: Border.all(
        color: isBest
            ? _primary.withValues(alpha: 0.55)
            : Colors.white.withValues(alpha: 0.16),
        width: isBest ? 1.2 : 0.9,
      ),
      boxShadow: [
        BoxShadow(
          color: (isBest ? _accent : _primary).withValues(alpha: 0.26),
          blurRadius: 18,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: LayoutBuilder(
      builder: (context, c) {
        final isNarrow = c.maxWidth < 360;

        final badge = isBest
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  color: _primarySoft,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: _primary,
                    width: 0.8,
                  ),
                ),
                child: const Text(
                  "Recommended",
                  style: TextStyle(
                    color: _primary,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              )
            : const SizedBox.shrink();

        final titleDesc = Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isBest) badge,
              Text(
                title,
                style: const TextStyle(
                  color: _textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                desc,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _textSecondary,
                  fontSize: 11.2,
                  height: 1.32,
                ),
              ),
            ],
          ),
        );

        final priceLabel = Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              price,
              style: const TextStyle(
                color: _primary,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 2),
            if (isBest)
              const Text(
                "Best value",
                style: TextStyle(
                  color: _textSecondary,
                  fontSize: 9,
                ),
              ),
          ],
        );

        final btn = SizedBox(
          height: 40,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _primary,
              foregroundColor: _bgBase,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: busy ? null : onBuy,
            child: busy
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: _bgBase,
                    ),
                  )
                : const Text(
                    "Upgrade",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
          ),
        );

        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [titleDesc],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: priceLabel),
                  const SizedBox(width: 10),
                  btn,
                ],
              ),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            titleDesc,
            const SizedBox(width: 12),
            priceLabel,
            const SizedBox(width: 10),
            btn,
          ],
        );
      },
    ),
  );
}

Widget _tokenCard({
  required String title,
  required String description,
  required String price,
  required bool busy,
  required VoidCallback onTap,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 5),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.03),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: _textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13.5,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                description,
                style: const TextStyle(
                  color: _textSecondary,
                  fontSize: 11.3,
                  height: 1.32,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                price,
                style: const TextStyle(
                  color: _primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          height: 36,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _primary,
              foregroundColor: _bgBase,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: busy ? null : onTap,
            child: busy
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: _bgBase,
                    ),
                  )
                : const Text(
                    "Buy",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
          ),
        ),
      ],
    ),
  );
}

String _getPlanTitle(PackageType type) {
  switch (type) {
    case PackageType.weekly:
      return "Weekly Premium";
    case PackageType.monthly:
      return "Monthly Premium";
    case PackageType.annual:
      return "Annual Premium";
    default:
      return "Premium Plan";
  }
}

String _getPlanDescription(PackageType type) {
  switch (type) {
    case PackageType.weekly:
      return "Short-term access for quick build experiments or event weeks.";
    case PackageType.monthly:
      return "Reliable access for builders who iterate on cars every week.";
    case PackageType.annual:
      return "Best value for enthusiasts and pros customizing cars all year.";
    default:
      return "Unlock full Shoe Room AI experience.";
  }
}

Package? _annualPackage(List<Package> packages) {
  try {
    return packages.firstWhere(
      (p) => p.packageType == PackageType.annual,
    );
  } catch (_) {
    return null;
  }
}

Widget _linkText(String label, String url) {
  return GestureDetector(
    onTap: () async {
      final u = Uri.parse(url);
      if (await canLaunchUrl(u)) {
        await launchUrl(u, mode: LaunchMode.externalApplication);
      }
    },
    child: Text(
      label,
      style: const TextStyle(
        color: _primary,
        fontWeight: FontWeight.w700,
        fontSize: 11.5,
        decoration: TextDecoration.underline,
      ),
    ),
  );
}

// Background glow painter

class _GlowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40);

    paint.color = _accentSoft;
    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.18),
      90,
      paint,
    );

    paint.color = _primarySoft;
    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.22),
      110,
      paint,
    );

    paint.color = _accentSoft.withValues(alpha: 0.7);
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.9),
      160,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
