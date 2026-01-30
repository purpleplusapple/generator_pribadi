import 'package:flutter/material.dart';
import '../theme/barber_theme.dart';

enum ButtonSize { small, medium, large }

class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final ButtonSize size;

  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.size = ButtonSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    final padding = size == ButtonSize.large
        ? const EdgeInsets.symmetric(vertical: 16, horizontal: 32)
        : const EdgeInsets.symmetric(vertical: 12, horizontal: 24);

    final fontSize = size == ButtonSize.large ? 16.0 : 14.0;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: onPressed != null
              ? [BarberTheme.primary, BarberTheme.primary.withOpacity(0.8)]
              : [BarberTheme.muted, BarberTheme.muted.withOpacity(0.8)],
        ),
        boxShadow: onPressed != null
            ? [BoxShadow(color: BarberTheme.primary.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: padding,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: BarberTheme.bg0, size: fontSize + 4),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: TextStyle(
                    color: BarberTheme.bg0,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
