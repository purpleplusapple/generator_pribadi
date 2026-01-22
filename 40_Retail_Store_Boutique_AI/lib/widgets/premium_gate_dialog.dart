// lib/widgets/premium_gate_dialog.dart
// Dialog shown when user reaches generation limit

import 'package:flutter/material.dart';
import '../theme/boutique_theme.dart';
import '../widgets/glass_card.dart';

class PremiumGateDialog extends StatelessWidget {
  const PremiumGateDialog({
    super.key,
    required this.onUpgrade,
  });

  final VoidCallback onUpgrade;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: GlassCard(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.workspace_premium, size: 64, color: BoutiqueColors.primary),
            const SizedBox(height: 24),
            Text('Premium Access', style: BoutiqueText.h2),
            const SizedBox(height: 16),
            Text(
              'Upgrade to unlock unlimited AI generations for your boutique.',
              style: BoutiqueText.body.copyWith(color: BoutiqueColors.ink1),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: onUpgrade,
              child: const Text("UPGRADE NOW"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> show(BuildContext context, {required VoidCallback onUpgrade}) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PremiumGateDialog(onUpgrade: onUpgrade),
    );
  }
}
