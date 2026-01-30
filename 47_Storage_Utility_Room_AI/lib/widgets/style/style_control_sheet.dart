import 'package:flutter/material.dart';
import '../../data/storage_styles.dart';
import '../../theme/storage_theme.dart';

class StyleControlSheet extends StatefulWidget {
  final StorageStyle style;
  final Map<String, dynamic> currentValues;
  final Function(String key, dynamic value) onValueChanged;

  const StyleControlSheet({
    super.key,
    required this.style,
    required this.currentValues,
    required this.onValueChanged,
  });

  @override
  State<StyleControlSheet> createState() => _StyleControlSheetState();
}

class _StyleControlSheetState extends State<StyleControlSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: StorageColors.bg1,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: StorageColors.line,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.style.name, style: StorageTheme.darkTheme.textTheme.headlineSmall),
                      Text("Customize your storage system", style: StorageTheme.darkTheme.textTheme.bodySmall),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: StorageColors.muted),
                ),
              ],
            ),
          ),

          const Divider(color: StorageColors.line),

          // Controls
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.all(24),
              itemCount: widget.style.controls.length,
              separatorBuilder: (_, __) => const SizedBox(height: 24),
              itemBuilder: (context, index) {
                final control = widget.style.controls[index];
                return _buildControl(control);
              },
            ),
          ),

          // Footer
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context), // Apply
                child: const Text("Apply Customizations"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControl(StyleControl control) {
    final value = widget.currentValues[control.id] ?? control.defaultValue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              control.label,
              style: const TextStyle(fontWeight: FontWeight.bold, color: StorageColors.ink0),
            ),
            if (control.helperText != null)
              Text(control.helperText!, style: const TextStyle(fontSize: 10, color: StorageColors.muted)),
          ],
        ),
        const SizedBox(height: 12),

        if (control.type == ControlType.slider)
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: (value is double) ? value : 0.5,
                  onChanged: (v) => widget.onValueChanged(control.id, v),
                  activeColor: StorageColors.primaryLime,
                  inactiveColor: StorageColors.line,
                ),
              ),
            ],
          )
        else if (control.type == ControlType.toggle)
          SwitchListTile(
            title: Text(value == true ? "Enabled" : "Disabled", style: const TextStyle(fontSize: 14)),
            value: value == true,
            onChanged: (v) => widget.onValueChanged(control.id, v),
            activeColor: StorageColors.primaryLime,
            contentPadding: EdgeInsets.zero,
            dense: true,
          )
        else if (control.type == ControlType.chips)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: control.options.map((opt) {
              final isSelected = opt == value;
              return FilterChip(
                label: Text(opt),
                selected: isSelected,
                onSelected: (sel) {
                  if (sel) widget.onValueChanged(control.id, opt);
                },
                backgroundColor: StorageColors.surface,
                selectedColor: StorageColors.primaryLime.withValues(alpha: 0.2),
                checkmarkColor: StorageColors.primaryLime,
                labelStyle: TextStyle(
                  color: isSelected ? StorageColors.primaryLime : StorageColors.ink1,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: isSelected ? StorageColors.primaryLime : StorageColors.line),
                ),
              );
            }).toList(),
          )
        else if (control.type == ControlType.select)
           DropdownButtonFormField<String>(
             value: value.toString(),
             dropdownColor: StorageColors.surface2,
             decoration: InputDecoration(
               filled: true,
               fillColor: StorageColors.surface,
               border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
               contentPadding: const EdgeInsets.symmetric(horizontal: 16),
             ),
             items: control.options.map((opt) => DropdownMenuItem(
               value: opt,
               child: Text(opt, style: const TextStyle(color: StorageColors.ink0)),
             )).toList(),
             onChanged: (v) => widget.onValueChanged(control.id, v),
           ),
      ],
    );
  }
}
