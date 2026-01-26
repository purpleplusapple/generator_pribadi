import 'package:flutter/material.dart';
import '../../../theme/design_tokens.dart';
import '../../../theme/terrace_theme.dart';
import '../../../data/style_categories.dart';

class CategoryGallery extends StatefulWidget {
  final Function(StyleCategory) onCategorySelected;
  final VoidCallback onCustomAdvancedSelected;

  const CategoryGallery({
    super.key,
    required this.onCategorySelected,
    required this.onCustomAdvancedSelected,
  });

  @override
  State<CategoryGallery> createState() => _CategoryGalleryState();
}

class _CategoryGalleryState extends State<CategoryGallery> {
  String _searchQuery = '';
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'Cozy', 'Party', 'Modern', 'Garden'];

  List<StyleCategory> get _filteredCategories {
    return terraceCategories.where((category) {
      final matchesSearch = category.title.toLowerCase().contains(_searchQuery.toLowerCase());
      // Filter logic is simplistic for now as we don't have tags in the model, relying on title/desc
      final matchesFilter = _selectedFilter == 'All' ||
          category.title.contains(_selectedFilter) ||
          category.description.contains(_selectedFilter);
      return matchesSearch && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchBar(),
        _buildFilters(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: _filteredCategories.length + 1, // +1 for Advanced Custom
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildAdvancedCustomCard();
              }
              final category = _filteredCategories[index - 1];
              return _CategoryCard(
                category: category,
                onTap: () => widget.onCategorySelected(category),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: const InputDecoration(
          hintText: 'Search styles...',
          prefixIcon: Icon(Icons.search, color: DesignTokens.muted),
          fillColor: DesignTokens.surface2,
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (val) => setState(() => _selectedFilter = filter),
              backgroundColor: DesignTokens.surface,
              selectedColor: DesignTokens.primary,
              labelStyle: TextStyle(
                color: isSelected ? DesignTokens.bg0 : DesignTokens.ink1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: isSelected ? Colors.transparent : DesignTokens.line),
              ),
              showCheckmark: false,
            ),
          );
        },
      ),
    );
  }

  Widget _buildAdvancedCustomCard() {
    return GestureDetector(
      onTap: widget.onCustomAdvancedSelected,
      child: Container(
        height: 100,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: DesignTokens.surface2,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: DesignTokens.primary.withOpacity(0.5), width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              decoration: BoxDecoration(
                color: DesignTokens.primary.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: const Icon(Icons.edit_note, color: DesignTokens.primary, size: 32),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Advanced Custom', style: terraceTheme.textTheme.titleMedium?.copyWith(color: DesignTokens.ink0)),
                    const SizedBox(height: 4),
                    const Text('Write your own prompt with granular control', style: TextStyle(color: DesignTokens.muted, fontSize: 12)),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.arrow_forward_ios, size: 16, color: DesignTokens.muted),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final StyleCategory category;
  final VoidCallback onTap;

  const _CategoryCard({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 160,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: DesignTokens.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: DesignTokens.line),
          // Placeholder gradient
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              DesignTokens.surface,
              DesignTokens.surface2,
            ],
          ),
          boxShadow: DesignTokens.shadowSoft,
        ),
        child: Stack(
          children: [
             // Image placeholder
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  color: Colors.black.withOpacity(0.2), // Darken layer
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: DesignTokens.line.withOpacity(0.3)),
                    ),
                    child: Text(
                      category.title,
                      style: terraceTheme.textTheme.headlineMedium?.copyWith(
                        color: DesignTokens.ink0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(4),
                     decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      category.description,
                      style: const TextStyle(color: DesignTokens.ink1, fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
