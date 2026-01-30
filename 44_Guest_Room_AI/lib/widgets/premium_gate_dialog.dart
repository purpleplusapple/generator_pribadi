// lib/widgets/premium_gate_dialog.dart
// Dialog shown when user reaches generation limit

import 'package:flutter/material.dart';
import '../theme/guest_room_ai_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_button.dart';

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
        child: Padding(
          padding: const EdgeInsets.all(GuestAISpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Icon(
                Icons.lock_outline_rounded,
                size: 64,
                color: GuestAIColors.leatherTan,
              ),

              const SizedBox(height: GuestAISpacing.lg),

              // Title
              Text(
                'Premium Feature',
                style: GuestAIText.h2,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: GuestAISpacing.md),

              // Message
              Text(
                'AI generation is a premium feature. Upgrade now to unlock powerful AI-powered shoe room transformations!',
                style: GuestAIText.body.copyWith(
                  color: GuestAIColors.canvasWhite.withValues(alpha: 0.8),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: GuestAISpacing.lg),

              // Benefits
              _buildBenefit(
                icon: Icons.calendar_today_rounded,
                text: '10 AI generations per day',
              ),
              const SizedBox(height: GuestAISpacing.sm),
              _buildBenefit(
                icon: Icons.add_circle_outline_rounded,
                text: 'Unlimited generations with tokens',
              ),
              const SizedBox(height: GuestAISpacing.sm),
              _buildBenefit(
                icon: Icons.save_rounded,
                text: 'Save all your redesigns',
              ),
              const SizedBox(height: GuestAISpacing.sm),
              _buildBenefit(
                icon: Icons.star_rounded,
                text: 'Access to all features',
              ),

              const SizedBox(height: GuestAISpacing.xxl),

              // Upgrade button
              GradientButton(
                label: 'Upgrade to Premium',
                icon: Icons.workspace_premium_rounded,
                onPressed: onUpgrade,
                size: ButtonSize.large,
              ),

              const SizedBox(height: GuestAISpacing.md),

              // Maybe later button
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Maybe Later',
                  style: GuestAIText.bodyMedium.copyWith(
                    color: GuestAIColors.canvasWhite.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefit({
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: GuestAIColors.metallicGold,
          size: 20,
        ),
        const SizedBox(width: GuestAISpacing.sm),
        Expanded(
          child: Text(
            text,
            style: GuestAIText.body.copyWith(
              color: GuestAIColors.canvasWhite.withValues(alpha: 0.9),
            ),
          ),
        ),
      ],
    );
  }

  /// Show the premium gate dialog
  static Future<void> show(
    BuildContext context, {
    required VoidCallback onUpgrade,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PremiumGateDialog(onUpgrade: onUpgrade),
    );
  }
}
