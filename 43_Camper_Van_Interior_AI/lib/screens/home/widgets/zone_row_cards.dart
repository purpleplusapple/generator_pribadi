import 'package:flutter/material.dart';
import '../../../theme/camper_tokens.dart';

class ZoneRowCards extends StatelessWidget {
  const ZoneRowCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Text("Focus Zones", style: Theme.of(context).textTheme.titleLarge),
        ),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              _ZoneCard(Icons.bed_rounded, "Bed"),
              _ZoneCard(Icons.kitchen_rounded, "Kitchen"),
              _ZoneCard(Icons.inventory_2_rounded, "Storage"),
              _ZoneCard(Icons.shower_rounded, "Bath"),
              _ZoneCard(Icons.solar_power_rounded, "Solar"),
            ],
          ),
        ),
      ],
    );
  }
}

class _ZoneCard extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ZoneCard(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: CamperTokens.surface,
        borderRadius: BorderRadius.circular(CamperTokens.radiusM),
        border: Border.all(color: CamperTokens.line),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: CamperTokens.primary, size: 32),
          const SizedBox(height: 8),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
