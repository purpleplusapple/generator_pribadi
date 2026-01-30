// lib/screens/settings/settings_screen.dart
import 'package:flutter/material.dart';
import '../../theme/camper_tokens.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCard(context, "Premium", Icons.star, "Upgrade to Pro"),
          const SizedBox(height: 16),
          _buildCard(context, "Account", Icons.person, "Manage Account"),
          const SizedBox(height: 16),
          _buildCard(context, "Restore Purchases", Icons.restore, "Restore"),
          const SizedBox(height: 16),
          _buildCard(context, "Help & Support", Icons.help, "FAQ & Contact"),
          const SizedBox(height: 32),
          const Center(child: Text("Version 1.0.0", style: TextStyle(color: CamperTokens.muted))),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, IconData icon, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CamperTokens.surface,
        borderRadius: BorderRadius.circular(CamperTokens.radiusM),
      ),
      child: Row(
        children: [
          Icon(icon, color: CamperTokens.primary),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: CamperTokens.ink0)),
              Text(subtitle, style: const TextStyle(color: CamperTokens.muted, fontSize: 12)),
            ],
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, size: 16, color: CamperTokens.muted)
        ],
      ),
    );
  }
}
