import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../theme/terrace_theme.dart';
import '../../../data/terrace_styles.dart';
import '../../../model/style_definition.dart';
import '../wizard_controller.dart';
import '../../../components/wizard/style_control_sheet.dart';

class StyleTerraceStep extends StatefulWidget {
  const StyleTerraceStep({super.key, required this.controller});

  final WizardController controller;

  @override
  State<StyleTerraceStep> createState() => _StyleTerraceStepState();
}

class _StyleTerraceStepState extends State<StyleTerraceStep> {
  String _searchQuery = '';
  String _selectedFilter = 'All';

  List<StyleDefinition> get _filteredStyles {
    return TerraceStyles.styles.where((style) {
      final matchesSearch = style.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          style.tags.any((tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()));

      if (_selectedFilter == 'All') return matchesSearch;

      // Simple filter logic based on tags
      final matchesFilter = style.tags.contains(_selectedFilter);
      return matchesSearch && matchesFilter;
    }).toList();
  }

  void _openStyleControls(StyleDefinition style) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StyleControlSheet(
        style: style,
        initialValues: widget.controller.getStyleValues(style.id) ?? {},
        onSave: (values) {
          widget.controller.setStyle(style.id, values);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        _buildFilters(),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(TerraceSpacing.base),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: TerraceSpacing.md,
              mainAxisSpacing: TerraceSpacing.md,
            ),
            itemCount: _filteredStyles.length,
            itemBuilder: (context, index) {
              final style = _filteredStyles[index];
              final isSelected = widget.controller.selectedStyleId == style.id;
              return _StyleCard(
                style: style,
                isSelected: isSelected,
                onTap: () => _openStyleControls(style),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(TerraceSpacing.base),
      child: Column(
        children: [
          TextField(
            onChanged: (v) => setState(() => _searchQuery = v),
            style: const TextStyle(color: TerraceColors.ink0),
            decoration: InputDecoration(
              hintText: 'Search styles (e.g., Cozy, Modern)...',
              prefixIcon: const Icon(Icons.search, color: TerraceColors.muted),
              filled: true,
              fillColor: TerraceColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(TerraceTokens.radiusMedium),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    final filters = ['All', 'Cozy', 'Modern', 'Romantic', 'Party', 'Small'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: TerraceSpacing.base),
      child: Row(
        children: filters.map((f) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: FilterChip(
            label: Text(f),
            selected: _selectedFilter == f,
            onSelected: (v) => setState(() => _selectedFilter = f),
            backgroundColor: TerraceColors.surface,
            selectedColor: TerraceColors.metallicGold,
            checkmarkColor: TerraceColors.soleBlack,
            labelStyle: TextStyle(
              color: _selectedFilter == f ? TerraceColors.soleBlack : TerraceColors.ink0,
            ),
          ),
        )).toList(),
      ),
    );
  }
}

class _StyleCard extends StatelessWidget {
  final StyleDefinition style;
  final bool isSelected;
  final VoidCallback onTap;

  const _StyleCard({
    required this.style,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(TerraceTokens.radiusMedium),
          color: TerraceColors.surface,
          border: isSelected ? Border.all(color: TerraceColors.metallicGold, width: 2) : null,
          boxShadow: TerraceShadows.card,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(TerraceTokens.radiusMedium),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Use SvgPicture if possible, or placeholder
              // Since we added flutter_svg, we can try using it, but need to handle errors or ensure file exists.
              // For safety in this environment without pub get, I'll use a Container color based on hash or just a placeholder widget.
              // Actually, I'll try to use SvgPicture.asset. If it fails to compile because import missing (package not got), I'll catch it?
              // No, import is there.
              SvgPicture.asset(
                style.imagePath,
                fit: BoxFit.cover,
                placeholderBuilder: (_) => Container(color: TerraceColors.bg1),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withValues(alpha: 0.9)],
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      style.title,
                      style: TerraceText.h3.copyWith(fontSize: 16),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      style.tags.take(2).join(' • '),
                      style: TerraceText.caption.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    backgroundColor: TerraceColors.metallicGold,
                    radius: 12,
                    child: Icon(Icons.check, size: 16, color: TerraceColors.soleBlack),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
