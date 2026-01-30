import 'package:flutter/material.dart';
import 'dart:io';
import '../../../theme/camper_tokens.dart';

class UploadTwoPanelGuidance extends StatelessWidget {
  final VoidCallback onPickImage;
  final VoidCallback onTakePhoto;
  final File? selectedImage;

  const UploadTwoPanelGuidance({
    super.key,
    required this.onPickImage,
    required this.onTakePhoto,
    this.selectedImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Panel 1: Guidance (Top, 40%)
        Expanded(
          flex: 4,
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: CamperTokens.surface,
              borderRadius: BorderRadius.circular(CamperTokens.radiusL),
              border: Border.all(color: CamperTokens.line),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.tips_and_updates_outlined, color: CamperTokens.accentSunrise, size: 32),
                const SizedBox(height: 16),
                Text("Van Conversion Tips", style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                _TipRow("Stand in the back or corner"),
                _TipRow("Use wide angle (0.5x)"),
                _TipRow("Turn on all lights"),
              ],
            ),
          ),
        ),

        // Panel 2: Action (Bottom, 60%)
        Expanded(
          flex: 6,
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            decoration: BoxDecoration(
              color: CamperTokens.bg0,
              borderRadius: BorderRadius.circular(CamperTokens.radiusL),
              border: Border.all(color: CamperTokens.line, style: BorderStyle.solid),
            ),
            child: selectedImage != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(CamperTokens.radiusL),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(selectedImage!, fit: BoxFit.cover),
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: FloatingActionButton(
                          onPressed: onPickImage, // Re-pick
                          backgroundColor: CamperTokens.surface,
                          child: const Icon(Icons.edit, color: CamperTokens.ink0),
                        ),
                      )
                    ],
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _BigButton(
                      icon: Icons.add_photo_alternate_rounded,
                      label: "Upload Photo",
                      onTap: onPickImage,
                      primary: true,
                    ),
                    const SizedBox(height: 16),
                    _BigButton(
                      icon: Icons.camera_alt_rounded,
                      label: "Take Photo",
                      onTap: onTakePhoto,
                      primary: false,
                    ),
                  ],
                ),
          ),
        ),
      ],
    );
  }
}

class _TipRow extends StatelessWidget {
  final String text;
  const _TipRow(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: CamperTokens.success, size: 16),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(color: CamperTokens.ink1)),
        ],
      ),
    );
  }
}

class _BigButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool primary;

  const _BigButton({required this.icon, required this.label, required this.onTap, required this.primary});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 200,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: primary ? CamperTokens.primary : Colors.transparent,
          border: Border.all(color: primary ? CamperTokens.primary : CamperTokens.line),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: primary ? Colors.black : CamperTokens.ink0),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: primary ? Colors.black : CamperTokens.ink0,
                fontWeight: FontWeight.bold
              )
            ),
          ],
        ),
      ),
    );
  }
}
