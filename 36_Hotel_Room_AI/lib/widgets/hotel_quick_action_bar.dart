import 'package:flutter/material.dart';
import '../theme/hotel_room_ai_theme.dart';

class HotelQuickActionBar extends StatelessWidget {
  final VoidCallback? onSearchTap;
  final VoidCallback? onMenuTap;
  final VoidCallback? onProfileTap;

  const HotelQuickActionBar({
    super.key,
    this.onSearchTap,
    this.onMenuTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: HotelAISpacing.lg,
        vertical: HotelAISpacing.base,
      ),
      child: Row(
        children: [
          // Search Bar
          Expanded(
            child: InkWell(
              onTap: onSearchTap,
              borderRadius: BorderRadius.circular(HotelAIRadii.button),
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: HotelAIColors.bg1,
                  borderRadius: BorderRadius.circular(HotelAIRadii.button),
                  border: Border.all(color: HotelAIColors.line),
                  boxShadow: HotelAIShadows.soft,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: HotelAIColors.muted,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Find a style...",
                      style: HotelAIText.body.copyWith(
                        color: HotelAIColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Action Buttons
          _ActionButton(
            icon: Icons.notifications_none_outlined,
            onTap: onMenuTap,
          ),
          const SizedBox(width: 8),
          _ActionButton(
            icon: Icons.person_outline,
            onTap: onProfileTap,
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _ActionButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: HotelAIColors.bg1,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: HotelAIColors.line),
          boxShadow: HotelAIShadows.soft,
        ),
        child: Icon(
          icon,
          color: HotelAIColors.ink0,
          size: 22,
        ),
      ),
    );
  }
}
