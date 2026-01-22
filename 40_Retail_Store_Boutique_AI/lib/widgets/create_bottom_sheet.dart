import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:retail_store_boutique_ai/theme/boutique_theme.dart';
import '../screens/wizard/wizard_screen.dart';

class CreateBottomSheet extends StatelessWidget {
  const CreateBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        decoration: BoxDecoration(
          color: BoutiqueColors.surface.withValues(alpha: 0.9),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          border: Border(top: BorderSide(color: BoutiqueColors.primary.withValues(alpha: 0.3))),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: BoutiqueColors.line,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text("Create New Design", style: BoutiqueText.h2),
            const SizedBox(height: 8),
            Text("Start a new boutique transformation project", style: BoutiqueText.body.copyWith(color: BoutiqueColors.muted)),
            const SizedBox(height: 32),

            _buildAction(
              context,
              icon: Icons.add_photo_alternate_outlined,
              title: "New Store Makeover",
              subtitle: "Upload photo & redesign",
              isPrimary: true,
              onTap: () {
                Navigator.pop(context); // Close sheet
                Navigator.push(context, MaterialPageRoute(builder: (_) => const WizardScreen()));
              },
            ),
            const SizedBox(height: 16),
            _buildAction(
              context,
              icon: Icons.grid_view,
              title: "Merchandising Layout",
              subtitle: "Plan shelf & display arrangements",
              onTap: () {
                 Navigator.pop(context);
                 // TODO: Navigate to Merchandising tool
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildAction(BuildContext context, {required IconData icon, required String title, required String subtitle, required VoidCallback onTap, bool isPrimary = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isPrimary ? BoutiqueColors.primary.withValues(alpha: 0.1) : BoutiqueColors.bg0,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isPrimary ? BoutiqueColors.primary : BoutiqueColors.line,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isPrimary ? BoutiqueColors.primary : BoutiqueColors.surface2,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: isPrimary ? BoutiqueColors.bg0 : BoutiqueColors.ink1),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: BoutiqueText.bodyMedium.copyWith(color: BoutiqueColors.ink0)),
                  Text(subtitle, style: BoutiqueText.caption),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 14, color: BoutiqueColors.muted),
          ],
        ),
      ),
    );
  }
}
