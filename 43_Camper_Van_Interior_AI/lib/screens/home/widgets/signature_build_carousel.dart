import 'package:flutter/material.dart';
import '../../../theme/camper_tokens.dart';

class SignatureBuildCarousel extends StatelessWidget {
  const SignatureBuildCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Text("Signature Builds", style: Theme.of(context).textTheme.titleLarge),
        ),
        SizedBox(
          height: 380,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            itemBuilder: (context, index) {
              return Container(
                width: 280,
                margin: const EdgeInsets.only(right: 16),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(CamperTokens.radiusL),
                        image: DecorationImage(
                          image: AssetImage('assets/examples/ex_$index.jpg'),
                          fit: BoxFit.cover,
                        ),
                        color: CamperTokens.surface,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(CamperTokens.radiusL),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 24,
                      left: 24,
                      right: 24,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ["Forest Nomad", "Coastal Surf", "Alpine Retreat", "Desert Studio"][index],
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Tap to view details",
                            style: TextStyle(color: CamperTokens.ink1.withValues(alpha: 0.8))
                          )
                        ],
                      ),
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
