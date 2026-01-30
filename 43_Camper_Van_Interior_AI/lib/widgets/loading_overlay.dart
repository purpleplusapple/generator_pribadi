import 'package:flutter/material.dart';
import '../theme/camper_tokens.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String message;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message = 'Loading...',
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withValues(alpha: 0.7),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(color: CamperTokens.primary),
                  const SizedBox(height: 16),
                  Text(message, style: const TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
