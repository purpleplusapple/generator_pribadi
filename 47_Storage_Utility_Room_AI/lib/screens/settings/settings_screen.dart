// lib/screens/settings/settings_screen.dart
// Settings screen with app info and account management

import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/storage_theme.dart';
import '../../widgets/glass_card.dart'; // Will likely fail if not converted, I'll inline a card or use standard Card
// import '../../widgets/gradient_button.dart'; // Inline button
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
      ErrorToast.showInfo(context, 'Restoring purchases...');
      await Purchases.restorePurchases();
      await _loadStatus();
      if (mounted) {
        ErrorToast.showSuccess(context, 'Purchases restored successfully!');
      }
    } catch (e) {
      if (mounted) {
        ErrorToast.show(context, 'Failed to restore purchases');
      }
    }
  }

  Future<void> _clearHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: StorageColors.bg1,
        title: Text('Clear All History?', style: StorageTheme.darkTheme.textTheme.headlineSmall),
        content: const Text(
          'This will permanently delete all saved redesigns. This action cannot be undone.',
          style: TextStyle(color: StorageColors.ink1),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel', style: TextStyle(color: StorageColors.muted)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: StorageColors.danger,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _history.clearHistory();
        if (mounted) {
          ErrorToast.showSuccess(context, 'History cleared');
        }
      } catch (e) {
        if (mounted) {
          ErrorToast.show(context, 'Failed to clear history');
        }
      }
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
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ErrorToast.show(context, 'Could not open link');
      }
    }
  }

  Future<void> _toggleDeveloperMode(bool value) async {
    try {
      await setDeveloperMode(value);
      await _loadStatus();
      if (mounted) {
        ErrorToast.showSuccess(
          context,
          value
              ? 'Developer Mode Enabled'
              : 'Developer Mode Disabled',
        );
      }
    } catch (e) {
      if (mounted) {
        ErrorToast.show(context, 'Failed to toggle developer mode');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StorageColors.bg0,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Settings', style: StorageTheme.darkTheme.textTheme.headlineMedium),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: StorageColors.primaryLime))
          : ListView(
              padding: const EdgeInsets.all(20),
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
                const SizedBox(height: 100),
              ],
            ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: StorageColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: StorageColors.line),
      ),
      child: child,
    );
  }

  Widget _buildPremiumStatusCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _isPremium ? Icons.verified_user_rounded : Icons.person_outline_rounded,
                color: _isPremium ? StorageColors.primaryLime : StorageColors.muted,
                size: 28,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isPremium ? 'Pro Account Active' : 'Free Account',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: StorageColors.ink0),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isPremium
                          ? 'Unlimited generations & advanced styles'
                          : 'Upgrade to unlock Pro styles',
                      style: const TextStyle(fontSize: 12, color: StorageColors.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (!_isPremium) ...[
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _openPaywall,
                style: ElevatedButton.styleFrom(
                  backgroundColor: StorageColors.primaryLime,
                  foregroundColor: Colors.black,
                ),
                child: const Text('Upgrade to Pro'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAccountActionsCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Account', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: StorageColors.ink0)),
          const SizedBox(height: 16),
          _buildActionRow(Icons.restore_rounded, 'Restore Purchases', _restorePurchases),
          const Divider(color: StorageColors.line),
          _buildActionRow(Icons.delete_sweep_rounded, 'Clear History', _clearHistory, color: StorageColors.danger),
        ],
      ),
    );
  }

  Widget _buildLegalSection() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Legal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: StorageColors.ink0)),
          const SizedBox(height: 16),
          _buildActionRow(Icons.privacy_tip_outlined, 'Privacy Policy', () => _openUrl('https://vibesinterior.com/privacy.php')),
          const Divider(color: StorageColors.line),
          _buildActionRow(Icons.description_outlined, 'Terms of Service', () => _openUrl('https://vibesinterior.com/terms.php')),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('About', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: StorageColors.ink0)),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.apps_rounded, 'App Version', '1.0.0'),
          const Divider(color: StorageColors.line),
          _buildInfoRow(Icons.email_outlined, 'Support', 'support@vibesinterior.com'),
          const SizedBox(height: 16),
          const Center(
             child: Text('© 2026 Storage Utility AI', style: TextStyle(fontSize: 10, color: StorageColors.muted)),
          ),
        ],
      ),
    );
  }

  Widget _buildDeveloperModeSection() {
    return _buildCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Developer Mode', style: TextStyle(color: StorageColors.muted)),
          Switch(
            value: _developerMode,
            onChanged: _toggleDeveloperMode,
            activeColor: StorageColors.primaryLime,
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow(IconData icon, String label, VoidCallback onTap, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? StorageColors.ink0),
      title: Text(label, style: TextStyle(color: color ?? StorageColors.ink0)),
      trailing: const Icon(Icons.chevron_right, color: StorageColors.muted),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: StorageColors.muted, size: 20),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: StorageColors.muted)),
          const Spacer(),
          Text(value, style: const TextStyle(color: StorageColors.ink0, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
