// lib/widgets/fullscreen_viewer.dart
// Fullscreen image viewer with zoom and actions

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';
import '../theme/boutique_theme.dart';
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
        ErrorToast.showSuccess(context, result['isSuccess'] == true ? 'Saved to gallery!' : 'Failed to save');
      }
    } catch (e) {
      if (context.mounted) ErrorToast.show(context, 'Failed to save');
    }
  }

  Future<void> _shareImage(BuildContext context) async {
    try {
      await Share.shareXFiles([XFile(imagePath)], text: 'My Boutique Redesign');
    } catch (e) {
      if (context.mounted) ErrorToast.show(context, 'Failed to share');
    }
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: BoutiqueColors.surface,
        title: Text('Delete?', style: BoutiqueText.h3),
        content: Text('Cannot be undone.', style: BoutiqueText.body),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(onPressed: () { Navigator.pop(context); Navigator.pop(context); onDelete?.call(); }, child: const Text('Delete', style: TextStyle(color: BoutiqueColors.danger))),
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
          Dismissible(
            key: const Key('fullscreen_viewer'),
            direction: DismissDirection.down,
            onDismissed: (_) => Navigator.of(context).pop(),
            child: InteractiveViewer(
              child: Center(child: Image.file(File(imagePath), fit: BoxFit.contain)),
            ),
          ),
          Positioned(
            top: 50, right: 20,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close, color: Colors.white),
              style: IconButton.styleFrom(backgroundColor: Colors.black54),
            ),
          ),
          Positioned(
            bottom: 40, left: 0, right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _btn(Icons.save_alt, "Save", () => _saveToGallery(context)),
                const SizedBox(width: 20),
                _btn(Icons.share, "Share", () => _shareImage(context)),
                if (onDelete != null) ...[const SizedBox(width: 20), _btn(Icons.delete, "Delete", () => _confirmDelete(context), color: BoutiqueColors.danger)],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _btn(IconData icon, String label, VoidCallback onTap, {Color? color}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(30)),
        child: Row(children: [Icon(icon, color: color ?? BoutiqueColors.primary, size: 20), const SizedBox(width: 8), Text(label, style: const TextStyle(color: Colors.white))]),
      ),
    );
  }
}
