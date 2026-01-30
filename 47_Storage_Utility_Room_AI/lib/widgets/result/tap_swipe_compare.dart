import 'package:flutter/material.dart';
import '../../theme/storage_theme.dart';

class TapSwipeCompare extends StatefulWidget {
  final ImageProvider beforeImage;
  final ImageProvider afterImage;

  const TapSwipeCompare({
    super.key,
    required this.beforeImage,
    required this.afterImage,
  });

  @override
  State<TapSwipeCompare> createState() => _TapSwipeCompareState();
}

class _TapSwipeCompareState extends State<TapSwipeCompare> {
  bool _showAfter = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => _showAfter = !_showAfter);
      },
      onHorizontalDragUpdate: (details) {
        if (details.primaryDelta! > 0 && !_showAfter) {
          setState(() => _showAfter = true);
        } else if (details.primaryDelta! < 0 && _showAfter) {
          setState(() => _showAfter = false);
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Images
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: Image(
              key: ValueKey(_showAfter),
              image: _showAfter ? widget.afterImage : widget.beforeImage,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          // Pill Indicator
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildPillTab("Before", !_showAfter),
                    _buildPillTab("After", _showAfter),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPillTab(String text, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? StorageColors.primaryLime : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isActive ? Colors.black : Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
