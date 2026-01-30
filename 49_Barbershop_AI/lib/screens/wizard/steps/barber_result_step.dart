import 'dart:io';
import 'package:flutter/material.dart';
import '../../theme/barber_theme.dart';
import '../../widgets/tap_or_swipe_compare.dart';
import '../wizard_controller.dart';

class BarberResultStep extends StatelessWidget {
  final WizardController controller;

  const BarberResultStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final originalPath = controller.selectedImagePath;
    // Mock result (in real app, use resultData url)
    // For demo, we just reuse the original image or a placeholder if logic isn't connected to backend yet.
    // In strict clone reuse, we might have resultData.

    if (originalPath == null) return const Center(child: Text("No image"));

    return Column(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: TapOrSwipeCompareToggle(
              beforeImage: FileImage(File(originalPath)),
              afterImage: const AssetImage('assets/examples/shop_01.svg'), // Placeholder result
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Shop Notes Panel
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: BarberTheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: BarberTheme.line),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Shop Notes", style: BarberTheme.themeData.textTheme.titleMedium),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _InfoItem("Style", controller.selectedStyleId ?? "Unknown"),
                  _InfoItem("Chairs", "${controller.config.controlValues['chairs'] ?? 3}"),
                  _InfoItem("Lighting", "${controller.config.controlValues['lighting'] ?? 'Mixed'}"),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;
  const _InfoItem(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: BarberTheme.themeData.textTheme.labelMedium),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: BarberTheme.ink0)),
      ],
    );
  }
}
