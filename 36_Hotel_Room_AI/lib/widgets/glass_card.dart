// lib/widgets/glass_card.dart
// Renamed/Refactored to HotelPaperCard logic but keeping name for compatibility
// Option A: Boutique Linen

import 'package:flutter/material.dart';
import '../theme/hotel_room_ai_theme.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HotelAIColors.bg1,
        borderRadius: HotelAIRadii.mediumRadius,
        boxShadow: HotelAIShadows.soft,
        border: Border.all(color: HotelAIColors.line),
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: content,
      );
    }
    return content;
  }
}
