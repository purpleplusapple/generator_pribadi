// lib/screens/wizard/wizard_controller.dart
// State management for the 5-step wizard flow

import 'package:flutter/foundation.dart';
import '../../model/meeting_ai_config.dart';
import '../../model/image_result_data.dart';
import '../../model/meeting_style.dart';

enum WizardStep {
  upload,   // 0
  style,    // 1
  review,   // 2
  preview,  // 3
  result,   // 4
}

class WizardController extends ChangeNotifier {
  int _currentStep = 0;
  MeetingAIConfig _config = MeetingAIConfig.empty();


  // Getters
  int get currentStep => _currentStep;
  WizardStep get currentWizardStep => WizardStep.values[_currentStep];
  bool get isFirstStep => _currentStep == 0;
  bool get isLastStep => _currentStep == 4;

  MeetingAIConfig get config => _config;
  String? get selectedImagePath => _config.originalImagePath;
  String? get selectedStyleId => _config.styleSelection?.styleId;
  MeetingStyleSelection? get styleSelection => _config.styleSelection;
  String? get reviewNotes => _config.reviewNotes;
  ImageResultData? get resultData => _config.resultData;

  // Validation logic
  bool canProceedFromStep(int step) {
    switch (step) {
      case 0: // Upload
        return _config.hasOriginalImage;

      case 1: // Style
        return _config.hasStyleSelection;

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
        return 'Please upload a meeting room photo to continue';
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

  void setStyle(String styleId, Map<String, dynamic> controls) {
    _config = _config.setStyle(styleId, controls: controls);
    notifyListeners();
  }

  void updateControl(String key, dynamic value) {
    _config = _config.updateControl(key, value);
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
    _config = MeetingAIConfig.empty();
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
