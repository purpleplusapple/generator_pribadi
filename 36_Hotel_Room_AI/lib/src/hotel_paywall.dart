// lib/src/hotel_paywall.dart
// Hotel Room AI — Premium Paywall
// Option A: Boutique Linen

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hotel_room_ai/src/credits_vault.dart';
import 'package:hotel_room_ai/src/app_assets.dart';
import 'package:hotel_room_ai/src/constant.dart';
import 'package:hotel_room_ai/theme/hotel_room_ai_theme.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class HotelPaywall extends StatefulWidget {
  const HotelPaywall({super.key});

  @override
  State<HotelPaywall> createState() => _HotelPaywallState();
}

class _HotelPaywallState extends State<HotelPaywall> with SingleTickerProviderStateMixin {
  Offerings? _offerings;
  StoreProduct? _token5;
  bool _busyToken = false;
  String? _busyPkgId;

  @override
  void initState() {
    super.initState();
    _fetchOfferings();
    _fetchToken5();
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
      if (mounted) setState(() => _token5 = prods.isNotEmpty ? prods.first : null);
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
      if (mounted && isPro) Navigator.pop(context);
    } catch (e) {
      // Handle error
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
      // Handle error
    } finally {
      if (mounted) setState(() => _busyToken = false);
    }
  }

  Future<void> _restore() async {
    try {
      await Purchases.restorePurchases();
      final isPro = await checkPremiumFresh();
      if (mounted && isPro) Navigator.pop(context);
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HotelAIColors.bg0,
      body: _offerings == null
          ? const Center(child: CircularProgressIndicator(color: HotelAIColors.primary))
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: HotelAIColors.bg0,
                  elevation: 0,
                  pinned: true,
                  leading: IconButton(
                    icon: const Icon(Icons.close, color: HotelAIColors.ink0),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(HotelAISpacing.lg),
                    child: Column(
                      children: [
                        // Header
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: HotelAIColors.primary.withValues(alpha: 0.1),
                          ),
                          child: Icon(Icons.star, size: 48, color: HotelAIColors.primary),
                        ),
                        const SizedBox(height: 16),
                        Text("Unlock Design Studio", style: HotelAIText.h2, textAlign: TextAlign.center),
                        const SizedBox(height: 8),
                        Text(
                          "Get unlimited generations and premium styles for your hotel suites.",
                          style: HotelAIText.body.copyWith(color: HotelAIColors.muted),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 32),

                        // Features
                        _FeatureRow(icon: Icons.check_circle, text: "Unlimited AI Generations"),
                        _FeatureRow(icon: Icons.check_circle, text: "Access all 50+ Luxury Styles"),
                        _FeatureRow(icon: Icons.check_circle, text: "High Resolution Downloads"),
                        _FeatureRow(icon: Icons.check_circle, text: "Priority Rendering Queue"),

                        const SizedBox(height: 32),

                        // Plans
                        if (_offerings?.current != null)
                          ..._offerings!.current!.availablePackages.map((p) => _PlanCard(
                            package: p,
                            isBusy: _busyPkgId == p.identifier,
                            onTap: () => _buyPackage(p),
                          )),

                        const SizedBox(height: 24),

                        if (_token5 != null)
                          _TokenCard(
                            product: _token5!,
                            isBusy: _busyToken,
                            onTap: _buyToken5,
                          ),

                        const SizedBox(height: 24),

                        TextButton(
                          onPressed: _restore,
                          child: Text("Restore Purchases", style: HotelAIText.caption),
                        ),

                        const SizedBox(height: 24),
                        Text(
                          "Subscriptions renew automatically unless cancelled 24h before period ends.",
                          style: HotelAIText.caption.copyWith(fontSize: 10, color: HotelAIColors.muted),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _FeatureRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: HotelAIColors.primary),
          const SizedBox(width: 12),
          Text(text, style: HotelAIText.body),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final Package package;
  final bool isBusy;
  final VoidCallback onTap;

  const _PlanCard({required this.package, required this.isBusy, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isAnnual = package.packageType == PackageType.annual;

    return GestureDetector(
      onTap: isBusy ? null : onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isAnnual ? HotelAIColors.primary : HotelAIColors.bg1,
          borderRadius: HotelAIRadii.mediumRadius,
          border: Border.all(color: HotelAIColors.primary.withValues(alpha: isAnnual ? 0 : 0.2)),
          boxShadow: isAnnual ? HotelAIShadows.floating : HotelAIShadows.soft,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    package.storeProduct.title,
                    style: HotelAIText.bodyMedium.copyWith(
                      color: isAnnual ? Colors.white : HotelAIColors.ink0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    package.storeProduct.description,
                    style: HotelAIText.caption.copyWith(
                      color: isAnnual ? Colors.white70 : HotelAIColors.muted,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (isBusy)
              const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
            else
              Text(
                package.storeProduct.priceString,
                style: HotelAIText.h3.copyWith(
                  color: isAnnual ? Colors.white : HotelAIColors.primary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TokenCard extends StatelessWidget {
  final StoreProduct product;
  final bool isBusy;
  final VoidCallback onTap;

  const _TokenCard({required this.product, required this.isBusy, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HotelAIColors.bg1,
        borderRadius: HotelAIRadii.mediumRadius,
        border: Border.all(color: HotelAIColors.line),
      ),
      child: Row(
        children: [
          Icon(Icons.token, color: HotelAIColors.muted),
          const SizedBox(width: 12),
          Expanded(child: Text("Buy 5 Tokens", style: HotelAIText.bodyMedium)),
          TextButton(
            onPressed: isBusy ? null : onTap,
            child: isBusy ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : Text(product.priceString),
          ),
        ],
      ),
    );
  }
}
