// lib/screens/settings/settings_screen.dart
// Settings screen

import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/boutique_theme.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/error_toast.dart';
import '../../services/premium_gate_service.dart';
import '../../services/laundry_history_repository.dart';
import '../../src/mypaywall.dart';
import '../../src/constant.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final PremiumGateService _premiumGate = PremiumGateService();
  final LaundryHistoryRepository _history = LaundryHistoryRepository();

  bool _isPremium = false;
  bool _isLoading = true;
  bool _developerMode = false;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    setState(() => _isLoading = true);
    try {
      final premium = await _premiumGate.hasPremium();
      final devMode = await isDeveloperModeEnabled();
      if (mounted) setState(() { _isPremium = premium; _developerMode = devMode; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _restorePurchases() async {
    try {
      await Purchases.restorePurchases();
      await _loadStatus();
      if (mounted) ErrorToast.showSuccess(context, 'Purchases restored');
    } catch (e) {
      if (mounted) ErrorToast.show(context, 'Failed to restore');
    }
  }

  Future<void> _clearHistory() async {
    // Show confirmation...
    try {
      await _history.clearHistory();
      if (mounted) ErrorToast.showSuccess(context, 'History cleared');
    } catch (e) {
      // ignore
    }
  }

  Future<void> _toggleDeveloperMode(bool value) async {
    await setDeveloperMode(value);
    await _loadStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BoutiqueColors.bg0,
      appBar: AppBar(title: Text('Settings', style: BoutiqueText.h3)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: BoutiqueColors.primary))
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildPremiumCard(),
                const SizedBox(height: 24),
                _buildSection("Account", [
                  _action("Restore Purchases", Icons.restore, _restorePurchases),
                  _action("Clear History", Icons.delete_outline, _clearHistory, color: BoutiqueColors.danger),
                ]),
                const SizedBox(height: 24),
                _buildSection("App", [
                  _info("Version", "1.0.0"),
                  _info("Support", "support@retailboutique.ai"),
                ]),
                const SizedBox(height: 24),
                _buildDevMode(),
              ],
            ),
    );
  }

  Widget _buildPremiumCard() {
    return GlassCard(
      child: Column(
        children: [
          Row(children: [
            Icon(Icons.workspace_premium, color: _isPremium ? BoutiqueColors.success : BoutiqueColors.primary, size: 32),
            const SizedBox(width: 16),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(_isPremium ? "Premium Active" : "Free Plan", style: BoutiqueText.h3),
              Text(_isPremium ? "Unlimited Access" : "Limited Generations", style: BoutiqueText.caption),
            ]),
          ]),
          if (!_isPremium) ...[
            const SizedBox(height: 16),
            GradientButton(
              label: "UPGRADE TO PREMIUM",
              onPressed: () async {
                 await Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomCarPaywall(), fullscreenDialog: true));
                 _loadStatus();
              },
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: BoutiqueText.h3.copyWith(fontSize: 16, color: BoutiqueColors.muted)),
        const SizedBox(height: 8),
        GlassCard(child: Column(children: children)),
      ],
    );
  }

  Widget _action(String label, IconData icon, VoidCallback onTap, {Color? color}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: color ?? BoutiqueColors.ink1),
            const SizedBox(width: 16),
            Expanded(child: Text(label, style: BoutiqueText.bodyMedium.copyWith(color: color ?? BoutiqueColors.ink0))),
            const Icon(Icons.chevron_right, color: BoutiqueColors.muted),
          ],
        ),
      ),
    );
  }

  Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: BoutiqueText.bodyMedium.copyWith(color: BoutiqueColors.ink1)),
          Text(value, style: BoutiqueText.bodyMedium.copyWith(color: BoutiqueColors.ink0, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDevMode() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Developer Mode", style: BoutiqueText.caption),
        Switch(
          value: _developerMode,
          onChanged: _toggleDeveloperMode,
          activeColor: BoutiqueColors.primary,
        ),
      ],
    );
  }
}
