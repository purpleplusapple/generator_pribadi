// lib/widgets/premium_gate_dialog.dart
// Premium Gate Dialog
// Option A: Boutique Linen

import 'package:flutter/material.dart';
import '../theme/hotel_room_ai_theme.dart';
import 'gradient_button.dart';

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
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: HotelAIColors.bg1,
          borderRadius: HotelAIRadii.largeRadius,
          boxShadow: HotelAIShadows.modal,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: HotelAIColors.primarySoft,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.lock_open, size: 48, color: HotelAIColors.primary),
            ),
            const SizedBox(height: 24),
            Text('Unlock Design Studio', style: HotelAIText.h2, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Text(
              'Upgrade to create unlimited hotel room designs with premium AI models.',
              style: HotelAIText.body.copyWith(color: HotelAIColors.muted),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _Benefit(text: "Unlimited Generations"),
            _Benefit(text: "High-Res Downloads"),
            _Benefit(text: "All Premium Styles"),
            const SizedBox(height: 32),
            GradientButton(
              label: 'Upgrade Now',
              icon: Icons.star,
              onPressed: onUpgrade,
              size: ButtonSize.large,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Maybe Later", style: HotelAIText.caption),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onUpgrade,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => PremiumGateDialog(onUpgrade: onUpgrade),
    );
  }
}

class _Benefit extends StatelessWidget {
  final String text;
  const _Benefit({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, color: HotelAIColors.primary, size: 18),
          const SizedBox(width: 8),
          Text(text, style: HotelAIText.bodyMedium),
        ],
      ),
    );
  }
}
