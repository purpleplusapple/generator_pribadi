import 'package:flutter/material.dart';
import '../theme/clinic_theme.dart';

enum ButtonSize {
  standard,
  large,
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
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
    final height = size == ButtonSize.large ? 56.0 : 48.0;

    return SizedBox(
      height: height,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: ClinicColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: ClinicColors.ink2.withValues(alpha: 0.1),
          disabledForegroundColor: ClinicColors.ink2.withValues(alpha: 0.5),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: ClinicRadius.mediumRadius,
          ),
          padding: const EdgeInsets.symmetric(horizontal: ClinicSpacing.lg),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: ClinicText.button.copyWith(
                      fontSize: size == ButtonSize.large ? 18 : 16,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
