import 'package:flutter/material.dart';
import 'dart:io';
import '../../../theme/camper_tokens.dart';
import '../../../model/camper_ai_config.dart';

class MasonryVanHistoryGrid extends StatelessWidget {
  final List<CamperAIConfig> items;
  final Function(CamperAIConfig) onTap;

  const MasonryVanHistoryGrid({super.key, required this.items, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Split items into two columns
    final leftItems = <CamperAIConfig>[];
    final rightItems = <CamperAIConfig>[];

    for (var i = 0; i < items.length; i++) {
      if (i % 2 == 0) leftItems.add(items[i]);
      else rightItems.add(items[i]);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _Column(items: leftItems, onTap: onTap)),
          const SizedBox(width: 16),
          Expanded(child: _Column(items: rightItems, onTap: onTap)),
        ],
      ),
    );
  }
}

class _Column extends StatelessWidget {
  final List<CamperAIConfig> items;
  final Function(CamperAIConfig) onTap;
  const _Column({required this.items, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map((item) => _Card(item: item, onTap: onTap)).toList(),
    );
  }
}

class _Card extends StatelessWidget {
  final CamperAIConfig item;
  final Function(CamperAIConfig) onTap;
  const _Card({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final imagePath = item.resultData?.generatedImagePath ?? item.originalImagePath;

    return GestureDetector(
      onTap: () => onTap(item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: CamperTokens.surface,
          borderRadius: BorderRadius.circular(CamperTokens.radiusM),
          boxShadow: [
             BoxShadow(
               color: Colors.black.withValues(alpha: 0.2),
               blurRadius: 8,
               offset: const Offset(0, 4)
             )
          ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (imagePath != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(CamperTokens.radiusM)),
                child: Image.file(
                  File(imagePath),
                  fit: BoxFit.cover,
                  errorBuilder: (_,__,___) => Container(height: 100, color: CamperTokens.bg1)
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.selectedStyleId ?? "Unknown Style",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: CamperTokens.ink0),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${item.timestamp.day}/${item.timestamp.month}",
                    style: const TextStyle(fontSize: 10, color: CamperTokens.muted),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
