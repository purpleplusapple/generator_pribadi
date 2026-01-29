// lib/screens/wizard/wizard_controller.dart
// State management for the wizard flow

import 'package:flutter/foundation.dart';
import '../../model/terrace_ai_config.dart';
import '../../model/image_result_data.dart';

enum WizardStep {
  upload,   // 0
  style,    // 1
  review,   // 2 (Optional, might skip)
  preview,  // 3
  result,   // 4
}

class WizardController extends ChangeNotifier {
  int _currentStep = 0;
  TerraceAIConfig _config = TerraceAIConfig.empty();


  // Getters
  int get currentStep => _currentStep;
  WizardStep get currentWizardStep => WizardStep.values[_currentStep];
  bool get isFirstStep => _currentStep == 0;
  bool get isLastStep => _currentStep == 4;

  TerraceAIConfig get config => _config;
  String? get selectedImagePath => _config.originalImagePath;
  String? get selectedStyleId => _config.selectedStyleId;
  Map<String, dynamic> get controlValues => _config.controlValues;
  ImageResultData? get resultData => _config.resultData;

  // Validation logic
  bool canProceedFromStep(int step) {
    switch (step) {
      case 0: // Upload
        return _config.hasOriginalImage;
      case 1: // Style
        return _config.hasStyle;
      default:
        return true;
    }
  }

  String? getValidationMessage(int step) {
    if (canProceedFromStep(step)) return null;

    switch (step) {
      case 0:
        return 'Please upload a photo to continue';
      case 1:
        return 'Please select a style to continue';
      default:
        return 'Unable to proceed';
    }
  }

  // Navigation methods
  void nextStep() {
    if (_currentStep < 4 && canProceedFromStep(_currentStep)) {
      _currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step <= 4) {
      _currentStep = step;
      notifyListeners();
    }
  }

  // Data setters
  void setSelectedImage(String? path) {
    _config = _config.copyWith(originalImagePath: path);
    notifyListeners();
  }

  void setStyle(String id, Map<String, dynamic> values) {
    _config = _config.copyWith(
      selectedStyleId: id,
      controlValues: values,
    );
    notifyListeners();
  }

  Map<String, dynamic>? getStyleValues(String id) {
    if (_config.selectedStyleId == id) {
      return _config.controlValues;
    }
    return null;
  }

  void setResultData(ImageResultData? data) {
    _config = _config.copyWith(resultData: data);
    notifyListeners();
  }

  void resetWizard() {
    _currentStep = 0;
    _config = TerraceAIConfig.empty();
    notifyListeners();
  }
}
