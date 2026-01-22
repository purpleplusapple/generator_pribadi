// lib/widgets/image_comparison_slider.dart
// Before/After image comparison with interactive slider

import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/boutique_theme.dart';

class ImageComparisonSlider extends StatefulWidget {
  const ImageComparisonSlider({super.key, required this.beforeImagePath, required this.afterImagePath});
  final String beforeImagePath;
  final String afterImagePath;
  @override
  State<ImageComparisonSlider> createState() => _ImageComparisonSliderState();
}

class _ImageComparisonSliderState extends State<ImageComparisonSlider> with SingleTickerProviderStateMixin {
  double _dividerPosition = 0.5;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this)..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
  }
  @override
  void dispose() { _pulseController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (d) => setState(() => _dividerPosition = (_dividerPosition + d.delta.dx / MediaQuery.of(context).size.width).clamp(0.0, 1.0)),
      child: LayoutBuilder(builder: (context, c) {
        final w = c.maxWidth;
        final x = w * _dividerPosition;
        return Stack(
          alignment: Alignment.center,
          children: [
            Image.file(File(widget.afterImagePath), width: w, fit: BoxFit.contain),
            Positioned(left: 0, top: 0, bottom: 0, width: x, child: ClipRect(child: Image.file(File(widget.beforeImagePath), width: w, fit: BoxFit.contain, alignment: Alignment.centerLeft))),
            Positioned(left: 16, top: 16, child: _label("BEFORE", BoutiqueColors.bg0.withValues(alpha: 0.7))),
            Positioned(right: 16, top: 16, child: _label("AFTER", BoutiqueColors.bg0.withValues(alpha: 0.7))),
            Positioned(left: x - 2, top: 0, bottom: 0, width: 4, child: Container(color: Colors.white, child: Center(child: ScaleTransition(scale: _pulseAnimation, child: Container(width: 48, height: 48, decoration: BoxDecoration(color: BoutiqueColors.primary, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 3)), child: const Icon(Icons.compare_arrows, color: Colors.white, size: 24)))))),
          ],
        );
      }),
    );
  }

  Widget _label(String t, Color c) {
    return Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(8)), child: Text(t, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)));
  }
}
