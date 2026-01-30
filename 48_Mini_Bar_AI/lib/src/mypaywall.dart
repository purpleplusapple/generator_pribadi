// lib/src/mypaywall.dart
import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_bar_ai/src/credits_vault.dart';
import 'package:mini_bar_ai/src/app_assets.dart';
import 'package:mini_bar_ai/src/constant.dart'
    show
        markJustPurchased,
        checkPremiumFresh,
        premiumListenable,
        entitlementKey,
        kToken5ProductId;
import 'package:mini_bar_ai/theme/design_tokens.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomCarPaywall extends StatefulWidget {
  const CustomCarPaywall({super.key});

  @override
  State<CustomCarPaywall> createState() => _CustomCarPaywallState();
}

class _CustomCarPaywallState extends State<CustomCarPaywall> {
  Offerings? _offerings;
  StoreProduct? _token5;
  bool _showClose = false;
  String? _busyPkgId;

  @override
  void initState() {
    super.initState();
    _fetchOfferings();
    Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showClose = true);
    });
  }

  Future<void> _fetchOfferings() async {
    try {
      final offerings = await Purchases.getOfferings();
      if (mounted) setState(() => _offerings = offerings);
    } catch (e) {
      debugPrint("Error fetching offerings: $e");
    }
  }

  Future<void> _buyPackage(Package pkg) async {
    if (_busyPkgId != null) return;
    setState(() => _busyPkgId = pkg.identifier);
    try {
      await Purchases.purchasePackage(pkg);
      await markJustPurchased();
      if (mounted) Navigator.pop(context);
    } catch (e) {
      debugPrint("Purchase failed: $e");
    } finally {
      if (mounted) setState(() => _busyPkgId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MiniBarColors.bg0,
      body: Stack(
        children: [
          // Background
          Positioned(
            top: -100, right: -100,
            child: Container(
              width: 400, height: 400,
              decoration: BoxDecoration(color: MiniBarColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle, boxShadow: const [BoxShadow(blurRadius: 100, color: MiniBarColors.primarySoft)]),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                if (_showClose)
                  Align(alignment: Alignment.topRight, child: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context))),
                const SizedBox(height: 20),
                Text('Mini Bar AI Premium', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: MiniBarColors.ink0)),
                const SizedBox(height: 10),
                Text('Unlimited Lounge Designs', style: TextStyle(color: MiniBarColors.muted)),
                const Spacer(),
                if (_offerings != null && _offerings!.current != null)
                  ..._offerings!.current!.availablePackages.map((p) =>
                    ListTile(
                      title: Text(p.storeProduct.title, style: TextStyle(color: MiniBarColors.ink0)),
                      subtitle: Text(p.storeProduct.description, style: TextStyle(color: MiniBarColors.muted)),
                      trailing: ElevatedButton(
                        onPressed: _busyPkgId == null ? () => _buyPackage(p) : null,
                        child: Text(p.storeProduct.priceString),
                      ),
                    )
                  )
                else
                   const CircularProgressIndicator(),
                const Spacer(),
                TextButton(onPressed: () => Purchases.restorePurchases(), child: const Text('Restore Purchases')),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
