// lib/screens/wizard/wizard_controller.dart
// State management for the 5-step wizard flow

import 'package:flutter/foundation.dart';
import '../../model/guest_ai_config.dart';
import '../../model/image_result_data.dart';

enum WizardStep {
  upload,   // 0
  style,    // 1
  review,   // 2
  preview,  // 3
  result,   // 4
}

class WizardController extends ChangeNotifier {
  int _currentStep = 0;
  GuestAIConfig _config = GuestAIConfig.empty();


  // Getters
  int get currentStep => _currentStep;
  WizardStep get currentWizardStep => WizardStep.values[_currentStep];
  bool get isFirstStep => _currentStep == 0;
  bool get isLastStep => _currentStep == 4;

  GuestAIConfig get config => _config;
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

      case 2: // Review
        return true;

      case 3: // Preview
        return true;

      case 4: // Result
        return true;

      default:
        return false;
    }
  }

  String? getValidationMessage(int step) {
    if (canProceedFromStep(step)) {
      return null;
    }

    switch (step) {
      case 0:
        return 'Please upload a guest room photo to continue';
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

  // Data setters (will be used by step widgets in later phases)
  void setSelectedImage(String? path) {
    _config = _config.copyWith(originalImagePath: path);
    notifyListeners();
  }

  void selectStyle(String styleId) {
    _config = _config.copyWith(selectedStyleId: styleId);
    notifyListeners();
  }

  void setControlValue(String key, dynamic value) {
    _config = _config.setControlValue(key, value);
    notifyListeners();
  }

  void setControlValues(Map<String, dynamic> values) {
    // Merge or replace
    Map<String, dynamic> newMap = Map.from(_config.controlValues)..addAll(values);
    _config = _config.copyWith(controlValues: newMap);
    notifyListeners();
  }

  void setResultData(ImageResultData? data) {
    _config = _config.copyWith(resultData: data);
    notifyListeners();
  }

  // Reset wizard to initial state
  void resetWizard() {
    _currentStep = 0;
    _config = GuestAIConfig.empty();
    notifyListeners();
  }

  @override
  void dispose() {
    // Clean up if needed
    super.dispose();
  }
}
