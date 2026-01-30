import 'package:flutter/material.dart';
import '../../theme/storage_theme.dart';

class ZoneRowCards extends StatelessWidget {
  const ZoneRowCards({super.key});

  final List<Map<String, dynamic>> _zones = const [
    {"icon": Icons.cleaning_services_rounded, "label": "Cleaning Supplies"},
    {"icon": Icons.handyman_rounded, "label": "Tools & Hardware"},
    {"icon": Icons.soup_kitchen_rounded, "label": "Pantry Overflow"},
    {"icon": Icons.local_laundry_service_rounded, "label": "Laundry Corner"},
    {"icon": Icons.ac_unit_rounded, "label": "Seasonal"},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text("Zones", style: StorageTheme.darkTheme.textTheme.headlineSmall),
        ),
        SizedBox(
          height: 100,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: _zones.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final zone = _zones[index];
              return Container(
                width: 120,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: StorageColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: StorageColors.line),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(zone["icon"], color: StorageColors.accentAmber, size: 32),
                    const SizedBox(height: 8),
                    Text(
                      zone["label"],
                      textAlign: TextAlign.center,
                      style: StorageTheme.darkTheme.textTheme.bodySmall?.copyWith(fontSize: 11),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
