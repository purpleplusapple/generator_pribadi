import 'package:flutter/foundation.dart';
import '../../model/camper_ai_config.dart';
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
  CamperAIConfig _config = CamperAIConfig.empty();

  // Getters
  int get currentStep => _currentStep;
  WizardStep get currentWizardStep => WizardStep.values[_currentStep];

  CamperAIConfig get config => _config;
  String? get selectedImagePath => _config.originalImagePath;
  String? get selectedStyleId => _config.selectedStyleId;
  Map<String, dynamic> get styleControlValues => _config.styleControlValues;

  ImageResultData? get resultData => _config.resultData;

  // Validation logic
  bool canProceedFromStep(int step) {
    switch (step) {
      case 0: return _config.hasOriginalImage;
      case 1: return _config.hasStyleSelected;
      default: return true;
    }
  }

  String? getValidationMessage(int step) {
    if (canProceedFromStep(step)) return null;
    switch (step) {
      case 0: return 'Please upload a photo of your van interior';
      case 1: return 'Please select a design style';
      default: return null;
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

  // Data setters
  void setSelectedImage(String? path) {
    _config = _config.copyWith(originalImagePath: path);
    notifyListeners();
  }

  void setSelectedStyle(String? styleId) {
    _config = _config.copyWith(selectedStyleId: styleId);
    notifyListeners();
  }

  void updateStyleControl(String key, dynamic value) {
    final newControls = Map<String, dynamic>.from(_config.styleControlValues);
    newControls[key] = value;
    _config = _config.copyWith(styleControlValues: newControls);
    notifyListeners();
  }

  void setStyleControls(Map<String, dynamic> controls) {
    _config = _config.copyWith(styleControlValues: controls);
    notifyListeners();
  }

  void setResultData(ImageResultData? data) {
    _config = _config.copyWith(resultData: data);
    notifyListeners();
  }

  void resetWizard() {
    _currentStep = 0;
    _config = CamperAIConfig.empty();
    notifyListeners();
  }
}
