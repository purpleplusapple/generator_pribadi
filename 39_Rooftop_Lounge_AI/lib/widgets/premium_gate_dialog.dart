import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_button.dart';

class PremiumGateDialog extends StatelessWidget {
  const PremiumGateDialog({super.key, required this.onUpgrade});
  final VoidCallback onUpgrade;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: GlassCard(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_outline, size: 64, color: DesignTokens.primary),
              const SizedBox(height: 16),
              Text('Premium Feature', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: DesignTokens.ink0)),
              const SizedBox(height: 16),
              const Text(
                'Unlock full Rooftop Lounge AI capabilities to transform your space!',
                style: TextStyle(color: DesignTokens.ink1),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              _buildBenefit(Icons.calendar_today, '10 daily redesigns'),
              const SizedBox(height: 8),
              _buildBenefit(Icons.add_circle_outline, 'Unlimited with tokens'),
              const SizedBox(height: 8),
              _buildBenefit(Icons.save, 'Save all designs'),
              const SizedBox(height: 8),
              _buildBenefit(Icons.star, 'Priority access'),
              const SizedBox(height: 24),
              GradientButton(
                label: 'Upgrade Now',
                icon: Icons.workspace_premium,
                onPressed: onUpgrade,
                size: ButtonSize.large,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Maybe Later', style: TextStyle(color: DesignTokens.ink1.withOpacity(0.5))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefit(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: DesignTokens.primary, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: const TextStyle(color: DesignTokens.ink0))),
      ],
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
