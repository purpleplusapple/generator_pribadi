import 'package:flutter/material.dart';
import '../theme/guest_theme.dart';

enum ButtonSize {
  standard,
  large,
}

class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.size = ButtonSize.standard,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final ButtonSize size;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || isLoading;
    final height = size == ButtonSize.large ? 56.0 : 48.0;

    return SizedBox(
      height: height,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: GuestAIColors.brass,
          foregroundColor: Colors.white,
          disabledBackgroundColor: GuestAIColors.muted.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(GuestAIRadii.regular),
          ),
          elevation: 4,
          shadowColor: GuestAIColors.brass.withValues(alpha: 0.4),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: GuestAIText.button.copyWith(color: Colors.white),
                  ),
                ],
              ),
      ),
    );
  }
}
