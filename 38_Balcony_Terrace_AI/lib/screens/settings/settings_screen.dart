import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/design_tokens.dart';
import '../../theme/terrace_theme.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_button.dart';
import '../../services/premium_gate_service.dart';
import '../../services/terrace_history_repository.dart';
import '../../src/mypaywall.dart';
import '../../src/constant.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final PremiumGateService _premiumGate = PremiumGateService();
  final TerraceHistoryRepository _history = TerraceHistoryRepository();

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
      _showSnack('Restoring purchases...');
      await Purchases.restorePurchases();
      await _loadStatus();
      if (mounted) {
        _showSnack('Purchases restored successfully!', isError: false);
      }
    } catch (e) {
      if (mounted) {
        _showSnack('Failed to restore purchases', isError: true);
      }
    }
  }

  Future<void> _clearHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: DesignTokens.surface,
        title: Text(
          'Clear All History?',
          style: terraceTheme.textTheme.titleLarge?.copyWith(color: DesignTokens.ink0),
        ),
        content: const Text(
          'This will permanently delete all saved redesigns. This action cannot be undone.',
          style: TextStyle(color: DesignTokens.ink1),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: DesignTokens.danger,
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
          _showSnack('History cleared', isError: false);
        }
      } catch (e) {
        if (mounted) {
          _showSnack('Failed to clear history', isError: true);
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
        _showSnack('Could not open link', isError: true);
      }
    }
  }

  Future<void> _toggleDeveloperMode(bool value) async {
    try {
      await setDeveloperMode(value);
      await _loadStatus();
      if (mounted) {
        _showSnack(
          value
              ? 'Developer Mode Enabled'
              : 'Developer Mode Disabled',
          isError: false,
        );
      }
    } catch (e) {
      if (mounted) {
        _showSnack('Failed to toggle developer mode', isError: true);
      }
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: TextStyle(color: isError ? DesignTokens.ink0 : DesignTokens.bg0)),
        backgroundColor: isError ? DesignTokens.danger : DesignTokens.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.bg0,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: DesignTokens.primary),
            )
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
                const SizedBox(height: 48),
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
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isPremium ? 'Premium Active' : 'Free Account',
                      style: terraceTheme.textTheme.titleMedium?.copyWith(color: DesignTokens.ink0),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isPremium
                          ? 'Unlimited AI generations'
                          : 'Upgrade to unlock AI generation',
                      style: const TextStyle(color: DesignTokens.muted, fontSize: 12),
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
          Text('Account', style: terraceTheme.textTheme.titleMedium?.copyWith(color: DesignTokens.ink0)),
          const SizedBox(height: 16),
          _buildActionRow(
            icon: Icons.restore,
            label: 'Restore Purchases',
            onTap: _restorePurchases,
          ),
          const SizedBox(height: 12),
          _buildActionRow(
            icon: Icons.delete_sweep,
            label: 'Clear History',
            onTap: _clearHistory,
            iconColor: DesignTokens.danger,
          ),
        ],
      ),
    );
  }

  Widget _buildLegalSection() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Legal', style: terraceTheme.textTheme.titleMedium?.copyWith(color: DesignTokens.ink0)),
          const SizedBox(height: 16),
          _buildActionRow(
            icon: Icons.privacy_tip_outlined,
            label: 'Privacy Policy',
            onTap: () => _openUrl('https://vibesinterior.com/privacy.php'),
          ),
          const SizedBox(height: 12),
          _buildActionRow(
            icon: Icons.description_outlined,
            label: 'Terms of Service',
            onTap: () => _openUrl('https://vibesinterior.com/terms.php'),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('About', style: terraceTheme.textTheme.titleMedium?.copyWith(color: DesignTokens.ink0)),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.apps, 'App Version', '1.0.0'),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.email_outlined, 'Support', 'support@balconyterrace.ai'),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              '© 2026 Balcony Terrace AI\nTransform your space',
              style: TextStyle(color: DesignTokens.muted, fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? DesignTokens.primary, size: 24),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: const TextStyle(color: DesignTokens.ink1))),
            const Icon(Icons.chevron_right, color: DesignTokens.muted, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: DesignTokens.accent, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: DesignTokens.muted, fontSize: 10)),
              Text(value, style: const TextStyle(color: DesignTokens.ink1)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeveloperModeSection() {
    return GlassCard(
      child: Row(
        children: [
          const Icon(Icons.developer_mode, color: DesignTokens.muted),
          const SizedBox(width: 12),
          const Expanded(
            child: Text('Developer Mode', style: TextStyle(color: DesignTokens.ink1)),
          ),
          Switch(
            value: _developerMode,
            onChanged: _toggleDeveloperMode,
            activeColor: DesignTokens.primary,
          ),
        ],
      ),
    );
  }
}
