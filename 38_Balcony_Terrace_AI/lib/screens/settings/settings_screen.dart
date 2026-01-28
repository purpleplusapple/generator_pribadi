// lib/screens/settings/settings_screen.dart
// Settings screen with app info and account management

import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/balcony_terrace_ai_theme.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/error_toast.dart';
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
        backgroundColor: TerraceAIColors.soleBlack,
        title: Text(
          'Clear All History?',
          style: TerraceAIText.h3,
        ),
        content: Text(
          'This will permanently delete all saved redesigns. This action cannot be undone.',
          style: TerraceAIText.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: TerraceAIColors.error,
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
              ? 'Developer Mode Enabled - Premium features unlocked for testing'
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
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(TerraceAIColors.leatherTan),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(TerraceAISpacing.base),
              children: [
                // Premium Status Section
                _buildPremiumStatusCard(),

                const SizedBox(height: TerraceAISpacing.lg),

                // Account Actions Section
                _buildAccountActionsCard(),

                const SizedBox(height: TerraceAISpacing.lg),

                // Legal Section
                _buildLegalSection(),

                const SizedBox(height: TerraceAISpacing.lg),

                // About Section
                _buildAboutSection(),

                const SizedBox(height: TerraceAISpacing.lg),

                // Developer Mode Section
                _buildDeveloperModeSection(),

                const SizedBox(height: TerraceAISpacing.xxl),
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
                _isPremium ? Icons.workspace_premium_rounded : Icons.person_outline_rounded,
                color: _isPremium ? TerraceAIColors.laceGray : TerraceAIColors.leatherTan,
                size: 28,
              ),
              const SizedBox(width: TerraceAISpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isPremium ? 'Premium Active' : 'Free Account',
                      style: TerraceAIText.h3.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isPremium
                          ? '10 daily generations + unlimited with tokens'
                          : 'Upgrade to unlock AI generation',
                      style: TerraceAIText.caption.copyWith(
                        color: TerraceAIColors.canvasWhite.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (!_isPremium) ...[
            const SizedBox(height: TerraceAISpacing.lg),
            GradientButton(
              label: 'Upgrade to Premium',
              icon: Icons.arrow_forward_rounded,
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
          Text(
            'Account',
            style: TerraceAIText.h3.copyWith(fontSize: 18),
          ),

          const SizedBox(height: TerraceAISpacing.lg),

          // Restore Purchases
          _buildActionRow(
            icon: Icons.restore_rounded,
            label: 'Restore Purchases',
            onTap: _restorePurchases,
          ),

          const SizedBox(height: TerraceAISpacing.md),

          // Clear History
          _buildActionRow(
            icon: Icons.delete_sweep_rounded,
            label: 'Clear History',
            onTap: _clearHistory,
            iconColor: TerraceAIColors.error,
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
          Text(
            'Legal',
            style: TerraceAIText.h3.copyWith(fontSize: 18),
          ),

          const SizedBox(height: TerraceAISpacing.lg),

          _buildActionRow(
            icon: Icons.privacy_tip_outlined,
            label: 'Privacy Policy',
            onTap: () => _openUrl('https://vibesinterior.com/privacy.php'),
          ),

          const SizedBox(height: TerraceAISpacing.md),

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
          Text(
            'About',
            style: TerraceAIText.h3.copyWith(fontSize: 18),
          ),

          const SizedBox(height: TerraceAISpacing.lg),

          _buildInfoRow(
            icon: Icons.apps_rounded,
            label: 'App Version',
            value: '1.0.0',
          ),

          const SizedBox(height: TerraceAISpacing.md),

          _buildInfoRow(
            icon: Icons.email_outlined,
            label: 'Support',
            value: 'support@terraceroomai.com',
          ),

          const SizedBox(height: TerraceAISpacing.md),

          Text(
            '© 2026 Balcony Terrace AI\nTransform your space with AI',
            style: TerraceAIText.caption.copyWith(
              color: TerraceAIColors.canvasWhite.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
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
        padding: const EdgeInsets.symmetric(vertical: TerraceAISpacing.sm),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor ?? TerraceAIColors.leatherTan,
              size: 24,
            ),
            const SizedBox(width: TerraceAISpacing.md),
            Expanded(
              child: Text(
                label,
                style: TerraceAIText.bodyMedium,
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: TerraceAIColors.canvasWhite.withValues(alpha: 0.5),
              size: 20,
            ),
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
        Icon(
          icon,
          color: TerraceAIColors.metallicGold,
          size: 20,
        ),
        const SizedBox(width: TerraceAISpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TerraceAIText.caption.copyWith(
                  color: TerraceAIColors.canvasWhite.withValues(alpha: 0.6),
                ),
              ),
              Text(
                value,
                style: TerraceAIText.body,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeveloperModeSection() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.developer_mode_rounded,
                color: _developerMode ? TerraceAIColors.laceGray : TerraceAIColors.canvasWhite.withValues(alpha: 0.7),
                size: 24,
              ),
              const SizedBox(width: TerraceAISpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Developer Mode',
                      style: TerraceAIText.h3.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _developerMode
                          ? 'Premium features unlocked for testing'
                          : 'Enable to test premium features',
                      style: TerraceAIText.caption.copyWith(
                        color: _developerMode
                            ? TerraceAIColors.metallicGold
                            : TerraceAIColors.canvasWhite.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _developerMode,
                onChanged: _toggleDeveloperMode,
                activeTrackColor: TerraceAIColors.leatherTan,
              ),
            ],
          ),

          if (_developerMode) ...[
            const SizedBox(height: TerraceAISpacing.md),
            Container(
              padding: const EdgeInsets.all(TerraceAISpacing.md),
              decoration: BoxDecoration(
                color: TerraceAIColors.laceGray.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: TerraceAIColors.laceGray.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_rounded,
                    color: TerraceAIColors.laceGray,
                    size: 20,
                  ),
                  const SizedBox(width: TerraceAISpacing.sm),
                  Expanded(
                    child: Text(
                      'For testing only. Premium checks are bypassed.',
                      style: TerraceAIText.caption.copyWith(
                        color: TerraceAIColors.laceGray,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
