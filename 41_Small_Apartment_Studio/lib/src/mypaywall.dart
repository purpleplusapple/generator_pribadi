// lib/src/mypaywall.dart
import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/app_theme.dart';
import 'credits_vault.dart';
import 'constant.dart' show markJustPurchased, checkPremiumFresh, premiumListenable, entitlementKey, kToken5ProductId;

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
    Timer(const Duration(seconds: 10), () {
      if (mounted) setState(() => _showClose = true);
    });
    _ctaPulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))..repeat(reverse: true);
    _ctaCurve = CurvedAnimation(parent: _ctaPulse, curve: Curves.easeInOut);
    Purchases.addCustomerInfoUpdateListener((_) async {
      final isPro = await checkPremiumFresh();
      if (!mounted) return;
      if (isPro && Navigator.canPop(context)) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Premium activated.")));
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
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Welcome to Small Apartment Studio AI Premium!")));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Purchase cancelled or failed.")));
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("5 extra tokens added.")));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Token purchase failed.")));
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isPro ? "Premium restored!" : "No subscription found.")));
      if (isPro && Navigator.canPop(context)) Navigator.pop(context);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Restore failed.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final offering = _offerings?.current;
    final packages = (offering?.availablePackages ?? []).toList();
    final annualPkg = packages.where((p) => p.packageType == PackageType.annual).firstOrNull;

    return Scaffold(
      backgroundColor: DesignTokens.bg0,
      body: Stack(
        children: [
          Positioned.fill(child: Container(color: DesignTokens.bg0)),
          SafeArea(
            child: _offerings == null
                ? const Center(child: CircularProgressIndicator(color: DesignTokens.primary))
                : _buildContent(context, packages),
          ),
          if (annualPkg != null) _bottomAnnualCta(annualPkg),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<Package> packages) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
      child: Column(
        children: [
          if (_showClose)
            Align(alignment: Alignment.centerRight, child: IconButton(icon: const Icon(Icons.close, color: DesignTokens.ink1), onPressed: () => Navigator.maybePop(context))),
          const SizedBox(height: 20),
          const Icon(Icons.nightlife, size: 60, color: DesignTokens.primary),
          const SizedBox(height: 16),
          const Text("Small Apartment Studio AI Premium", style: TextStyle(color: DesignTokens.ink0, fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 8),
          const Text("Unlock unlimited luxury designs, 4K exports, and all exclusive styles.", style: TextStyle(color: DesignTokens.ink1), textAlign: TextAlign.center),
          const SizedBox(height: 32),
          _sectionTitle("Why Upgrade?"),
          _feature("Unlimited AI generations"),
          _feature("Access all 50+ luxury styles"),
          _feature("High-resolution downloads"),
          _feature("Priority processing"),
          const SizedBox(height: 32),
          if (packages.isEmpty)
            const Text("No plans available", style: TextStyle(color: DesignTokens.ink1))
          else
            ...packages.map((p) => _planCard(p)),
          const SizedBox(height: 32),
          TextButton(onPressed: _restorePurchases, child: const Text("Restore Purchases", style: TextStyle(color: DesignTokens.ink1))),
          const SizedBox(height: 16),
          Wrap(
            spacing: 20,
            children: [
              _linkText("Terms", "https://example.com/terms"),
              _linkText("Privacy", "https://example.com/privacy"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bottomAnnualCta(Package pkg) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: DesignTokens.primary,
              foregroundColor: DesignTokens.bg0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: () => _buyPackage(pkg),
            child: const Text("Start Annual Plan", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Align(alignment: Alignment.centerLeft, child: Text(text, style: const TextStyle(color: DesignTokens.ink0, fontSize: 18, fontWeight: FontWeight.bold))),
    );
  }

  Widget _feature(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: DesignTokens.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(color: DesignTokens.ink1))),
        ],
      ),
    );
  }

  Widget _planCard(Package pkg) {
    final isBusy = _busyPkgId == pkg.identifier;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DesignTokens.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: DesignTokens.line),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pkg.storeProduct.title, style: const TextStyle(color: DesignTokens.ink0, fontWeight: FontWeight.bold)),
                Text(pkg.storeProduct.description, style: const TextStyle(color: DesignTokens.ink1, fontSize: 12)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: isBusy ? null : () => _buyPackage(pkg),
            style: ElevatedButton.styleFrom(backgroundColor: DesignTokens.primary, foregroundColor: DesignTokens.bg0),
            child: isBusy ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: DesignTokens.bg0, strokeWidth: 2)) : Text(pkg.storeProduct.priceString),
          ),
        ],
      ),
    );
  }

  Widget _linkText(String label, String url) {
    return GestureDetector(
      onTap: () => launchUrl(Uri.parse(url)),
      child: Text(label, style: const TextStyle(color: DesignTokens.ink1, decoration: TextDecoration.underline)),
    );
  }
}
