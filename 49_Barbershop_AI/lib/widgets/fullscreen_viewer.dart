// Fullscreen image viewer with zoom and actions

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';
import '../theme/barber_theme.dart';
import 'error_toast.dart';

class FullscreenViewer extends StatelessWidget {
  const FullscreenViewer({
    super.key,
    required this.imagePath,
    this.onDelete,
  });

  final String imagePath;
  final VoidCallback? onDelete;

  Future<void> _saveToGallery(BuildContext context) async {
    try {
      final result = await ImageGallerySaver.saveFile(imagePath);
      if (context.mounted) {
        if (result['isSuccess'] == true) {
          ErrorToast.showSuccess(context, 'Saved to gallery!');
        } else {
          ErrorToast.show(context, 'Failed to save image');
        }
      }
    } catch (e) {
      if (context.mounted) {
        ErrorToast.show(context, 'Failed to save image');
      }
    }
  }

  Future<void> _shareImage(BuildContext context) async {
    try {
      await Share.shareXFiles(
        [XFile(imagePath)],
        text: 'Check out my AI-generated barbershop design!',
      );
    } catch (e) {
      if (context.mounted) {
        ErrorToast.show(context, 'Failed to share image');
      }
    }
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: BarberTheme.surface,
        title: Text(
          'Delete This Result?',
          style: BarberTheme.themeData.textTheme.titleLarge,
        ),
        content: Text(
          'This action cannot be undone.',
          style: BarberTheme.themeData.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Close fullscreen
              onDelete?.call();
            },
            style: TextButton.styleFrom(
              foregroundColor: BarberTheme.danger,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Dismissible for swipe down to close
          Dismissible(
            key: const Key('fullscreen_viewer'),
            direction: DismissDirection.down,
            onDismissed: (_) => Navigator.of(context).pop(),
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Center(
                child: Image.file(
                  File(imagePath),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // Close button
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.close_rounded,
                color: Colors.white,
                size: 32,
              ),
              style: IconButton.styleFrom(
                backgroundColor: Colors.black54,
              ),
            ),
          ),

          // Action buttons
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 16,
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildActionButton(
                    icon: Icons.save_alt_rounded,
                    label: 'Save',
                    onTap: () => _saveToGallery(context),
                  ),
                  const SizedBox(width: 24),
                  _buildActionButton(
                    icon: Icons.share_rounded,
                    label: 'Share',
                    onTap: () => _shareImage(context),
                  ),
                  if (onDelete != null) ...[
                    const SizedBox(width: 24),
                    _buildActionButton(
                      icon: Icons.delete_outline_rounded,
                      label: 'Delete',
                      onTap: () => _confirmDelete(context),
                      color: BarberTheme.danger,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color ?? BarberTheme.primary,
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
