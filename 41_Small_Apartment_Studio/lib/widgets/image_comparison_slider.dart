import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ImageComparisonSlider extends StatefulWidget {
  const ImageComparisonSlider({
    super.key,
    required this.beforeImagePath,
    required this.afterImagePath,
  });

  final String beforeImagePath;
  final String afterImagePath;

  @override
  State<ImageComparisonSlider> createState() => _ImageComparisonSliderState();
}

class _ImageComparisonSliderState extends State<ImageComparisonSlider>
    with SingleTickerProviderStateMixin {
  double _dividerPosition = 0.5;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          _dividerPosition = (_dividerPosition + details.delta.dx / MediaQuery.of(context).size.width)
              .clamp(0.0, 1.0);
        });
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          // Ensure height is reasonable or fill parent
          final height = constraints.maxHeight == double.infinity ? 400.0 : constraints.maxHeight;
          final dividerX = width * _dividerPosition;

          return Stack(
            alignment: Alignment.center,
            children: [
              // Use BoxFit.cover to fill the area, assuming images are similar aspect ratio
              Image.file(File(widget.afterImagePath), width: width, height: height, fit: BoxFit.cover),
              Positioned(
                left: 0, top: 0, bottom: 0, width: dividerX,
                child: ClipRect(
                  child: Image.file(
                    File(widget.beforeImagePath),
                    width: width,
                    height: height,
                    fit: BoxFit.cover,
                    alignment: Alignment.centerLeft
                  ),
                ),
              ),
              Positioned(left: 16, top: 16, child: _buildLabel('BEFORE', DesignTokens.surface.withOpacity(0.8))),
              Positioned(right: 16, top: 16, child: _buildLabel('AFTER', DesignTokens.primary.withOpacity(0.8))),
              Positioned(
                left: dividerX - 2, top: 0, bottom: 0, width: 4,
                child: Container(
                  color: DesignTokens.ink0,
                  child: Center(
                    child: Container(
                       width: 4,
                       height: double.infinity,
                       color: DesignTokens.ink0,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: dividerX - 20,
                // Center vertically
                top: (height / 2) - 20,
                child: Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: DesignTokens.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: DesignTokens.ink0, width: 2),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 8),
                    ],
                  ),
                  child: const Icon(Icons.compare_arrows, color: DesignTokens.bg0, size: 20),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLabel(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      child: Text(text, style: const TextStyle(color: DesignTokens.ink0, fontWeight: FontWeight.bold, fontSize: 10)),
    );
  }
}
