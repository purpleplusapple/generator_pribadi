// lib/screens/settings/settings_screen.dart
// Settings screen
// Option A: Boutique Linen

import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/hotel_room_ai_theme.dart';
import '../../widgets/error_toast.dart';
import '../../services/premium_gate_service.dart';
import '../../services/hotel_history_repository.dart';
import '../../src/hotel_paywall.dart';
import '../../src/constant.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final PremiumGateService _premiumGate = PremiumGateService();
  final HotelHistoryRepository _history = HotelHistoryRepository();

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
      ErrorToast.showInfo(context, 'Restoring purchases...');
      await Purchases.restorePurchases();
      await _loadStatus();
      if (mounted) ErrorToast.showSuccess(context, 'Purchases restored!');
    } catch (e) {
      if (mounted) ErrorToast.show(context, 'Failed to restore');
    }
  }

  Future<void> _clearHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: HotelAIColors.bg1,
        title: Text('Clear History?', style: HotelAIText.h3),
        content: Text('Delete all saved designs?', style: HotelAIText.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: HotelAIColors.error),
            child: const Text('Delete'),
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
        builder: (context) => const HotelPaywall(),
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

  Future<void> _toggleDeveloperMode(bool value) async {
    await setDeveloperMode(value);
    await _loadStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HotelAIColors.bg0,
      appBar: AppBar(title: Text('Settings', style: HotelAIText.h3)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: HotelAIColors.primary))
          : ListView(
              padding: const EdgeInsets.all(HotelAISpacing.lg),
              children: [
                _buildPremiumCard(),
                const SizedBox(height: 24),
                _SectionTitle(title: "Account"),
                _SettingsTile(
                  icon: Icons.restore,
                  title: "Restore Purchases",
                  onTap: _restorePurchases,
                ),
                _SettingsTile(
                  icon: Icons.delete_outline,
                  title: "Clear History",
                  onTap: _clearHistory,
                  textColor: HotelAIColors.error,
                  iconColor: HotelAIColors.error,
                ),

                const SizedBox(height: 24),
                _SectionTitle(title: "Legal"),
                _SettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  title: "Privacy Policy",
                  onTap: () => _openUrl('https://example.com/privacy'),
                ),
                _SettingsTile(
                  icon: Icons.description_outlined,
                  title: "Terms of Service",
                  onTap: () => _openUrl('https://example.com/terms'),
                ),

                const SizedBox(height: 24),
                _SectionTitle(title: "About"),
                const _InfoTile(title: "Version", value: "1.0.0"),
                const _InfoTile(title: "Contact", value: "support@hotelroomai.com"),

                const SizedBox(height: 24),
                 _SectionTitle(title: "Developer"),
                SwitchListTile(
                  title: Text("Developer Mode", style: HotelAIText.body),
                  subtitle: Text("Bypass premium checks", style: HotelAIText.caption),
                  value: _developerMode,
                  onChanged: _toggleDeveloperMode,
                  activeColor: HotelAIColors.primary,
                ),
              ],
            ),
    );
  }

  Widget _buildPremiumCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _isPremium ? HotelAIColors.bg1 : HotelAIColors.ink0,
        borderRadius: HotelAIRadii.largeRadius,
        boxShadow: HotelAIShadows.floating,
      ),
      child: Column(
        children: [
          Icon(
            _isPremium ? Icons.verified : Icons.star_border,
            size: 40,
            color: _isPremium ? HotelAIColors.primary : Colors.white,
          ),
          const SizedBox(height: 12),
          Text(
            _isPremium ? "Premium Active" : "Get Premium",
            style: HotelAIText.h2.copyWith(
              color: _isPremium ? HotelAIColors.ink0 : Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _isPremium ? "You have full access." : "Unlock unlimited generations.",
            style: HotelAIText.body.copyWith(
              color: _isPremium ? HotelAIColors.muted : Colors.white70,
            ),
          ),
          if (!_isPremium) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _openPaywall,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: HotelAIColors.ink0,
              ),
              child: const Text("Upgrade Now"),
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(title, style: HotelAIText.h3.copyWith(fontSize: 14, color: HotelAIColors.muted)),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? textColor;
  final Color? iconColor;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.textColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: HotelAIColors.bg1,
      child: ListTile(
        leading: Icon(icon, color: iconColor ?? HotelAIColors.ink0),
        title: Text(title, style: HotelAIText.body.copyWith(color: textColor ?? HotelAIColors.ink0)),
        trailing: const Icon(Icons.chevron_right, color: HotelAIColors.muted),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: HotelAIRadii.mediumRadius),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String title;
  final String value;
  const _InfoTile({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: HotelAIColors.bg1,
      child: ListTile(
        title: Text(title, style: HotelAIText.body),
        trailing: Text(value, style: HotelAIText.body.copyWith(color: HotelAIColors.muted)),
        shape: RoundedRectangleBorder(borderRadius: HotelAIRadii.mediumRadius),
      ),
    );
  }
}
