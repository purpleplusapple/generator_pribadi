import 'package:flutter/material.dart';
import '../../theme/storage_theme.dart';

class StorageSystemsCarousel extends StatefulWidget {
  const StorageSystemsCarousel({super.key});

  @override
  State<StorageSystemsCarousel> createState() => _StorageSystemsCarouselState();
}

class _StorageSystemsCarouselState extends State<StorageSystemsCarousel> {
  final PageController _controller = PageController(viewportFraction: 0.85);

  final List<Map<String, String>> _items = [
    {
      "title": "Industrial Pegboard",
      "subtitle": "Maximize wall space",
      "image": "assets/examples/ex_01.jpg" // Using ex_01 as copied from ex_02 if missing
    },
    {
      "title": "Compact Laundry",
      "subtitle": "High efficiency zones",
      "image": "assets/examples/ex_02.jpg"
    },
    {
      "title": "Pantry Overflow",
      "subtitle": "Stockpile management",
      "image": "assets/examples/ex_03.jpg"
    },
    {
      "title": "Garage Utility",
      "subtitle": "Heavy duty racks",
      "image": "assets/examples/ex_04.jpg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text("Storage Systems", style: StorageTheme.darkTheme.textTheme.headlineSmall),
        ),
        SizedBox(
          height: 320,
          child: PageView.builder(
            controller: _controller,
            itemCount: _items.length,
            padEnds: false,
            itemBuilder: (context, index) {
              final item = _items[index];
              return Container(
                margin: EdgeInsets.only(
                  left: index == 0 ? 20 : 8,
                  right: index == _items.length - 1 ? 20 : 0,
                  bottom: 10,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        item["image"]!,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, _, __) => Container(color: StorageColors.surface2),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.8),
                            ],
                            stops: const [0.6, 1.0],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item["subtitle"]!.toUpperCase(),
                              style: const TextStyle(
                                color: StorageColors.primaryLime,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item["title"]!,
                              style: StorageTheme.darkTheme.textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
