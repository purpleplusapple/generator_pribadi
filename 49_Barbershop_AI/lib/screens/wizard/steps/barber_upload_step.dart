import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../theme/barber_theme.dart';
import '../wizard_controller.dart';

class BarberUploadStep extends StatelessWidget {
  final WizardController controller;

  const BarberUploadStep({super.key, required this.controller});

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: source);
    if (file != null) {
      controller.setSelectedImage(file.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left Panel: Guidance (Hidden on small screens if needed, but we assume mobile so maybe split vertical?)
        // The prompt asked for "Upload Step two-panel (tips foto ruangan, mirror reflections)".
        // On mobile portrait, side-by-side is hard. I'll do Top/Bottom split or Tabbed.
        // But "Two-panel" usually implies Tablet/Desktop OR a split view.
        // I will implement a "Split Column" for mobile: Top is Guidance, Bottom is Action.

        Expanded(
          child: Column(
            children: [
              // Panel 1: Guidance Carousel
              Expanded(
                flex: 4,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: BarberTheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: BarberTheme.line),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text("Best Practices", style: BarberTheme.themeData.textTheme.titleMedium),
                      ),
                      Expanded(
                        child: PageView(
                          children: [
                            _GuidanceCard(
                              title: "Lighting",
                              desc: "Ensure the room is well lit. Avoid strong backlighting.",
                              icon: Icons.lightbulb_outline,
                            ),
                            _GuidanceCard(
                              title: "Mirrors",
                              desc: "Capture the mirror wall straight on if possible.",
                              icon: Icons.crop_portrait,
                            ),
                             _GuidanceCard(
                              title: "Clean Up",
                              desc: "Remove clutter for best AI results.",
                              icon: Icons.cleaning_services_outlined,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Panel 2: Action Area
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: BarberTheme.bg1,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (controller.selectedImagePath != null)
                         Expanded(
                           child: Stack(
                             children: [
                               ClipRRect(
                                 borderRadius: BorderRadius.circular(16),
                                 child: Image.file(
                                   File(controller.selectedImagePath!),
                                   fit: BoxFit.cover,
                                   width: double.infinity,
                                 ),
                               ),
                               Positioned(
                                 top: 8,
                                 right: 8,
                                 child: IconButton(
                                   onPressed: () => controller.setSelectedImage(null),
                                   icon: const Icon(Icons.close, color: Colors.white),
                                   style: IconButton.styleFrom(backgroundColor: Colors.black54),
                                 ),
                               )
                             ],
                           ),
                         )
                      else ...[
                        _UploadButton(
                          label: "Take Photo",
                          icon: Icons.camera_alt_rounded,
                          onTap: () => _pickImage(context, ImageSource.camera),
                          isPrimary: true,
                        ),
                        const SizedBox(height: 16),
                        _UploadButton(
                          label: "Choose from Gallery",
                          icon: Icons.photo_library_rounded,
                          onTap: () => _pickImage(context, ImageSource.gallery),
                          isPrimary: false,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GuidanceCard extends StatelessWidget {
  final String title;
  final String desc;
  final IconData icon;

  const _GuidanceCard({required this.title, required this.desc, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: BarberTheme.primary),
          const SizedBox(height: 16),
          Text(title, style: BarberTheme.themeData.textTheme.titleLarge?.copyWith(color: BarberTheme.ink0)),
          const SizedBox(height: 8),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: BarberTheme.themeData.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _UploadButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;

  const _UploadButton({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? BarberTheme.primary : BarberTheme.surface,
          foregroundColor: isPrimary ? BarberTheme.bg0 : BarberTheme.ink0,
          padding: const EdgeInsets.symmetric(vertical: 20),
          side: isPrimary ? null : const BorderSide(color: BarberTheme.line),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            const SizedBox(width: 12),
            Text(label),
          ],
        ),
      ),
    );
  }
}
