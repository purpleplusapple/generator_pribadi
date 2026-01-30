// lib/screens/settings/settings_screen.dart
// Settings screen for Barbershop AI

import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/barber_theme.dart';
import '../../services/premium_gate_service.dart';
import '../../services/barber_history_repository.dart';
import '../../src/mypaywall.dart';
import '../../src/constant.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final PremiumGateService _premiumGate = PremiumGateService();
  final BarberHistoryRepository _history = BarberHistoryRepository();

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
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _restorePurchases() async {
    try {
      await Purchases.restorePurchases();
      await _loadStatus();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Purchases restored successfully!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to restore purchases')));
      }
    }
  }

  Future<void> _clearHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: BarberTheme.surface,
        title: Text('Clear All History?', style: BarberTheme.themeData.textTheme.titleLarge),
        content: Text('This will permanently delete all saved designs.', style: BarberTheme.themeData.textTheme.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: BarberTheme.danger),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _history.clearHistory();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('History cleared')));
      }
    }
  }

  Future<void> _openPaywall() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const BarberPaywall(),
        fullscreenDialog: true,
      ),
    );
    await _loadStatus();
  }

  Future<void> _toggleDeveloperMode(bool value) async {
    await setDeveloperMode(value);
    await _loadStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BarberTheme.bg0,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: BarberTheme.bg0,
        titleTextStyle: BarberTheme.themeData.textTheme.titleLarge,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: BarberTheme.primary))
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                _buildPremiumCard(),
                const SizedBox(height: 24),
                _buildSection("Account", [
                  _SettingsTile(
                    icon: Icons.restore,
                    title: "Restore Purchases",
                    onTap: _restorePurchases,
                  ),
                  _SettingsTile(
                    icon: Icons.delete_outline,
                    title: "Clear History",
                    onTap: _clearHistory,
                    isDestructive: true,
                  ),
                ]),
                const SizedBox(height: 24),
                _buildSection("Legal", [
                  _SettingsTile(
                    icon: Icons.privacy_tip_outlined,
                    title: "Privacy Policy",
                    onTap: () {}, // Add URL launch
                  ),
                  _SettingsTile(
                    icon: Icons.description_outlined,
                    title: "Terms of Service",
                    onTap: () {},
                  ),
                ]),
                 const SizedBox(height: 24),
                _buildSection("Developer", [
                  SwitchListTile(
                    title: const Text("Developer Mode", style: TextStyle(color: BarberTheme.ink0)),
                    subtitle: const Text("Bypass premium checks", style: TextStyle(color: BarberTheme.muted, fontSize: 12)),
                    value: _developerMode,
                    activeColor: BarberTheme.primary,
                    onChanged: _toggleDeveloperMode,
                  ),
                ]),
              ],
            ),
    );
  }

  Widget _buildPremiumCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [BarberTheme.primary.withOpacity(0.2), BarberTheme.surface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BarberTheme.primary.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(_isPremium ? Icons.verified : Icons.star_border, color: BarberTheme.primary, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isPremium ? "Premium Active" : "Free Plan",
                      style: const TextStyle(color: BarberTheme.ink0, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      _isPremium ? "You have full access" : "Upgrade to unlock all styles",
                      style: const TextStyle(color: BarberTheme.muted, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (!_isPremium) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _openPaywall,
                child: const Text("Upgrade Now"),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: BarberTheme.themeData.textTheme.titleMedium),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: BarberTheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SettingsTile({required this.icon, required this.title, required this.onTap, this.isDestructive = false});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: isDestructive ? BarberTheme.danger : BarberTheme.primary),
      title: Text(title, style: TextStyle(color: isDestructive ? BarberTheme.danger : BarberTheme.ink0)),
      trailing: const Icon(Icons.chevron_right, color: BarberTheme.muted),
      onTap: onTap,
    );
  }
}
