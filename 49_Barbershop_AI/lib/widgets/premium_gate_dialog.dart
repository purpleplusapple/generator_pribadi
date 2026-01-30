import 'package:flutter/material.dart';
import '../theme/barber_theme.dart';

class PremiumGateDialog extends StatelessWidget {
  final VoidCallback onUpgrade;

  const PremiumGateDialog({super.key, required this.onUpgrade});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: BarberTheme.surface,
      title: Text("Premium Feature", style: BarberTheme.themeData.textTheme.titleLarge),
      content: const Text("Upgrade to access this feature."),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            onUpgrade();
          },
          child: const Text("Upgrade"),
        ),
      ],
    );
  }
}
