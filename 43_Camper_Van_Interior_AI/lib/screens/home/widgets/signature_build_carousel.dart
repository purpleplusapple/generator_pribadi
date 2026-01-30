import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../theme/camper_theme.dart';

class SignatureBuildCarousel extends StatelessWidget {
  const SignatureBuildCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            width: 220,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              borderRadius: CamperAIRadii.cardLargeRadius,
              color: CamperAIColors.surface2,
              image: DecorationImage(
                image: AssetImage('assets/examples/example_${index + 1}.svg'), // Actually SVG needs SvgPicture
                fit: BoxFit.cover,
                opacity: 0.6,
              ),
            ),
            child: Stack(
              children: [
                // Fallback if image fails (since we use SVG for examples, we should use SvgPicture.asset inside a child, not DecorationImage for SVGs directly unless using a provider)
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: CamperAIRadii.cardLargeRadius,
                    child: SvgPicture.asset(
                       'assets/examples/example_${index + 1}.svg',
                       fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getTitle(index),
                        style: CamperAIText.h3,
                      ),
                      Text(
                        "Signature Series",
                        style: CamperAIText.caption,
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  String _getTitle(int index) {
    switch (index) {
      case 0: return "Alpine Sprinter";
      case 1: return "Coastal Cruiser";
      case 2: return "Desert Nomad";
      default: return "Custom Build";
    }
  }
}
