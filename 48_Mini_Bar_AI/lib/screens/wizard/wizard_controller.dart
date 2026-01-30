// lib/screens/wizard/wizard_controller.dart
import 'package:flutter/foundation.dart';
import '../../model/mini_bar_config.dart';
import '../../model/image_result_data.dart';

class WizardController extends ChangeNotifier {
  int _currentStep = 0;
  MiniBarConfig _config = MiniBarConfig.empty();

  int get currentStep => _currentStep;
  bool get isFirstStep => _currentStep == 0;
  bool get isLastStep => _currentStep == 4;

  MiniBarConfig get config => _config;

  // Validation logic
  bool canProceedFromStep(int step) {
    switch (step) {
      case 0: return _config.originalImagePath != null;
      case 1: return _config.selectedStyleId != null; // Changed requirement
      default: return true;
    }
  }

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

  void setImage(String? path) {
    _config = _config.copyWith(originalImagePath: path);
    notifyListeners();
  }

  void setStyleId(String id) {
    _config = _config.copyWith(selectedStyleId: id);
    // Reset controls when style changes? Maybe not for now to keep it simple
    notifyListeners();
  }

  void updateControl(String key, dynamic value) {
    _config = _config.updateControl(key, value);
    notifyListeners();
  }

  void setResult(ImageResultData? data) {
    _config = _config.copyWith(resultData: data);
    notifyListeners();
  }

  void resetWizard() {
    _currentStep = 0;
    _config = MiniBarConfig.empty();
    notifyListeners();
  }
}
