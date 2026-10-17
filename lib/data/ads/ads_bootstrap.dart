import 'package:flutter/foundation.dart';

import 'package:qr_barcode_app/core/config/app_config.dart';
import 'package:qr_barcode_app/data/ads/ads_initializer.dart';
import 'package:qr_barcode_app/data/ads/consent_service.dart';
import 'package:qr_barcode_app/data/ads/interstitial_ad_manager.dart';
import 'package:qr_barcode_app/data/ads/rewarded_ad_manager.dart';

/// AdMob + UMP bootstrap. Safe to call multiple times; never blocks first paint.
class AdsBootstrap {
  static bool _started = false;
  static final RewardedAdManager rewarded = RewardedAdManager();
  static final InterstitialAdManager interstitial = InterstitialAdManager();

  static Future<void> run() async {
    if (kIsWeb || _started) return;
    _started = true;
    try {
      final consent = ConsentService();
      await consent.gather();

      // Consent / UMP WebView must fully release before Ads JS engine starts.
      await Future<void>.delayed(const Duration(milliseconds: 1500));

      final canRequest = await consent.canRequestAds();
      if (canRequest || kDebugMode || AppEnvironment.isDev) {
        await AdsInitializer.instance.ensureInitialized();
        // Stagger loads — parallel WebView ads trigger JavascriptEngine failures.
        await rewarded.preload(maxAttempts: 5);
        await Future<void>.delayed(const Duration(milliseconds: 800));
        await interstitial.preload();
      }
    } catch (e, st) {
      debugPrint('Ads bootstrap skipped: $e\n$st');
      _started = false;
    }
  }
}
