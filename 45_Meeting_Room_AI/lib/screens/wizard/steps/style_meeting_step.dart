// lib/screens/wizard/steps/style_meeting_step.dart
// Style selection with Moodboard Grid

import 'package:flutter/material.dart';
import '../../../theme/meeting_room_theme.dart';
import '../../../theme/meeting_tokens.dart';
import '../../../data/meeting_style_repository.dart';
import '../../../model/meeting_style.dart';
import '../wizard_controller.dart';
import '../components/style_control_sheet.dart';

class StyleMeetingStep extends StatefulWidget {
  const StyleMeetingStep({
    super.key,
    required this.controller,
  });

  final WizardController controller;

  @override
  State<StyleMeetingStep> createState() => _StyleMeetingStepState();
}

class _StyleMeetingStepState extends State<StyleMeetingStep> {
  final List<MeetingStyle> _styles = MeetingStyleRepository.styles;
  String _searchQuery = '';

  // Categories could be dynamic, but for now hardcoded filter
  final List<String> _filters = ['All', 'Executive', 'Modern', 'Creative', 'Tech'];
  String _selectedFilter = 'All';

  List<MeetingStyle> get _filteredStyles {
    return _styles.where((s) {
      final matchesSearch = s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                          s.description.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilter = _selectedFilter == 'All' || s.name.contains(_selectedFilter) || s.description.contains(_selectedFilter); // Simple fuzzy match for demo
      return matchesSearch && matchesFilter;
    }).toList();
  }

  void _onStyleTap(MeetingStyle style) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StyleControlSheet(
        style: style,
        onApply: (values) {
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
        // Search & Filter
        Container(
          padding: const EdgeInsets.all(16),
          color: MeetingTokens.bg0,
          child: Column(
            children: [
              TextField(
                onChanged: (v) => setState(() => _searchQuery = v),
                style: MeetingRoomText.body,
                decoration: InputDecoration(
                  hintText: 'Search styles...',
                  prefixIcon: const Icon(Icons.search, color: MeetingTokens.muted),
                  filled: true,
                  fillColor: MeetingTokens.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(MeetingTokens.radiusMD),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 32,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _filters.length,
                  separatorBuilder: (c, i) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final filter = _filters[index];
                    final isSelected = _selectedFilter == filter;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedFilter = filter),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected ? MeetingTokens.accent : MeetingTokens.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? MeetingTokens.accent : MeetingTokens.line,
                          ),
                        ),
                        child: Text(
                          filter,
                          style: MeetingRoomText.small.copyWith(
                            color: isSelected ? MeetingTokens.ink0 : MeetingTokens.muted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        // Grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 columns
              childAspectRatio: 0.85, // Taller cards
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: _filteredStyles.length,
            itemBuilder: (context, index) {
              final style = _filteredStyles[index];
              final isSelected = widget.controller.selectedStyleId == style.id;

              return GestureDetector(
                onTap: () => _onStyleTap(style),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: MeetingTokens.surface,
                    borderRadius: BorderRadius.circular(MeetingTokens.radiusLG),
                    border: Border.all(
                      color: isSelected ? MeetingTokens.accent : MeetingTokens.line,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected ? [
                      BoxShadow(
                        color: MeetingTokens.accent.withValues(alpha: 0.3),
                        blurRadius: 12,
                      )
                    ] : [],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Moodboard Collage (2x2)
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(MeetingTokens.radiusLG)),
                          child: _buildMoodboardCollage(style),
                        ),
                      ),
                      // Info
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              style.name,
                              style: MeetingRoomText.bodySemiBold.copyWith(fontSize: 13),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              style.description,
                              style: MeetingRoomText.small.copyWith(fontSize: 10),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMoodboardCollage(MeetingStyle style) {
    // 2x2 Grid using Column/Row
    final images = style.moodboardImages;
    // Ensure we have 4 images (fallback logic handled in repo, but double check)
    if (images.length < 4) return Container(color: Colors.grey);

    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildTile(images[0])),
              const SizedBox(width: 1),
              Expanded(child: _buildTile(images[1])),
            ],
          ),
        ),
        const SizedBox(height: 1),
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildTile(images[2])),
              const SizedBox(width: 1),
              Expanded(child: _buildTile(images[3])),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTile(String path) {
    return Image.asset(
      path,
      fit: BoxFit.cover,
      errorBuilder: (c, e, s) => Container(color: MeetingTokens.surface2),
    );
  }
}
