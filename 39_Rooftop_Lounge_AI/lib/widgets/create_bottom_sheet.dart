import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../screens/wizard/wizard_screen.dart';

class CreateBottomSheet extends StatelessWidget {
  const CreateBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: DesignTokens.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(color: DesignTokens.line, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const Text('Create New', style: TextStyle(color: DesignTokens.ink0, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'DM Serif Display')),
          const SizedBox(height: 24),
          _buildOption(context, Icons.add_a_photo, 'New Design', 'Start from scratch', () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const WizardScreen()));
          }),
          const SizedBox(height: 16),
          _buildOption(context, Icons.style, 'Pick Style', 'Browse curated styles', () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const WizardScreen()));
          }),
          const SizedBox(height: 16),
          _buildOption(context, Icons.photo_library, 'Import Photo', 'Use from gallery', () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const WizardScreen()));
          }),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildOption(BuildContext context, IconData icon, String title, String subtitle, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: DesignTokens.bg0,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: DesignTokens.line.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: DesignTokens.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: DesignTokens.primary),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: DesignTokens.ink0, fontWeight: FontWeight.bold)),
                Text(subtitle, style: const TextStyle(color: DesignTokens.ink1, fontSize: 12)),
              ],
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, color: DesignTokens.ink1),
          ],
        ),
      ),
    );
  }
}
