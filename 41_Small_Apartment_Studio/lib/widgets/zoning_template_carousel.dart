import 'package:flutter/material.dart';
import '../theme/apartment_tokens.dart';

class ZoningTemplateCarousel extends StatelessWidget {
  const ZoningTemplateCarousel({super.key});

  final List<Map<String, dynamic>> templates = const [
    {
      'title': 'Sleep & Work',
      'subtitle': 'Separated desk zone',
      'icon': Icons.laptop_mac,
      'color': ApartmentTokens.primarySoft,
    },
    {
      'title': 'Sleep & Dine',
      'subtitle': 'Foldable table focus',
      'icon': Icons.restaurant,
      'color': ApartmentTokens.accentSoft,
    },
    {
      'title': 'All-in-One',
      'subtitle': 'Open plan flow',
      'icon': Icons.dashboard,
      'color': ApartmentTokens.bg1,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: ApartmentTokens.s16),
          child: Text(
            'Zoning Templates',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        const SizedBox(height: ApartmentTokens.s12),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: ApartmentTokens.s16),
            itemCount: templates.length,
            itemBuilder: (context, index) {
              final item = templates[index];
              return Container(
                width: 160,
                margin: const EdgeInsets.only(right: ApartmentTokens.s12),
                padding: const EdgeInsets.all(ApartmentTokens.s16),
                decoration: BoxDecoration(
                  color: item['color'],
                  borderRadius: BorderRadius.circular(ApartmentTokens.r16),
                  border: Border.all(color: ApartmentTokens.line),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(item['icon'], color: ApartmentTokens.ink0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: ApartmentTokens.ink0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['subtitle'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: ApartmentTokens.muted,
                          ),
                        ),
                      ],
                    )
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
