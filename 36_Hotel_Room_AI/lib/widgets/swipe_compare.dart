import 'package:flutter/material.dart';
import '../theme/hotel_room_ai_theme.dart';

class SwipeBeforeAfterCompare extends StatefulWidget {
  final ImageProvider beforeImage;
  final ImageProvider afterImage;

  const SwipeBeforeAfterCompare({
    super.key,
    required this.beforeImage,
    required this.afterImage,
  });

  @override
  State<SwipeBeforeAfterCompare> createState() => _SwipeBeforeAfterCompareState();
}

class _SwipeBeforeAfterCompareState extends State<SwipeBeforeAfterCompare> {
  double _splitValue = 0.5; // 0.0 to 1.0

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        return Stack(
          children: [
            // Background (After Image - Full)
            Positioned.fill(
              child: Image(
                image: widget.afterImage,
                fit: BoxFit.cover,
              ),
            ),

            // Foreground (Before Image - Clipped)
            Positioned.fill(
              child: ClipRect(
                clipper: _SplitClipper(_splitValue),
                child: Image(
                  image: widget.beforeImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Handle
            Positioned(
              left: (width * _splitValue) - 16,
              top: 0,
              bottom: 0,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onHorizontalDragUpdate: (details) {
                  setState(() {
                    _splitValue = (_splitValue + details.delta.dx / width)
                        .clamp(0.0, 1.0);
                  });
                },
                child: Container(
                  width: 32,
                  color: Colors.transparent, // Touch target
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Vertical Line
                      Container(
                        width: 2,
                        color: Colors.white,
                      ),
                      // Circle Handle
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: HotelAIShadows.cardElevated,
                        ),
                        child: Icon(
                          Icons.compare_arrows,
                          size: 18,
                          color: HotelAIColors.ink0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Labels
            Positioned(
              bottom: 16,
              left: 16,
              child: Opacity(
                opacity: _splitValue > 0.1 ? 1.0 : 0.0,
                child: _LabelChip(label: "BEFORE"),
              ),
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: Opacity(
                opacity: _splitValue < 0.9 ? 1.0 : 0.0,
                child: _LabelChip(label: "AFTER"),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _LabelChip extends StatelessWidget {
  final String label;
  const _LabelChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

class _SplitClipper extends CustomClipper<Rect> {
  final double split;

  _SplitClipper(this.split);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width * split, size.height);
  }

  @override
  bool shouldReclip(covariant _SplitClipper oldClipper) {
    return oldClipper.split != split;
  }
}
