// lib/src/mypaywall.dart
// Study Class AI — Premium Paywall (RevenueCat)

import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_class_ai/src/credits_vault.dart';
import 'package:study_class_ai/src/app_assets.dart';
import 'package:study_class_ai/src/constant.dart' show markJustPurchased, checkPremiumFresh, premiumListenable, entitlementKey, kToken5ProductId;
import 'package:study_class_ai/theme/app_theme.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

const _bgBase = StudyAIColors.bg0;
const _bgOverlay = Color(0x660A0D14);

const _primary = StudyAIColors.primary;
const _primarySoft = StudyAIColors.primarySoft;
const _accent = StudyAIColors.accentBlue;

const _textPrimary = StudyAIColors.ink0;
const _textSecondary = StudyAIColors.muted;

class CustomCarPaywall extends StatefulWidget {
  const CustomCarPaywall({super.key});

  @override
  State<CustomCarPaywall> createState() => _CustomCarPaywallState();
}

class _CustomCarPaywallState extends State<CustomCarPaywall> with SingleTickerProviderStateMixin {
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

    _ctaPulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))..repeat(reverse: true);
    _ctaCurve = CurvedAnimation(parent: _ctaPulse, curve: Curves.easeInOut);

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
      setState(() => _token5 = prods.isNotEmpty ? prods.first : null);
    } catch (e) {
      debugPrint("Error fetching token5: $e");
    }
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
        _safeSnack("You have unlocked Study Class Premium.");
      } else {
        _safeSnack("Syncing your purchase...");
      }
    } catch (e) {
      if (mounted) _safeSnack("Purchase cancelled or failed.");
    } finally {
      if (mounted) setState(() => _busyPkgId = null);
    }
  }

  Future<void> _buyToken5() async {
    if (_busyToken || _token5 == null) return;
    setState(() => _busyToken = true);
    try {
      await Purchases.purchaseStoreProduct(_token5!);
      await CreditsVault.add(5);
      if (!mounted) return;
      _safeSnack("5 extra tokens added.");
    } catch (e) {
      if (mounted) _safeSnack("Token purchase cancelled or failed.");
    } finally {
      if (mounted) setState(() => _busyToken = false);
    }
  }

  Future<void> _restorePurchases() async {
    try {
      await Purchases.restorePurchases();
      final isPro = await checkPremiumFresh();
      if (!mounted) return;
      _safeSnack(isPro ? "Purchases restored. Premium active." : "Purchases restored. No active subscription.");
      if (isPro && Navigator.canPop(context)) Navigator.pop(context);
    } catch (e) {
      if (mounted) _safeSnack("Restore failed.");
    }
  }

  void _safeSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final offering = _offerings?.current;
    final packages = (offering?.availablePackages ?? [])
        .where((p) => p.packageType == PackageType.weekly || p.packageType == PackageType.monthly || p.packageType == PackageType.annual)
        .toList();
    final annualPkg = _annualPackage(packages);

    return Scaffold(
      backgroundColor: _bgBase,
      body: Stack(
        children: [
          Positioned.fill(child: Container(color: _bgBase)),
          SafeArea(
            child: _offerings == null
                ? const Center(child: CircularProgressIndicator(color: _primary))
                : _buildContent(context, packages),
          ),
          if (_offerings != null && annualPkg != null) _bottomAnnualCta(annualPkg),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<Package> packages) {
    return RefreshIndicator(
      onRefresh: () async {
        await _fetchOfferings();
        await _fetchToken5();
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
        child: Column(
          children: [
            if (_showClose)
              Align(alignment: Alignment.centerRight, child: IconButton(icon: const Icon(Icons.close, color: Colors.white70), onPressed: () => Navigator.maybePop(context))),
            const SizedBox(height: 16),
            const Icon(Icons.school_rounded, size: 64, color: _primary),
            const SizedBox(height: 16),
            const Text(
              "Study Class Premium",
              textAlign: TextAlign.center,
              style: TextStyle(color: _textPrimary, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Unlimited AI generations, all academic styles, and high-res exports.",
              textAlign: TextAlign.center,
              style: TextStyle(color: _textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 32),
            _feature("Unlimited AI Study Generations"),
            _feature("Access all 28+ Styles (Dark Academia, etc.)"),
            _feature("High-resolution 8K downloads"),
            _feature("Priority processing queue"),
            const SizedBox(height: 32),
            _sectionTitle("Choose your plan"),
            ...packages.map((p) => _planCard(package: p, busy: _busyPkgId == p.identifier, onBuy: () => _buyPackage(p))),
            const SizedBox(height: 24),
            TextButton(onPressed: _restorePurchases, child: const Text("Restore Purchases", style: TextStyle(color: _textSecondary))),
            const SizedBox(height: 8),
             Wrap(
              alignment: WrapAlignment.center,
              spacing: 18,
              children: [
                _linkText("Terms", "https://vibesinterior.com/terms.php"),
                _linkText("Privacy", "https://vibesinterior.com/privacy.php"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _feature(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: _primary, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(color: _textPrimary))),
        ],
      ),
    );
  }

  Widget _planCard({required Package package, required bool busy, required VoidCallback onBuy}) {
    final isAnnual = package.packageType == PackageType.annual;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isAnnual ? _primary.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isAnnual ? _primary : Colors.white24),
      ),
      child: ListTile(
        onTap: busy ? null : onBuy,
        title: Text(package.packageType.toString().split('.').last.toUpperCase(), style: TextStyle(color: _textPrimary, fontWeight: FontWeight.bold)),
        subtitle: Text(package.storeProduct.description, style: TextStyle(color: _textSecondary)),
        trailing: busy
            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
            : Text(package.storeProduct.priceString, style: TextStyle(color: _primary, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }

  Widget _bottomAnnualCta(Package pkg) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _primary, foregroundColor: _bgBase),
            onPressed: _busyPkgId == pkg.identifier ? null : () => _buyPackage(pkg),
            child: const Text("Unlock Premium Now"),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String t) => Align(alignment: Alignment.centerLeft, child: Text(t, style: TextStyle(color: _textPrimary, fontSize: 18, fontWeight: FontWeight.bold)));

  Package? _annualPackage(List<Package> pkgs) {
    try {
      return pkgs.firstWhere((p) => p.packageType == PackageType.annual);
    } catch (_) {
      return null;
    }
  }

  Widget _linkText(String label, String url) {
    return GestureDetector(
      onTap: () async {
        final u = Uri.parse(url);
        if (await canLaunchUrl(u)) await launchUrl(u, mode: LaunchMode.externalApplication);
      },
      child: Text(label, style: const TextStyle(color: _primary, decoration: TextDecoration.underline)),
    );
  }
}
