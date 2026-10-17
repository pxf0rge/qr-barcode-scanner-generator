import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:qr_barcode_app/core/config/app_config.dart';

/// Serializes AdMob load calls — parallel loads often fail with
/// "Unable to obtain a JavascriptEngine" on WebView-heavy devices.
class AdLoadMutex {
  static Future<void>? _tail;

  static Future<T> run<T>(Future<T> Function() action) async {
    final previous = _tail;
    final gate = Completer<void>();
    _tail = gate.future;
    if (previous != null) {
      try {
        await previous;
      } catch (_) {}
    }
    try {
      return await action();
    } finally {
      if (!gate.isCompleted) gate.complete();
    }
  }
}

/// Initializes the Mobile Ads SDK once.
class AdsInitializer {
  AdsInitializer._();

  static final AdsInitializer instance = AdsInitializer._();

  bool _initialized = false;
  Future<void>? _initializing;

  bool get isInitialized => _initialized;

  /// Safe to call multiple times; waits if init is already in progress.
  Future<void> ensureInitialized() async {
    if (_initialized) return;
    if (_initializing != null) {
      await _initializing;
      return;
    }
    _initializing = initialize();
    try {
      await _initializing;
    } finally {
      _initializing = null;
    }
  }

  Future<void> initialize() async {
    if (_initialized) return;

    // Family-friendly: G rating for all requests (before SDK init).
    // Sample test devices only when USE_SAMPLE_ADS=true.
    MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(
        maxAdContentRating: MaxAdContentRating.g,
        testDeviceIds: AppEnvironment.useSampleAds
            ? const [
                '63A6A205D184428FA82440633D3810F9',
                'FE4EFE30C7AA5E08C737E972420E5B8B',
              ]
            : null,
      ),
    );

    // Let any prior UMP WebView fully release before Ads JS engine starts.
    await Future<void>.delayed(const Duration(milliseconds: 1200));

    final status = await MobileAds.instance.initialize();
    if (kDebugMode) {
      debugPrint(
        'Ads env sample=${AppEnvironment.useSampleAds} '
        'banner=${AdUnits.banner} '
        'rewarded=${AdUnits.rewarded} '
        'maxContent=G',
      );
      for (final entry in status.adapterStatuses.entries) {
        debugPrint(
          'Ads adapter ${entry.key}: ${entry.value.state} '
          '${entry.value.description}',
        );
      }
    }

    // Brief settle time — avoids JavascriptEngine race right after init.
    await Future<void>.delayed(const Duration(milliseconds: 800));
    _initialized = true;
  }
}
