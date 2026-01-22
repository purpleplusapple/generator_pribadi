// lib/screens/wizard/wizard_controller.dart
// State management for the 5-step wizard flow

import 'package:flutter/foundation.dart';
import '../../model/rooftop_config.dart';
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
  RooftopConfig _config = RooftopConfig.empty();


  // Getters
  int get currentStep => _currentStep;
  WizardStep get currentWizardStep => WizardStep.values[_currentStep];
  bool get isFirstStep => _currentStep == 0;
  bool get isLastStep => _currentStep == 4;

  RooftopConfig get config => _config;
  String? get selectedImagePath => _config.originalImagePath;
  Map<String, String> get styleSelections => _config.styleSelections;
  String? get reviewNotes => _config.reviewNotes;
  ImageResultData? get resultData => _config.resultData;

  // Validation logic
  bool canProceedFromStep(int step) {
    switch (step) {
      case 0: // Upload
        return _config.hasOriginalImage;

      case 1: // Style
        return _config.hasMinimumStyleSelections;

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
        return 'Please upload a laundry room photo to continue';
      case 1:
        return 'Please select at least 2 style options to continue';
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

  void setStyleSelection(String category, String value) {
    _config = _config.addStyleSelection(category, value);
    notifyListeners();
  }

  void removeStyleSelection(String category) {
    _config = _config.removeStyleSelection(category);
    notifyListeners();
  }

  void setReviewNotes(String? notes) {
    _config = _config.copyWith(reviewNotes: notes);
    notifyListeners();
  }

  void setResultData(ImageResultData? data) {
    _config = _config.copyWith(resultData: data);
    notifyListeners();
  }

  // Reset wizard to initial state
  void resetWizard() {
    _currentStep = 0;
    _config = RooftopConfig.empty();
    notifyListeners();
  }

  @override
  void dispose() {
    // Clean up if needed
    super.dispose();
  }
}
