import 'package:flutter/material.dart';
import '../theme/hotel_room_ai_theme.dart';

class RoomTypePillCard extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;

  const RoomTypePillCard({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isSelected ? HotelAIColors.ink0 : HotelAIColors.bg1,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? HotelAIColors.ink0 : HotelAIColors.line,
          ),
          boxShadow: isSelected ? HotelAIShadows.floating : HotelAIShadows.soft,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : HotelAIColors.ink0,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: HotelAIText.button.copyWith(
                color: isSelected ? Colors.white : HotelAIColors.ink0,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
