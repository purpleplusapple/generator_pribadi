// lib/screens/settings/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/app_theme.dart';
import '../../widgets/error_toast.dart';
import '../../services/premium_gate_service.dart';
import '../../services/study_history_repository.dart';
import '../../src/mypaywall.dart';
import '../../src/constant.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final PremiumGateService _premiumGate = PremiumGateService();
  final StudyHistoryRepository _history = StudyHistoryRepository();

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
        backgroundColor: StudyAIColors.surface,
        title: Text('Clear All History?', style: StudyAIText.h3),
        content: Text('This will delete all saved results.', style: StudyAIText.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: StudyAIColors.danger),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _history.clearHistory();
      if (mounted) ErrorToast.showSuccess(context, 'History cleared');
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: StudyAIColors.primary))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildCard(
                  title: _isPremium ? 'Premium Active' : 'Free Account',
                  subtitle: _isPremium ? 'Unlimited access' : 'Upgrade to unlock AI generation',
                  icon: _isPremium ? Icons.workspace_premium : Icons.person_outline,
                  action: !_isPremium
                      ? ElevatedButton(
                          onPressed: _openPaywall,
                          child: const Text('Upgrade'),
                        )
                      : null,
                ),
                const SizedBox(height: 16),
                _buildCard(
                  title: 'Account',
                  children: [
                    ListTile(
                      leading: const Icon(Icons.restore, color: StudyAIColors.primary),
                      title: const Text('Restore Purchases'),
                      onTap: _restorePurchases,
                    ),
                    ListTile(
                      leading: const Icon(Icons.delete_sweep, color: StudyAIColors.danger),
                      title: const Text('Clear History'),
                      onTap: _clearHistory,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildCard(
                  title: 'About',
                  children: [
                    ListTile(
                      leading: const Icon(Icons.info_outline, color: StudyAIColors.muted),
                      title: const Text('Version 1.0.0'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.email, color: StudyAIColors.muted),
                      title: const Text('support@studyclassai.com'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        '© 2024 Study Class AI',
                        textAlign: TextAlign.center,
                        style: StudyAIText.bodySmall,
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _buildCard({String? title, String? subtitle, IconData? icon, Widget? action, List<Widget>? children}) {
    return Container(
      decoration: BoxDecoration(
        color: StudyAIColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: StudyAIShadows.card,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Row(
              children: [
                if (icon != null) Icon(icon, color: StudyAIColors.primary, size: 28),
                if (icon != null) const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: StudyAIText.h3),
                      if (subtitle != null) Text(subtitle, style: StudyAIText.bodySmall),
                    ],
                  ),
                ),
                if (action != null) action,
              ],
            ),
            if (children != null) const Divider(height: 24, color: StudyAIColors.line),
          ],
          if (children != null) ...children,
        ],
      ),
    );
  }
}
