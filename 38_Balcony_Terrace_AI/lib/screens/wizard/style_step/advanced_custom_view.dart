import 'package:flutter/material.dart';
import '../../../theme/design_tokens.dart';
import '../../../theme/terrace_theme.dart';

class AdvancedCustomView extends StatefulWidget {
  final Function(String, String, double) onApply;
  final VoidCallback onCancel;

  const AdvancedCustomView({
    super.key,
    required this.onApply,
    required this.onCancel,
  });

  @override
  State<AdvancedCustomView> createState() => _AdvancedCustomViewState();
}

class _AdvancedCustomViewState extends State<AdvancedCustomView> {
  final TextEditingController _promptController = TextEditingController();
  final TextEditingController _negativeController = TextEditingController();
  double _strictness = 60;
  bool _safetyAgreed = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: DesignTokens.bg0,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: DesignTokens.ink0),
                onPressed: widget.onCancel,
              ),
              const SizedBox(width: 8),
              Text('Advanced Custom', style: terraceTheme.textTheme.headlineMedium),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              children: [
                _buildSectionLabel('Custom Prompt'),
                const Text(
                  'Describe your terrace in detail. Mention lighting, materials, furniture, and mood.',
                  style: TextStyle(color: DesignTokens.muted, fontSize: 12),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _promptController,
                  maxLines: 6,
                  style: const TextStyle(color: DesignTokens.ink0),
                  decoration: const InputDecoration(
                    hintText: 'e.g. A cyberpunk balcony with neon blue lights, metal railing, futuristic chair...',
                  ),
                ),

                const SizedBox(height: 24),

                _buildSectionLabel('Negative Preferences'),
                const Text(
                  'What should NOT appear in the image?',
                  style: TextStyle(color: DesignTokens.muted, fontSize: 12),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _negativeController,
                  maxLines: 3,
                  style: const TextStyle(color: DesignTokens.ink0),
                  decoration: const InputDecoration(
                    hintText: 'e.g. no plants, no wooden floor, no day',
                  ),
                ),

                const SizedBox(height: 24),

                _buildSectionLabel('Strictness: ${_strictness.round()}%'),
                Slider(
                  value: _strictness,
                  min: 0,
                  max: 100,
                  activeColor: DesignTokens.primary,
                  onChanged: (val) => setState(() => _strictness = val),
                ),
                const Text(
                  'Higher values follow your prompt more strictly but may reduce realism.',
                  style: TextStyle(color: DesignTokens.muted, fontSize: 10),
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Checkbox(
                      value: _safetyAgreed,
                      activeColor: DesignTokens.primary,
                      onChanged: (val) => setState(() => _safetyAgreed = val ?? false),
                    ),
                    const Expanded(
                      child: Text(
                        'I agree to follow safety guidelines (no trademarked logos, no NSFW content).',
                        style: TextStyle(color: DesignTokens.ink1, fontSize: 12),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _safetyAgreed ? () {
                      widget.onApply(
                        _promptController.text,
                        _negativeController.text,
                        _strictness,
                      );
                    } : null,
                    child: const Text('Generate Custom Style'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: const TextStyle(
          color: DesignTokens.ink0,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
