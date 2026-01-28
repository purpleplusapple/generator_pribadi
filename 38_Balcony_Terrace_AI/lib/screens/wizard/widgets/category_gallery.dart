import 'package:flutter/material.dart';
import '../../theme/terrace_theme.dart';
import '../../data/terrace_style_data.dart';
import '../../widgets/glass_card.dart';

class CategoryGallery extends StatefulWidget {
  final Function(TerraceStyleCategory) onCategorySelected;
  final String? selectedCategoryId;

  const CategoryGallery({
    super.key,
    required this.onCategorySelected,
    this.selectedCategoryId,
  });

  @override
  State<CategoryGallery> createState() => _CategoryGalleryState();
}

class _CategoryGalleryState extends State<CategoryGallery> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  List<TerraceStyleCategory> get _filteredCategories {
    if (_searchQuery.isEmpty) return terraceCategories;
    return terraceCategories.where((c) {
      return c.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.description.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: TerraceAISpacing.base),
          child: TextField(
            controller: _searchController,
            style: TerraceAIText.body,
            decoration: const InputDecoration(
              hintText: 'Search styles (e.g., "Boho", "Modern")...',
              prefixIcon: Icon(Icons.search, color: TerraceAIColors.muted),
            ),
            onChanged: (val) => setState(() => _searchQuery = val),
          ),
        ),

        const SizedBox(height: TerraceAISpacing.lg),

        // Gallery
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(
              left: TerraceAISpacing.base,
              right: TerraceAISpacing.base,
              bottom: 100, // Space for dock/sheet
            ),
            itemCount: _filteredCategories.length,
            separatorBuilder: (_, __) => const SizedBox(height: TerraceAISpacing.lg),
            itemBuilder: (context, index) {
              final category = _filteredCategories[index];
              return _buildCategoryCard(category);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(TerraceStyleCategory category) {
    final isSelected = widget.selectedCategoryId == category.id;

    return GestureDetector(
      onTap: () => widget.onCategorySelected(category),
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          borderRadius: TerraceAIRadii.mdRadius,
          border: isSelected
              ? Border.all(color: TerraceAIColors.primary, width: 2)
              : Border.all(color: TerraceAIColors.line),
          color: isSelected
              ? TerraceAIColors.primary.withValues(alpha: 0.1)
              : TerraceAIColors.surface.withValues(alpha: 0.5),
          boxShadow: isSelected ? TerraceAIShadows.emeraldGlow(opacity: 0.1) : null,
        ),
        child: Row(
          children: [
            // Left Image Placeholder
            Container(
              width: 100,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(TerraceAIRadii.md),
                  bottomLeft: Radius.circular(TerraceAIRadii.md),
                ),
                color: TerraceAIColors.surface2,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    TerraceAIColors.surface2,
                    TerraceAIColors.bg1,
                  ],
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.image_outlined,
                  color: TerraceAIColors.muted.withValues(alpha: 0.3),
                  size: 32,
                ),
              ),
            ),

            // Right Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(TerraceAISpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      category.title,
                      style: TerraceAIText.h3.copyWith(fontSize: 18),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category.description,
                      style: TerraceAIText.caption,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    if (isSelected)
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: TerraceAIColors.primary, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            'Selected',
                            style: TerraceAIText.small.copyWith(
                              color: TerraceAIColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),

            // Arrow
            Padding(
              padding: const EdgeInsets.only(right: TerraceAISpacing.md),
              child: Icon(
                Icons.chevron_right_rounded,
                color: isSelected ? TerraceAIColors.primary : TerraceAIColors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
