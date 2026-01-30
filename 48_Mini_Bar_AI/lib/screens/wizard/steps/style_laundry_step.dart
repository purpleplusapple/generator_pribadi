// lib/screens/wizard/steps/style_laundry_step.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../theme/mini_bar_theme.dart';
import '../../../../theme/design_tokens.dart';
import '../../../../model/mini_bar_style_def.dart';
import '../wizard_controller.dart';

class StyleLaundryStep extends StatelessWidget {
  final WizardController controller;

  const StyleLaundryStep({super.key, required this.controller});

  void _showControlSheet(BuildContext context, MiniBarStyle style) {
    // Select the style immediately upon tap
    controller.setStyleId(style.id);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _StyleControlSheet(style: style, controller: controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text('Choose Your Vibe', style: MiniBarText.h2),
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: kMiniBarStyles.length,
            itemBuilder: (context, index) {
              final style = kMiniBarStyles[index];
              final isSelected = controller.config.selectedStyleId == style.id;

              return GestureDetector(
                onTap: () => _showControlSheet(context, style),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(MiniBarRadii.k18),
                    border: isSelected
                        ? Border.all(color: MiniBarColors.primary, width: 2)
                        : Border.all(color: MiniBarColors.line),
                    color: MiniBarColors.surface,
                    boxShadow: isSelected ? MiniBarShadows.softAmber : [],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(MiniBarRadii.k18)),
                          child: SvgPicture.asset(
                            style.moodboardImage,
                            fit: BoxFit.cover,
                            placeholderBuilder: (_) => Container(color: MiniBarColors.surface2),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(style.name, style: MiniBarText.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 4),
                            Text('Customize', style: MiniBarText.small.copyWith(color: MiniBarColors.primary)),
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
}

class _StyleControlSheet extends StatefulWidget {
  final MiniBarStyle style;
  final WizardController controller;

  const _StyleControlSheet({required this.style, required this.controller});

  @override
  State<_StyleControlSheet> createState() => _StyleControlSheetState();
}

class _StyleControlSheetState extends State<_StyleControlSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: MiniBarColors.bg0,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(MiniBarRadii.k30)),
        border: Border(top: BorderSide(color: MiniBarColors.line.withValues(alpha: 0.5))),
      ),
      child: Column(
        children: [
          // Drag Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 20),
              width: 40, height: 4,
              decoration: BoxDecoration(color: MiniBarColors.line, borderRadius: BorderRadius.circular(2)),
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                Row(
                  children: [
                    Expanded(child: Text(widget.style.name, style: MiniBarText.h2)),
                    IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                  ],
                ),
                Text(widget.style.description, style: MiniBarText.body.copyWith(color: MiniBarColors.muted)),
                const SizedBox(height: 24),

                // Moodboard Preview
                AspectRatio(
                  aspectRatio: 16/9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(MiniBarRadii.k18),
                    child: SvgPicture.asset(widget.style.moodboardImage, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 32),

                ...widget.style.controls.map((def) => _buildControl(def)),

                const SizedBox(height: 40),
              ],
            ),
          ),

          // Apply Button
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Apply Style'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControl(StyleControlDef def) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(def.label, style: MiniBarText.h4),
          const SizedBox(height: 12),
          _buildInput(def),
        ],
      ),
    );
  }

  Widget _buildInput(StyleControlDef def) {
    final currentVal = widget.controller.config.controlValues[def.id] ?? def.defaultValue;

    switch (def.type) {
      case ControlType.chip:
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: (def.options ?? []).map((opt) {
            final isSelected = currentVal == opt;
            return ChoiceChip(
              label: Text(opt),
              selected: isSelected,
              selectedColor: MiniBarColors.primary,
              backgroundColor: MiniBarColors.surface2,
              labelStyle: TextStyle(color: isSelected ? MiniBarColors.bg0 : MiniBarColors.ink0),
              onSelected: (val) {
                if (val) widget.controller.updateControl(def.id, opt);
                setState(() {});
              },
            );
          }).toList(),
        );

      case ControlType.slider:
        return Row(
          children: [
            Expanded(
              child: Slider(
                value: (currentVal as num).toDouble(),
                min: def.min ?? 0,
                max: def.max ?? 100,
                divisions: def.divisions,
                activeColor: MiniBarColors.primary,
                inactiveColor: MiniBarColors.line,
                onChanged: (val) {
                  widget.controller.updateControl(def.id, val);
                  setState(() {});
                },
              ),
            ),
            Text(currentVal.toStringAsFixed(0), style: MiniBarText.small),
          ],
        );

      case ControlType.toggle:
        return SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(currentVal ? 'Enabled' : 'Disabled', style: MiniBarText.body),
          value: currentVal as bool,
          activeColor: MiniBarColors.primary,
          onChanged: (val) {
            widget.controller.updateControl(def.id, val);
            setState(() {});
          },
        );

      case ControlType.text:
        return TextField(
          controller: TextEditingController(text: currentVal as String)
            ..selection = TextSelection.collapsed(offset: (currentVal).length),
          onChanged: (val) => widget.controller.updateControl(def.id, val),
          maxLines: 3,
          style: MiniBarText.body,
        );

      default:
        return const SizedBox();
    }
  }
}
