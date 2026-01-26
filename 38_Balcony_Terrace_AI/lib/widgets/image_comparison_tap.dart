import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/design_tokens.dart';

class BeforeAfterTapToggle extends StatefulWidget {
  final File originalImage;
  final ImageProvider resultImage;

  const BeforeAfterTapToggle({
    super.key,
    required this.originalImage,
    required this.resultImage,
  });

  @override
  State<BeforeAfterTapToggle> createState() => _BeforeAfterTapToggleState();
}

class _BeforeAfterTapToggleState extends State<BeforeAfterTapToggle> {
  bool _showOriginal = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) => setState(() => _showOriginal = true),
      onLongPressEnd: (_) => setState(() => _showOriginal = false),
      onTapDown: (_) => setState(() => _showOriginal = true),
      onTapUp: (_) => setState(() => _showOriginal = false),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Result Image (Background)
          Image(
            image: widget.resultImage,
            fit: BoxFit.cover,
          ),

          // Original Image (Overlay)
          if (_showOriginal)
            Image.file(
              widget.originalImage,
              fit: BoxFit.cover,
            ),

          // Indicator Pill
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: DesignTokens.line.withOpacity(0.5)),
                ),
                child: Text(
                  _showOriginal ? 'Original' : 'Hold to Compare',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
