// lib/screens/settings/settings_screen.dart
// Settings screen with app info and account management

import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/clinic_theme.dart';
import '../../widgets/clinical_card.dart';
import '../../widgets/primary_button.dart';
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
        backgroundColor: Colors.white,
        title: Text('Clear All History?', style: ClinicText.h3),
        content: Text(
          'This will permanently delete all saved redesigns. This action cannot be undone.',
          style: ClinicText.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: ClinicColors.danger),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _history.clearHistory();
        if (mounted) ErrorToast.showSuccess(context, 'History cleared');
      } catch (e) {
        if (mounted) ErrorToast.show(context, 'Failed to clear history');
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
      if (mounted) ErrorToast.show(context, 'Could not open link');
    }
  }

  Future<void> _toggleDeveloperMode(bool value) async {
    try {
      await setDeveloperMode(value);
      await _loadStatus();
      if (mounted) {
        ErrorToast.showSuccess(
          context,
          value ? 'Developer Mode Enabled' : 'Developer Mode Disabled',
        );
      }
    } catch (e) {
      if (mounted) ErrorToast.show(context, 'Failed to toggle developer mode');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ClinicColors.bg0,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: ClinicColors.bg0,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(ClinicSpacing.base),
              children: [
                _buildPremiumStatusCard(),
                const SizedBox(height: ClinicSpacing.lg),
                _buildAccountActionsCard(),
                const SizedBox(height: ClinicSpacing.lg),
                _buildLegalSection(),
                const SizedBox(height: ClinicSpacing.lg),
                _buildAboutSection(),
                const SizedBox(height: ClinicSpacing.lg),
                _buildDeveloperModeSection(),
                const SizedBox(height: ClinicSpacing.xxl),
              ],
            ),
    );
  }

  Widget _buildPremiumStatusCard() {
    return ClinicalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _isPremium ? Icons.verified_user : Icons.person_outline_rounded,
                color: _isPremium ? ClinicColors.primary : ClinicColors.ink1,
                size: 28,
              ),
              const SizedBox(width: ClinicSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isPremium ? 'Clinic Pro Active' : 'Free Account',
                      style: ClinicText.h3.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isPremium
                          ? 'Unlimited designs & High-Res downloads'
                          : 'Upgrade to unlock professional features',
                      style: ClinicText.caption,
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (!_isPremium) ...[
            const SizedBox(height: ClinicSpacing.lg),
            PrimaryButton(
              label: 'Upgrade to Pro',
              icon: Icons.arrow_forward_rounded,
              onPressed: _openPaywall,
              size: ButtonSize.standard,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAccountActionsCard() {
    return ClinicalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Account', style: ClinicText.h3.copyWith(fontSize: 18)),
          const SizedBox(height: ClinicSpacing.lg),
          _buildActionRow(
            icon: Icons.restore_rounded,
            label: 'Restore Purchases',
            onTap: _restorePurchases,
          ),
          const SizedBox(height: ClinicSpacing.md),
          _buildActionRow(
            icon: Icons.delete_sweep_rounded,
            label: 'Clear History',
            onTap: _clearHistory,
            iconColor: ClinicColors.danger,
          ),
        ],
      ),
    );
  }

  Widget _buildLegalSection() {
    return ClinicalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Legal', style: ClinicText.h3.copyWith(fontSize: 18)),
          const SizedBox(height: ClinicSpacing.lg),
          _buildActionRow(
            icon: Icons.privacy_tip_outlined,
            label: 'Privacy Policy',
            onTap: () => _openUrl('https://vibesinterior.com/privacy.php'),
          ),
          const SizedBox(height: ClinicSpacing.md),
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
    return ClinicalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('About', style: ClinicText.h3.copyWith(fontSize: 18)),
          const SizedBox(height: ClinicSpacing.lg),
          _buildInfoRow(
            icon: Icons.apps_rounded,
            label: 'App Version',
            value: '1.0.0',
          ),
          const SizedBox(height: ClinicSpacing.md),
          _buildInfoRow(
            icon: Icons.email_outlined,
            label: 'Support',
            value: 'support@clinicroomai.com',
          ),
          const SizedBox(height: ClinicSpacing.md),
          Center(
            child: Text(
              '© 2026 Clinic Room AI\nMedical Space Design Intelligence',
              style: ClinicText.caption.copyWith(color: ClinicColors.ink2),
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
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? ClinicColors.primary, size: 24),
            const SizedBox(width: ClinicSpacing.md),
            Expanded(child: Text(label, style: ClinicText.bodyMedium)),
            Icon(Icons.chevron_right_rounded, color: ClinicColors.ink2, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: ClinicColors.ink2, size: 20),
        const SizedBox(width: ClinicSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: ClinicText.caption),
              Text(value, style: ClinicText.body),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeveloperModeSection() {
    return ClinicalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.developer_mode_rounded, color: ClinicColors.ink2, size: 24),
              const SizedBox(width: ClinicSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Developer Mode', style: ClinicText.h3.copyWith(fontSize: 18)),
                    const SizedBox(height: 4),
                    Text(
                      _developerMode ? 'Enabled' : 'Disabled',
                      style: ClinicText.caption,
                    ),
                  ],
                ),
              ),
              Switch(
                value: _developerMode,
                onChanged: _toggleDeveloperMode,
                activeColor: ClinicColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
