import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../theme/storage_theme.dart';
import '../../widgets/wizard/wizard_rail_stepper.dart';
import 'upload_step_twopanel.dart';
import '../../data/storage_styles.dart';
import '../../widgets/style/moodboard_style_grid.dart';
import '../../widgets/style/style_control_sheet.dart';
import '../../services/prompt_builder.dart';
import '../result/result_page_storage.dart';

class WizardScreen extends StatefulWidget {
  const WizardScreen({super.key});

  @override
  State<WizardScreen> createState() => _WizardScreenState();
}

class _WizardScreenState extends State<WizardScreen> {
  int _currentStep = 0;
  File? _uploadedImage;
  StorageStyle? _selectedStyle;
  Map<String, dynamic> _controlValues = {};
  bool _isGenerating = false;

  final ImagePicker _picker = ImagePicker();

  void _onStepTapped(int step) {
    if (step < _currentStep) {
      setState(() => _currentStep = step);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source);
    if (picked != null) {
      setState(() {
        _uploadedImage = File(picked.path);
        _currentStep = 1;
      });
    }
  }

  void _onStyleSelected(StorageStyle style) {
    setState(() {
      _selectedStyle = style;
      // Initialize controls with defaults
      _controlValues = {
        for (var c in style.controls) c.id: c.defaultValue
      };
    });

    // Show controls immediately
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: SizedBox(
          height: MediaQuery.of(ctx).size.height * 0.75,
          child: StyleControlSheet(
            style: style,
            currentValues: _controlValues,
            onValueChanged: (k, v) => setState(() => _controlValues[k] = v),
          ),
        ),
      ),
    );
  }

  void _onGenerate() async {
    if (_uploadedImage == null || _selectedStyle == null) return;

    setState(() => _isGenerating = true);

    // Simulate generation
    await Future.delayed(const Duration(seconds: 3));

    // Build prompt for logging/debugging
    final prompt = PromptBuilder.buildPrompt(
      style: _selectedStyle!,
      controlValues: _controlValues
    );
    print("Generating with prompt: $prompt");

    if (!mounted) return;
    setState(() => _isGenerating = false);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ResultPageStorage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StorageColors.bg0,
      body: Row(
        children: [
          // Rail
          WizardRailStepper(
            currentStep: _currentStep,
            totalSteps: 3,
            stepNames: const ["UPLOAD", "STYLE", "GENERATE"],
          ),

          // Content
          Expanded(
            child: _isGenerating
                ? _buildLoading()
                : IndexedStack(
                    index: _currentStep,
                    children: [
                      _buildUploadStep(),
                      _buildStyleStep(),
                      _buildGenerateStep(), // Fallback/Placeholder
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadStep() {
    return UploadStepTwoPanel(
      onCameraTap: () => _pickImage(ImageSource.camera),
      onGalleryTap: () => _pickImage(ImageSource.gallery),
    );
  }

  Widget _buildStyleStep() {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Select Style", style: StorageTheme.darkTheme.textTheme.headlineMedium),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  hintText: "Search styles...",
                  prefixIcon: const Icon(Icons.search, color: StorageColors.muted),
                  filled: true,
                  fillColor: StorageColors.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
            ],
          ),
        ),

        // Grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            itemCount: storageStyles.length,
            itemBuilder: (context, index) {
              final style = storageStyles[index];
              return MoodboardStyleGrid(
                style: style,
                isSelected: _selectedStyle?.id == style.id,
                onTap: () => _onStyleSelected(style),
              );
            },
          ),
        ),

        // Action Bar
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: StorageColors.surface,
            border: Border(top: BorderSide(color: StorageColors.line)),
          ),
          child: Row(
            children: [
               if (_uploadedImage != null)
                 Container(
                   width: 40, height: 40,
                   margin: const EdgeInsets.only(right: 12),
                   child: ClipRRect(
                     borderRadius: BorderRadius.circular(8),
                     child: Image.file(_uploadedImage!, fit: BoxFit.cover),
                   ),
                 ),
               Expanded(
                 child: ElevatedButton(
                   onPressed: _selectedStyle != null ? _onGenerate : null,
                   style: ElevatedButton.styleFrom(
                     backgroundColor: StorageColors.primaryLime,
                     foregroundColor: Colors.black,
                   ),
                   child: const Text("GENERATE DESIGN"),
                 ),
               ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGenerateStep() {
    // Should generally be skipped by loading state, but for safety:
    return const Center(child: Text("Generating..."));
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: StorageColors.primaryLime),
          const SizedBox(height: 24),
          Text(
            "Designing your storage system...",
            style: StorageTheme.darkTheme.textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
