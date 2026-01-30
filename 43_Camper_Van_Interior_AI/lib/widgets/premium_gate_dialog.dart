import 'package:flutter/material.dart';
import '../theme/camper_tokens.dart';

class PremiumGateDialog extends StatelessWidget {
  const PremiumGateDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const PremiumGateDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: CamperTokens.surface,
      title: const Text("Premium Feature", style: TextStyle(color: CamperTokens.ink0)),
      content: const Text("Upgrade to access this feature.", style: TextStyle(color: CamperTokens.ink1)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(backgroundColor: CamperTokens.primary, foregroundColor: Colors.black),
          child: const Text("Upgrade"),
        ),
      ],
    );
  }
}
