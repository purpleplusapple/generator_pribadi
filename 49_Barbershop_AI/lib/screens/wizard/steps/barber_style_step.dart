import 'package:flutter/material.dart';
import '../../../theme/barber_theme.dart';
import '../../../model/style_repository.dart';
import '../../../widgets/moodboard_style_card.dart';
import '../../../widgets/style_control_sheet.dart';
import '../wizard_controller.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class BarberStyleStep extends StatelessWidget {
  final WizardController controller;

  const BarberStyleStep({super.key, required this.controller});

  void _showControls(BuildContext context, String styleId) {
    // Set style first
    controller.setStyleId(styleId);

    final style = StyleRepository.getById(styleId);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (_, scrollController) => StyleControlSheet(
          style: style,
          currentConfig: controller.config,
          onUpdate: (key, value) {
            controller.updateControl(key, value);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final styles = StyleRepository.styles;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search, color: BarberTheme.muted),
              hintText: "Search styles...",
              fillColor: BarberTheme.surface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            ),
          ),
        ),
        Expanded(
          child: MasonryGridView.count(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            itemCount: styles.length,
            itemBuilder: (context, index) {
              final style = styles[index];
              return SizedBox(
                height: 240, // Fixed height for masonry items to look like cards
                child: ListenableBuilder(
                  listenable: controller,
                  builder: (context, _) {
                    return MoodboardStyleCard(
                      style: style,
                      isSelected: controller.selectedStyleId == style.id,
                      onTap: () => _showControls(context, style.id),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
