// lib/services/premium_gate_service.dart
// Premium gate and quota management service

import '../services/preferences_service.dart';
import '../src/constant.dart';

class PremiumGateService {
  /// Storage key for generation count (kept for potential future use)
  static const String _generationCountKey = 'generation_count';
  
  final PreferencesService _prefs = PreferencesService.instance;

  /// Check if user has premium subscription
  Future<bool> hasPremium() async {
    // Developer mode bypasses premium checks
    final devMode = await isDeveloperModeEnabled();
    if (devMode) return true;
    
    return await checkPremiumFresh();
  }

  /// Check if user can generate (ONLY premium users can generate)
  /// Free users must upgrade to premium to use AI generation
  Future<bool> canGenerate() async {
    // Only premium users can generate - no free tier generations
    return await hasPremium();
  }

  /// Get current generation count (kept for backward compatibility)
  Future<int> getGenerationCount() async {
    return _prefs.getInt(_generationCountKey) ?? 0;
  }

  /// Get remaining generations
  /// Returns -1 for premium (unlimited daily quota)
  /// Returns 0 for free users (no generations available)
  Future<int> getRemainingGenerations() async {
    if (await hasPremium()) {
      return -1; // Daily quota managed separately
    }

    // Free users have no generations available
    return 0;
  }

  /// Increment generation counter (kept for tracking purposes)
  Future<void> incrementGenerationCount() async {
    // Only track for premium users now
    final current = await getGenerationCount();
    await _prefs.setInt(_generationCountKey, current + 1);
  }

  /// Reset quota (for debugging)
  Future<void> resetQuota() async {
    await _prefs.remove(_generationCountKey);
  }

  /// Get quota status message
  Future<String> getQuotaStatusMessage() async {
    if (await hasPremium()) {
      return 'Premium: 10 daily generations + unlimited with tokens';
    }

    // Free users need to upgrade
    return 'Upgrade to Premium to use AI generation';
  }
}
