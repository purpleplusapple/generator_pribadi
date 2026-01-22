// lib/widgets/gradient_button.dart
// Refactored to Solid Primary Button
// Option A: Boutique Linen

import 'package:flutter/material.dart';
import '../theme/hotel_room_ai_theme.dart';

enum ButtonSize { small, medium, large }

class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final ButtonSize size;
  final bool isLoading;

  const GradientButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.size = ButtonSize.medium,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    double height;
    double fontSize;
    EdgeInsets padding;

    switch (size) {
      case ButtonSize.small:
        height = 36;
        fontSize = 13;
        padding = const EdgeInsets.symmetric(horizontal: 12);
        break;
      case ButtonSize.large:
        height = 56;
        fontSize = 16;
        padding = const EdgeInsets.symmetric(horizontal: 32);
        break;
      case ButtonSize.medium:
      default:
        height = 48;
        fontSize = 15;
        padding = const EdgeInsets.symmetric(horizontal: 24);
        break;
    }

    return SizedBox(
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: HotelAIColors.primary,
          foregroundColor: Colors.white,
          padding: padding,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(HotelAIRadii.button),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: fontSize + 4),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: HotelAIText.button.copyWith(
                      color: Colors.white,
                      fontSize: fontSize,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
