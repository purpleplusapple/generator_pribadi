import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../theme/camper_theme.dart';
import '../../../../widgets/glass_card.dart';

class UploadTwoPanelGuidance extends StatelessWidget {
  final VoidCallback onGalleryTap;
  final VoidCallback onCameraTap;

  const UploadTwoPanelGuidance({
    super.key,
    required this.onGalleryTap,
    required this.onCameraTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top Panel: Guidance Carousel
        Expanded(
          flex: 4,
          child: PageView.builder(
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CamperAIColors.surface2,
                  borderRadius: CamperAIRadii.cardLargeRadius,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SvgPicture.asset(
                          'assets/onboarding/onboard_${index + 1}.svg',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        _getGuidanceText(index),
                        textAlign: TextAlign.center,
                        style: CamperAIText.bodyMedium,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        // Bottom Panel: Actions
        Expanded(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: CamperAIColors.bg0,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              border: Border(top: BorderSide(color: CamperAIColors.line)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Start Your Conversion", style: CamperAIText.h2, textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text("Upload a photo of your empty van or current interior.",
                  style: CamperAIText.body.copyWith(color: CamperAIColors.muted), textAlign: TextAlign.center),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.photo_library,
                        label: "Gallery",
                        onTap: onGalleryTap,
                        isPrimary: false,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.camera_alt,
                        label: "Camera",
                        onTap: onCameraTap,
                        isPrimary: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getGuidanceText(int index) {
    switch (index) {
      case 0: return "Clear out clutter for best results.";
      case 1: return "Stand back to capture the whole space.";
      case 2: return "Ensure good lighting for accurate textures.";
      default: return "Guidance";
    }
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isPrimary,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: isPrimary ? CamperAIColors.leatherTan : CamperAIColors.surface,
          borderRadius: CamperAIRadii.buttonRadius,
          border: isPrimary ? null : Border.all(color: CamperAIColors.line),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isPrimary ? CamperAIColors.soleBlack : CamperAIColors.canvasWhite),
            const SizedBox(width: 8),
            Text(
              label,
              style: CamperAIText.button.copyWith(
                color: isPrimary ? CamperAIColors.soleBlack : CamperAIColors.canvasWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
