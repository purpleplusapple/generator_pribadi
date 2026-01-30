// lib/screens/wizard/wizard_controller.dart
// State management for Barbershop AI Wizard

import 'package:flutter/foundation.dart';
import '../../model/barber_config.dart';
import '../../model/image_result_data.dart';

enum WizardStep {
  upload,   // 0
  style,    // 1
  result,   // 2
}

class WizardController extends ChangeNotifier {
  int _currentStep = 0;
  BarberConfig _config = BarberConfig.empty();

  // Getters
  int get currentStep => _currentStep;
  WizardStep get currentWizardStep => WizardStep.values[_currentStep];

  BarberConfig get config => _config;
  String? get selectedImagePath => _config.originalImagePath;
  String? get selectedStyleId => _config.selectedStyleId;

  // Validation logic
  bool canProceedFromStep(int step) {
    switch (step) {
      case 0: // Upload
        return _config.originalImagePath != null;

      case 1: // Style
        return _config.selectedStyleId != null;

      case 2: // Result
        return true;

      default:
        return false;
    }
  }

  // Navigation methods
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

  void goToStep(int step) {
    if (step >= 0 && step <= 2) {
      _currentStep = step;
      notifyListeners();
    }
  }

  // Data setters
  void setSelectedImage(String? path) {
    _config = _config.copyWith(originalImagePath: path);
    notifyListeners();
  }

  void setStyleId(String id) {
    _config = _config.copyWith(selectedStyleId: id);
    notifyListeners();
  }

  void updateControl(String key, dynamic value) {
    _config = _config.updateControl(key, value);
    notifyListeners();
  }

  void setResultData(ImageResultData? data) {
    _config = _config.copyWith(resultData: data);
    notifyListeners();
  }

  void resetWizard() {
    _currentStep = 0;
    _config = BarberConfig.empty();
    notifyListeners();
  }
}
