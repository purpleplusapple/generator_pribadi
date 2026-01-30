import 'package:flutter/material.dart';
import '../theme/barber_theme.dart';

class ErrorBoundary extends StatelessWidget {
  final Widget child;
  final Widget? fallback;

  const ErrorBoundary({super.key, required this.child, this.fallback});

  @override
  Widget build(BuildContext context) {
    return child; // Simplified for now
  }
}
