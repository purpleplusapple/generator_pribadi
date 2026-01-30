// ============================
// lib/src/mypaywall.dart
// Barbershop AI — Premium Paywall (RevenueCat)
// ============================

import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:barbershop_ai/src/credits_vault.dart';
import 'package:barbershop_ai/src/app_assets.dart';
import 'package:barbershop_ai/src/constant.dart'
    show
        markJustPurchased,
        checkPremiumFresh,
        premiumListenable,
        entitlementKey,
        kToken5ProductId;
import 'package:barbershop_ai/theme/barber_theme.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

const _bgBase = BarberTheme.bg0;
const _bgOverlay = BarberTheme.surface;
const _primary = BarberTheme.primary;
const _primarySoft = BarberTheme.primarySoft;
const _accent = BarberTheme.accentRed;

const _textPrimary = BarberTheme.ink0;
const _textSecondary = BarberTheme.muted;

class BarberPaywall extends StatefulWidget {
  const BarberPaywall({super.key});

  @override
  State<BarberPaywall> createState() => _BarberPaywallState();
}

class _BarberPaywallState extends State<BarberPaywall>
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

    // Delay close button appearance
    Timer(const Duration(seconds: 5), () {
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

    // Auto-close if premium becomes active
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
        _safeSnack("You have unlocked Barbershop AI Premium.");
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

    return Scaffold(
      backgroundColor: _bgBase,
      body: Stack(
        children: [
          // Content
          SafeArea(
            child: _offerings == null
                ? const Center(
                    child: CircularProgressIndicator(color: _primary),
                  )
                : _buildContent(context, packages),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<Package> packages) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           // Close button (delayed)
            if (_showClose)
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Navigator.maybePop(context),
                ),
              )
            else
               const SizedBox(height: 48),

            const SizedBox(height: 16),

            // Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: _primary.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(AppAssets.appIcon, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Barbershop AI Premium",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'Playfair Display',
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Unlock unlimited designs, all 30+ styles, and high-resolution exports.",
              textAlign: TextAlign.center,
              style: TextStyle(color: _textSecondary, fontSize: 16),
            ),

            const SizedBox(height: 32),
            _feature("Unlimited AI Generations"),
            _feature("Access all 30+ Premium Styles"),
            _feature("Remove Watermarks"),
            _feature("High-Res 4K Downloads"),

            const SizedBox(height: 40),

            if (packages.isEmpty)
              const Text("No plans available.", style: TextStyle(color: _textSecondary))
            else
              ...packages.map((p) => _planCard(p, _busyPkgId == p.identifier, () => _buyPackage(p))),

             const SizedBox(height: 24),
             TextButton(
               onPressed: _restorePurchases,
               child: const Text("Restore Purchases", style: TextStyle(color: _textSecondary)),
             ),

             const SizedBox(height: 16),
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 _linkText("Terms", "https://barbershopai.com/terms"),
                 const SizedBox(width: 16),
                 _linkText("Privacy", "https://barbershopai.com/privacy"),
               ],
             ),
        ],
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
          Text(text, style: const TextStyle(color: _textPrimary, fontSize: 14)),
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
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isAnnual ? _primary.withOpacity(0.1) : BarberTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isAnnual ? _primary : BarberTheme.line, width: isAnnual ? 2 : 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.storeProduct.title,
                    style: const TextStyle(color: _textPrimary, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    p.storeProduct.description,
                    style: const TextStyle(color: _textSecondary, fontSize: 12),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (busy)
              const CircularProgressIndicator()
            else
              Text(
                p.storeProduct.priceString,
                style: const TextStyle(color: _primary, fontWeight: FontWeight.bold, fontSize: 18),
              ),
          ],
        ),
      ),
    );
  }

  Widget _linkText(String label, String url) {
    return GestureDetector(
      onTap: () async {
        final u = Uri.parse(url);
        if (await canLaunchUrl(u)) await launchUrl(u);
      },
      child: Text(label, style: const TextStyle(color: _textSecondary, decoration: TextDecoration.underline)),
    );
  }

  void _safeSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
