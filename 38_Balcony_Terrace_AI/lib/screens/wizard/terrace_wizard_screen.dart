import 'dart:io';
import 'package:flutter/material.dart';
import '../../theme/design_tokens.dart';
import '../../theme/terrace_theme.dart';
import '../../widgets/wizard/wizard_rail_stepper.dart';
import '../../widgets/wizard/night_upload_assist.dart';
import 'style_step/category_gallery.dart';
import 'style_step/control_sheet.dart';
import 'style_step/advanced_custom_view.dart';
import '../../data/style_categories.dart';
import '../../services/terrace_prompt_builder.dart';
import '../result/terrace_result_screen.dart'; // Will create next

class TerraceWizardScreen extends StatefulWidget {
  const TerraceWizardScreen({super.key});

  @override
  State<TerraceWizardScreen> createState() => _TerraceWizardScreenState();
}

class _TerraceWizardScreenState extends State<TerraceWizardScreen> {
  int _currentStep = 0;
  File? _selectedImage;

  // Style Data
  StyleCategory? _selectedCategory;
  final Map<String, dynamic> _controlValues = {};
  String _userNote = '';

  // Advanced Custom Data
  bool _isAdvancedCustom = false;
  String _customPrompt = '';
  String _customNegative = '';
  double _customStrictness = 60;

  final List<String> _steps = ['Upload', 'Style', 'Generate'];

  void _onImageSelected(File image) {
    setState(() => _selectedImage = image);
  }

  void _goToStyle() {
    if (_selectedImage == null) return;
    setState(() => _currentStep = 1);
  }

  void _onCategorySelected(StyleCategory category) {
    setState(() {
      _selectedCategory = category;
      _isAdvancedCustom = false;
      _controlValues.clear();
      // Initialize defaults
      for (var c in category.controls) {
        if (c.defaultValue != null) {
          _controlValues[c.id] = c.defaultValue;
        } else if (c.type == ControlType.chips || c.type == ControlType.toggle) {
           if (c.options != null && c.options!.isNotEmpty) {
             _controlValues[c.id] = c.options!.first;
           }
        }
      }
    });

    _showControlSheet(category);
  }

  void _onCustomAdvancedSelected() {
    setState(() => _isAdvancedCustom = true);
    // Show Advanced Custom View (Full screen or sheet? Let's do full screen overlay in content area)
    // Actually, I'll handle it in the build method
  }

  void _showControlSheet(StyleCategory category) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => ControlSheet(
          category: category,
          currentValues: _controlValues,
          onValueChanged: (id, val) {
            setState(() => _controlValues[id] = val);
          },
          onUserNoteChanged: (val) {
            setState(() => _userNote = val);
          },
          onApply: () {
            Navigator.pop(context); // Close sheet
            _generate();
          },
          onReset: () {
            // Reset logic if needed
          },
        ),
      ),
    );
  }

  void _generate() {
    if (_selectedImage == null) return;

    // Build Prompt
    String finalPrompt = '';
    if (_isAdvancedCustom) {
      finalPrompt = TerracePromptBuilder.buildPrompt(
        category: terraceCategories.first, // Dummy, ignored
        controlValues: {},
        userNote: _userNote, // Additional notes
        customPromptOverride: _customPrompt,
        isAdvancedCustom: true,
      );
    } else if (_selectedCategory != null) {
      finalPrompt = TerracePromptBuilder.buildPrompt(
        category: _selectedCategory!,
        controlValues: _controlValues,
        userNote: _userNote,
      );
    } else {
      return;
    }

    // Navigate to Result Screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TerraceResultScreen(
          originalImage: _selectedImage!,
          prompt: finalPrompt,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.bg0,
      appBar: AppBar(
        title: const Text('Makeover Wizard'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Row(
        children: [
          // Rail
          WizardRailStepper(
            currentStep: _currentStep,
            steps: _steps,
            onStepTapped: (step) {
              if (step < _currentStep) {
                setState(() => _currentStep = step);
              }
            },
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_currentStep == 0) {
      return NightUploadAssistPanel(
        onImageSelected: _onImageSelected,
        onNext: _goToStyle,
      );
    } else if (_currentStep == 1) {
      if (_isAdvancedCustom) {
        return AdvancedCustomView(
          onApply: (prompt, negative, strictness) {
            setState(() {
              _customPrompt = prompt;
              _customNegative = negative;
              _customStrictness = strictness;
            });
            _generate();
          },
          onCancel: () => setState(() => _isAdvancedCustom = false),
        );
      }

      return CategoryGallery(
        onCategorySelected: _onCategorySelected,
        onCustomAdvancedSelected: _onCustomAdvancedSelected,
      );
    }

    return const Center(child: CircularProgressIndicator());
  }
}
