import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/error_toast.dart';
import '../../services/premium_gate_service.dart';
import '../../services/rooftop_history_repository.dart';
import '../../src/mypaywall.dart';
import '../../src/constant.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final PremiumGateService _premiumGate = PremiumGateService();
  final RooftopHistoryRepository _history = RooftopHistoryRepository();

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
      if (mounted) {
        setState(() {
          _isPremium = premium;
          _developerMode = devMode;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _restorePurchases() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Restoring purchases...')));
      await Purchases.restorePurchases();
      await _loadStatus();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Purchases restored')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to restore')));
    }
  }

  Future<void> _clearHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: DesignTokens.surface,
        title: const Text('Clear History?', style: TextStyle(color: DesignTokens.ink0)),
        content: const Text('This cannot be undone.', style: TextStyle(color: DesignTokens.ink1)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Clear', style: TextStyle(color: DesignTokens.danger))),
        ],
      ),
    );

    if (confirmed == true) {
      await _history.clearHistory();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('History cleared')));
    }
  }

  Future<void> _openPaywall() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CustomCarPaywall(),
        fullscreenDialog: true,
      ),
    );
    await _loadStatus();
  }

  Future<void> _openUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open link')));
    }
  }

  Future<void> _toggleDeveloperMode(bool value) async {
    await setDeveloperMode(value);
    await _loadStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.bg0,
      appBar: AppBar(
        backgroundColor: DesignTokens.bg0,
        title: const Text('Settings', style: TextStyle(color: DesignTokens.ink0)),
        iconTheme: const IconThemeData(color: DesignTokens.ink0),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: DesignTokens.primary))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildPremiumStatusCard(),
                const SizedBox(height: 24),
                _buildAccountActionsCard(),
                const SizedBox(height: 24),
                _buildLegalSection(),
                const SizedBox(height: 24),
                _buildAboutSection(),
                const SizedBox(height: 24),
                _buildDeveloperModeSection(),
                const SizedBox(height: 32),
              ],
            ),
    );
  }

  Widget _buildPremiumStatusCard() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _isPremium ? Icons.workspace_premium : Icons.person_outline,
                color: _isPremium ? DesignTokens.accent : DesignTokens.primary,
                size: 28,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isPremium ? 'Premium Active' : 'Free Account',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(color: DesignTokens.ink0),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isPremium ? 'Unlimited generations' : 'Upgrade to unlock AI',
                      style: const TextStyle(color: DesignTokens.ink1),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (!_isPremium) ...[
            const SizedBox(height: 16),
            GradientButton(
              label: 'Upgrade to Premium',
              icon: Icons.arrow_forward,
              onPressed: _openPaywall,
              size: ButtonSize.large,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAccountActionsCard() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Account', style: TextStyle(color: DesignTokens.ink0, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildActionRow(Icons.restore, 'Restore Purchases', _restorePurchases),
          const SizedBox(height: 8),
          _buildActionRow(Icons.delete_sweep, 'Clear History', _clearHistory, color: DesignTokens.danger),
        ],
      ),
    );
  }

  Widget _buildLegalSection() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Legal', style: TextStyle(color: DesignTokens.ink0, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildActionRow(Icons.privacy_tip, 'Privacy Policy', () => _openUrl('https://example.com/privacy')),
          const SizedBox(height: 8),
          _buildActionRow(Icons.description, 'Terms of Service', () => _openUrl('https://example.com/terms')),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('About', style: TextStyle(color: DesignTokens.ink0, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.apps, 'Version', '1.0.0'),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.email, 'Support', 'support@rooftopai.com'),
          const SizedBox(height: 16),
          const Center(child: Text('© 2026 Rooftop Lounge AI', style: TextStyle(color: DesignTokens.ink1, fontSize: 12))),
        ],
      ),
    );
  }

  Widget _buildDeveloperModeSection() {
    return GlassCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Developer Mode', style: TextStyle(color: DesignTokens.ink0)),
          Switch(
            value: _developerMode,
            onChanged: _toggleDeveloperMode,
            activeColor: DesignTokens.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow(IconData icon, String label, VoidCallback onTap, {Color? color}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(icon, color: color ?? DesignTokens.primary),
            const SizedBox(width: 16),
            Expanded(child: Text(label, style: const TextStyle(color: DesignTokens.ink0))),
            const Icon(Icons.chevron_right, color: DesignTokens.ink1),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: DesignTokens.ink1),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: DesignTokens.ink1, fontSize: 12)),
            Text(value, style: const TextStyle(color: DesignTokens.ink0)),
          ],
        ),
      ],
    );
  }
}
