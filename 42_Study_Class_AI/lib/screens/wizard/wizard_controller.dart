// lib/screens/wizard/wizard_controller.dart
import 'package:flutter/foundation.dart';
import '../../model/study_ai_config.dart';
import '../../model/image_result_data.dart';

enum WizardStep {
  upload,   // 0
  style,    // 1
  result,   // 2
}

class WizardController extends ChangeNotifier {
  int _currentStep = 0;
  StudyAIConfig _config = StudyAIConfig.empty();

  int get currentStep => _currentStep;
  WizardStep get currentWizardStep => WizardStep.values[_currentStep];

  bool get isFirstStep => _currentStep == 0;
  bool get isLastStep => _currentStep == 2;

  StudyAIConfig get config => _config;
  String? get selectedImagePath => _config.originalImagePath;
  String? get selectedStyleId => _config.selectedStyleId;

  // Validation
  bool canProceedFromStep(int step) {
    switch (step) {
      case 0: // Upload
        return _config.hasOriginalImage;
      case 1: // Style
        return _config.hasStyle;
      case 2: // Result
        return true;
      default:
        return false;
    }
  }

  String? getValidationMessage(int step) {
    if (canProceedFromStep(step)) return null;
    switch (step) {
      case 0: return 'Please upload a photo of your study space.';
      case 1: return 'Please select a style to continue.';
      default: return null;
    }
  }

  // Navigation
  void nextStep() {
    if (_currentStep < 2 && canProceedFromStep(_currentStep)) {
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

  void setStep(int step) {
     if (step >= 0 && step <= 2) {
      _currentStep = step;
      notifyListeners();
    }
  }

  // Setters
  void setSelectedImage(String? path) {
    _config = _config.copyWith(originalImagePath: path);
    notifyListeners();
  }

  void setStyle(String styleId, Map<String, dynamic> controls) {
    _config = _config.copyWith(
      selectedStyleId: styleId,
      controlValues: controls,
    );
    notifyListeners();
  }

  void setResultData(ImageResultData? data) {
    _config = _config.copyWith(resultData: data);
    notifyListeners();
  }

  void resetWizard() {
    _currentStep = 0;
    _config = StudyAIConfig.empty();
    notifyListeners();
  }
}
