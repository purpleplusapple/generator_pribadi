import 'package:flutter/material.dart';
import '../theme/apartment_tokens.dart';

class SwipeCompare extends StatefulWidget {
  final ImageProvider original;
  final ImageProvider generated;

  const SwipeCompare({
    super.key,
    required this.original,
    required this.generated,
  });

  @override
  State<SwipeCompare> createState() => _SwipeCompareState();
}

class _SwipeCompareState extends State<SwipeCompare> {
  bool _showOriginal = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) {
        setState(() {
          _showOriginal = true;
        });
      },
      onLongPressEnd: (_) {
        setState(() {
          _showOriginal = false;
        });
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Images
          Positioned.fill(
            child: Image(
              image: _showOriginal ? widget.original : widget.generated,
              fit: BoxFit.cover,
            ),
          ),

          // Label Badge
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _showOriginal ? 'ORIGINAL' : 'REDESIGN',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),

          // Instruction Hint
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: ApartmentTokens.surface.withOpacity(0.9),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.touch_app, size: 16, color: ApartmentTokens.ink0),
                  SizedBox(width: 8),
                  Text(
                    'Hold to compare',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: ApartmentTokens.ink0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
