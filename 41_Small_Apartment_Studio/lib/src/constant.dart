// lib/src/constant.dart
// RevenueCat + helper premium for Small Apartment Studio AI (iOS + Android ready)

import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'credits_vault.dart';
import 'mypaywall.dart';

// =================== API KEYS ===================
const googleApiKey = 'googl_api_key'; // Android (Play Store)
const amazonApiKey = 'amazon_api_key'; // Android (Amazon)
const appleApiKey = 'appl_aBocxOhQSTjTznCJIFnBEMhojVg'; // iOS

const appId = 'appbed7119798'; // optional helper identifier

const entitlementKey = 'apartment_pro'; // Updated entitlement
const int kPremiumDailyLimit = 10;

const tokenPack5Id = 'ai.small_apartment.token5';
const String kToken5ProductId = tokenPack5Id;

// =================== PREMIUM STATE ===================
final ValueNotifier<bool> _premiumState = ValueNotifier<bool>(false);
ValueListenable<bool> get premiumListenable => _premiumState;
final ValueNotifier<int> _premiumDailyUsage = ValueNotifier<int>(0);
ValueListenable<int> get premiumDailyUsageListenable => _premiumDailyUsage;
final ValueNotifier<int> _tokenBalance = ValueNotifier<int>(0);
ValueListenable<int> get tokenBalanceListenable => _tokenBalance;
StreamSubscription<int>? _tokenSubscription;

// =================== DEVELOPER MODE (Debug Only) ===================
const String _kDevModeKey = 'developer_mode_enabled';
bool _devModeEnabled = false;

/// Check if developer mode is enabled (bypasses premium checks for testing)
Future<bool> isDeveloperModeEnabled() async {
  final prefs = await SharedPreferences.getInstance();
  _devModeEnabled = prefs.getBool(_kDevModeKey) ?? false;
  return _devModeEnabled;
}

/// Enable/disable developer mode for testing premium features
Future<void> setDeveloperMode(bool enabled) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_kDevModeKey, enabled);
  _devModeEnabled = enabled;
  debugPrint('🔧 Developer Mode: ${enabled ? 'ENABLED ✅' : 'DISABLED ❌'}');
  if (enabled) {
    debugPrint('   → Premium checks will be BYPASSED for testing');
  }
}

// =================== INTERNAL GUARDS ===================
bool _paywallShowing = false;
const _justPurchasedKey = 'just_purchased_ms';
const _suppressMinutesAfterPurchase = 10;
const _kPremiumDailyKeyPrefix = 'custom_car_premium_daily_';

// =================== INIT ===================
Future<void> initRevenueCat() async {
  debugPrint('🚀 initRevenueCat() started...');
  await Purchases.setLogLevel(LogLevel.info);

  final apiKey = Platform.isIOS
      ? appleApiKey
      : (Platform.isAndroid ? googleApiKey : appleApiKey);

  final config = PurchasesConfiguration(apiKey);

  await Purchases.configure(config);
  debugPrint('✅ Purchases configured with API key: $apiKey');

  await checkPremiumFresh();
  debugPrint('🔄 Initial premium status checked.');
  await _syncDailyUsage();
  await _syncTokenBalance();
  _startTokenListener();

  startRevenueCatListeners();
  debugPrint('👂 RevenueCat listeners attached.');
}

// =================== LISTENER ===================
void startRevenueCatListeners() {
  Purchases.addCustomerInfoUpdateListener((customerInfo) async {
    final isPro = customerInfo.entitlements.active.containsKey(entitlementKey);
    debugPrint('📡 Premium listener fired → $isPro');
    _premiumState.value = isPro;
  });
}

Future<bool> checkPremium() async {
  try {
    debugPrint('🔍 checkPremium() called...');
    final info = await Purchases.getCustomerInfo();
    final isPro = info.entitlements.active.containsKey(entitlementKey);
    debugPrint('🔑 checkPremium → isPro: $isPro');
    _premiumState.value = isPro;
    return isPro;
  } catch (e) {
    debugPrint('❌ checkPremium failed: $e');
    return false;
  }
}

Future<bool> checkPremiumFresh() async {
  try {
    debugPrint('🔄 checkPremiumFresh() → invalidate cache...');
    await Purchases.invalidateCustomerInfoCache();
    final info = await Purchases.getCustomerInfo();
    final isPro = info.entitlements.active.containsKey(entitlementKey);
    debugPrint('🔑 checkPremiumFresh → isPro: $isPro');
    _premiumState.value = isPro;
    return isPro;
  } catch (e) {
    debugPrint('❌ checkPremiumFresh failed: $e');
    return false;
  }
}

Future<bool> presentPaywallGuarded(BuildContext context) async {
  if (_paywallShowing) {
    debugPrint('⚠️ Paywall already visible, ignoring duplicate request.');
    return false;
  }
  _paywallShowing = true;

  try {
    debugPrint('🟢 Opening Small Apartment Studio AI paywall...');
    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => const CustomCarPaywall(),
      ),
    );

    debugPrint('✅ Paywall closed by user or transaction finished.');

    final isPro = await checkPremiumFresh();
    debugPrint('🔑 Premium status after paywall: $isPro');
    return isPro;
  } catch (e, st) {
    debugPrint('❌ Paywall error: $e\n$st');
    return false;
  } finally {
    _paywallShowing = false;
    debugPrint('ℹ️ _paywallShowing reset → false.');
  }
}

Future<void> openPaywallFromUserAction(BuildContext context) async {
  debugPrint('👆 openPaywallFromUserAction() triggered by user.');
  if (await shouldSuppressPaywall()) {
    debugPrint('⏳ Paywall suppressed because a purchase just happened.');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('You’re all set — syncing your purchase…')),
      );
    }
    return;
  }
  await postPurchaseRefresh(
    context: context,
    alsoDo: () async {
      debugPrint('📲 Calling presentPaywallGuarded() via postPurchaseRefresh.');
      await presentPaywallGuarded(context);
    },
  );
}

Future<void> manageOrUpgrade(BuildContext context) async {
  debugPrint('⚙️ manageOrUpgrade() called.');
  await openPaywallFromUserAction(context);
}

Future<bool> restorePurchases() async {
  try {
    debugPrint('♻️ restorePurchases()…');
    await Purchases.restorePurchases();
    final isPro = await checkPremiumFresh();
    debugPrint('✅ restorePurchases → isPro: $isPro');
    return isPro;
  } catch (e) {
    debugPrint('❌ restorePurchases failed: $e');
    return false;
  }
}

Future<void> postPurchaseRefresh({
  required BuildContext context,
  Future<void> Function()? alsoDo,
}) async {
  debugPrint('🔄 postPurchaseRefresh() started...');

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(
      child: SizedBox(
        width: 56,
        height: 56,
        child: CircularProgressIndicator(strokeWidth: 3),
      ),
    ),
  );

  try {
    if (alsoDo != null) {
      debugPrint('▶️ Running alsoDo() (paywall / purchase)…');
      await alsoDo();
    }

    await Future.delayed(const Duration(milliseconds: 200));

    final info = await Purchases.getCustomerInfo();
    final isPro = info.entitlements.active.containsKey(entitlementKey);
    _premiumState.value = isPro;
    debugPrint('🔑 Immediate result → isPro: $isPro');

    if (!isPro) {
      for (int i = 0; i < 2; i++) {
        await Future.delayed(const Duration(milliseconds: 250));
        final retry = await Purchases.getCustomerInfo();
        final retryPro = retry.entitlements.active.containsKey(entitlementKey);
        debugPrint('🔁 Polling #$i → $retryPro');
        _premiumState.value = retryPro;
        if (retryPro) break;
      }
    }
  } finally {
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).maybePop();
      debugPrint('✅ Spinner dismissed.');
    }
  }
}

Future<void> _syncDailyUsage() async {
  try {
    final count = await getTodayPremiumCount();
    if (_premiumDailyUsage.value != count) {
      _premiumDailyUsage.value = count;
    }
  } catch (e) {
    debugPrint('❌ _syncDailyUsage failed: $e');
  }
}

Future<void> _syncTokenBalance() async {
  try {
    final balance = await CreditsVault.get();
    if (_tokenBalance.value != balance) {
      _tokenBalance.value = balance;
    }
  } catch (e) {
    debugPrint('❌ _syncTokenBalance failed: $e');
  }
}

void _startTokenListener() {
  if (_tokenSubscription != null) return;
  _tokenSubscription = CreditsVault.changes.listen((balance) {
    if (_tokenBalance.value != balance) {
      _tokenBalance.value = balance;
    }
  });
}

String _todayPremiumKey() {
  final now = DateTime.now();
  final month = now.month.toString().padLeft(2, '0');
  final day = now.day.toString().padLeft(2, '0');
  return '$_kPremiumDailyKeyPrefix${now.year}$month$day';
}

Future<int> getTodayPremiumCount() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt(_todayPremiumKey()) ?? 0;
}

Future<void> incrementTodayPremiumCount() async {
  final prefs = await SharedPreferences.getInstance();
  final key = _todayPremiumKey();
  final current = prefs.getInt(key) ?? 0;
  final next = current + 1;
  await prefs.setInt(key, next);
  if (_premiumDailyUsage.value != next) {
    _premiumDailyUsage.value = next;
  }
}

Future<void> markJustPurchased() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt(_justPurchasedKey, DateTime.now().millisecondsSinceEpoch);
  debugPrint('📝 markJustPurchased → timestamp stored.');
}

Future<bool> shouldSuppressPaywall() async {
  final prefs = await SharedPreferences.getInstance();
  final last = prefs.getInt(_justPurchasedKey) ?? 0;
  final diffMs = DateTime.now().millisecondsSinceEpoch - last;
  final suppress = diffMs < _suppressMinutesAfterPurchase * 60 * 1000;
  debugPrint('⏳ shouldSuppressPaywall → $suppress (diffMs=$diffMs)');
  return suppress;
}

Future<void> promptInAppReview() async {
  try {
    debugPrint('⭐ promptInAppReview() checking status…');
    final prefs = await SharedPreferences.getInstance();
    final lastReview = prefs.getInt('last_review') ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - lastReview > 86400000) {
      final inAppReview = InAppReview.instance;
      if (await inAppReview.isAvailable()) {
        debugPrint('📣 Requesting in-app review…');
        await inAppReview.requestReview();
        await prefs.setInt('last_review', now);
      }
    }
  } catch (e) {
    debugPrint('❌ promptInAppReview error: $e');
  }
}

Future<void> promptManualReview() async {
  debugPrint('🌟 promptManualReview() called.');
  final prefs = await SharedPreferences.getInstance();
  final lastReview = prefs.getInt('last_review') ?? 0;
  final now = DateTime.now().millisecondsSinceEpoch;
  if (now - lastReview > 86400000) {
    final inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
      debugPrint('📣 Requesting in-app review (manual).');
      await inAppReview.requestReview();
      await prefs.setInt('last_review', now);
    }
  }
}

class PremiumGateStatus {
  const PremiumGateStatus({
    required this.isPremium,
    required this.dailyCount,
    required this.dailyLimit,
    required this.tokenBalance,
  });

  final bool isPremium;
  final int dailyCount;
  final int dailyLimit;
  final int tokenBalance;

  bool get premiumHasQuota => isPremium && dailyCount < dailyLimit;
  bool get premiumLimitReached => isPremium && dailyCount >= dailyLimit;
  bool get tokensAvailable => tokenBalance > 0;
  bool get usingTokens => tokensAvailable && !premiumHasQuota;
}

class PremiumGate {
  PremiumGate._();

  static const int premiumDailyLimit = kPremiumDailyLimit;

  static Future<PremiumGateStatus> currentStatus({
    bool refreshPremium = false,
  }) async {
    if (refreshPremium) {
      await checkPremiumFresh();
    }
    await _syncDailyUsage();
    await _syncTokenBalance();
    return PremiumGateStatus(
      isPremium: _premiumState.value,
      dailyCount: _premiumDailyUsage.value,
      dailyLimit: premiumDailyLimit,
      tokenBalance: _tokenBalance.value,
    );
  }

  static Future<bool> shouldAllowGeneration(BuildContext context) async {
    // 🔧 DEVELOPER MODE OVERRIDE - Bypass all premium checks for testing
    await isDeveloperModeEnabled(); // Refresh dev mode state
    if (_devModeEnabled) {
      debugPrint('🔧 [DEV MODE] Allowing generation (bypassing premium check)');
      debugPrint('   → No quota consumed, no tokens used, no paywall shown');
      return true;
    }

    // Normal premium gate logic
    final status = await currentStatus(refreshPremium: true);

    if (status.premiumHasQuota) {
      await incrementTodayPremiumCount();
      return true;
    }

    if (status.tokensAvailable) {
      final consumed = await CreditsVault.consume(1);
      if (consumed) {
        await _syncTokenBalance();
        return true;
      }
    }

    final becamePremium = await presentPaywallGuarded(context);
    if (becamePremium) {
      final refreshed = await currentStatus(refreshPremium: true);
      if (refreshed.premiumHasQuota) {
        await incrementTodayPremiumCount();
      }
      return true;
    }

    return false;
  }
}
