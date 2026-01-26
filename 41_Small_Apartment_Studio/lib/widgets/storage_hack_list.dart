import 'package:flutter/material.dart';
import '../theme/apartment_tokens.dart';

class StorageHackList extends StatelessWidget {
  const StorageHackList({super.key});

  final List<Map<String, String>> hacks = const [
    {
      'title': 'Under-Bed Drawers',
      'desc': 'Utilize the 20cm gap under your bed for seasonal clothes.',
      'tag': 'Bedroom'
    },
    {
      'title': 'Vertical Wall Shelves',
      'desc': 'Go high up to the ceiling to store books and decor.',
      'tag': 'Living'
    },
    {
      'title': 'Over-Door Hooks',
      'desc': 'Perfect for coats, bags, and towels in tight entries.',
      'tag': 'Entry'
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
            'Storage Hacks',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        const SizedBox(height: ApartmentTokens.s12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: ApartmentTokens.s16),
          itemCount: hacks.length,
          itemBuilder: (context, index) {
            final item = hacks[index];
            return Container(
              margin: const EdgeInsets.only(bottom: ApartmentTokens.s12),
              padding: const EdgeInsets.all(ApartmentTokens.s16),
              decoration: BoxDecoration(
                color: ApartmentTokens.surface,
                borderRadius: BorderRadius.circular(ApartmentTokens.r16),
                border: Border.all(color: ApartmentTokens.line),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: ApartmentTokens.bg0,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.lightbulb_outline, color: ApartmentTokens.accent),
                  ),
                  const SizedBox(width: ApartmentTokens.s16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: ApartmentTokens.ink0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['desc']!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: ApartmentTokens.ink1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
