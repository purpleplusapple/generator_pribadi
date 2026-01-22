// ============================
// lib/src/mypaywall.dart
// Retail Store Boutique AI — Premium Paywall (RevenueCat)
// ============================

import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:retail_store_boutique_ai/src/credits_vault.dart';
import 'package:retail_store_boutique_ai/src/app_assets.dart';
import 'package:retail_store_boutique_ai/src/constant.dart'
    show
        markJustPurchased,
        checkPremiumFresh,
        premiumListenable,
        entitlementKey,
        kToken5ProductId;
import 'package:retail_store_boutique_ai/theme/boutique_theme.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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
      if (mounted && isPro && Navigator.canPop(context)) Navigator.pop(context);
    } catch (e) {
      //
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
    } catch (e) {
      //
    } finally {
      if (mounted) setState(() => _busyToken = false);
    }
  }

  Future<void> _restorePurchases() async {
    try {
      await Purchases.restorePurchases();
      final isPro = await checkPremiumFresh();
      if (mounted && isPro && Navigator.canPop(context)) Navigator.pop(context);
    } catch (e) {
      //
    }
  }

  @override
  Widget build(BuildContext context) {
    final offering = _offerings?.current;
    final packages = (offering?.availablePackages ?? []).toList();

    return Scaffold(
      backgroundColor: BoutiqueColors.bg0,
      body: Stack(
        children: [
          Positioned.fill(child: Container(decoration: const BoxDecoration(gradient: BoutiqueGradients.background))),
          SafeArea(
            child: _offerings == null
                ? const Center(child: CircularProgressIndicator(color: BoutiqueColors.primary))
                : SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                    child: Column(
                      children: [
                        if (_showClose)
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: const Icon(CupertinoIcons.xmark_circle_fill, color: Colors.white70),
                              onPressed: () => Navigator.maybePop(context),
                            ),
                          ),
                        const SizedBox(height: 20),
                        Container(
                          width: 80, height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: BoutiqueShadows.goldGlow(opacity: 0.3),
                          ),
                          child: ClipRRect(borderRadius: BorderRadius.circular(20), child: Image.asset(AppAssets.appIcon)),
                        ),
                        const SizedBox(height: 16),
                        Text("Boutique AI Premium", style: BoutiqueText.h2),
                        const SizedBox(height: 8),
                        Text("Unlimited high-end retail designs, priority rendering, and full history.", textAlign: TextAlign.center, style: BoutiqueText.body.copyWith(color: BoutiqueColors.muted)),
                        const SizedBox(height: 32),
                        ...packages.map((p) => _planCard(p, _busyPkgId == p.identifier, () => _buyPackage(p))),
                        const SizedBox(height: 24),
                        if (_token5 != null)
                           _tokenCard("5 Extra Design Tokens", "Use when you need more renders.", _token5!.priceString, _busyToken, _buyToken5),
                        const SizedBox(height: 24),
                        TextButton(onPressed: _restorePurchases, child: const Text("Restore Purchases")),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _planCard(Package p, bool busy, VoidCallback onTap) {
    final isAnnual = p.packageType == PackageType.annual;
    return GestureDetector(
      onTap: busy ? null : onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isAnnual ? BoutiqueColors.primary.withValues(alpha: 0.1) : BoutiqueColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isAnnual ? BoutiqueColors.primary : BoutiqueColors.line),
        ),
        child: Row(
          children: [
             Expanded(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(p.storeProduct.title, style: BoutiqueText.h3.copyWith(fontSize: 16)),
                   Text(p.storeProduct.description, style: BoutiqueText.caption),
                 ],
               ),
             ),
             if (busy) const CircularProgressIndicator() else Text(p.storeProduct.priceString, style: BoutiqueText.h3.copyWith(color: BoutiqueColors.primary)),
          ],
        ),
      ),
    );
  }

  Widget _tokenCard(String title, String desc, String price, bool busy, VoidCallback onTap) {
    return GestureDetector(
      onTap: busy ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: BoutiqueColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: BoutiqueColors.line),
        ),
        child: Row(
          children: [
             Expanded(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(title, style: BoutiqueText.h3.copyWith(fontSize: 16)),
                   Text(desc, style: BoutiqueText.caption),
                 ],
               ),
             ),
             if (busy) const CircularProgressIndicator() else Text(price, style: BoutiqueText.h3.copyWith(color: BoutiqueColors.primary)),
          ],
        ),
      ),
    );
  }
}
