import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:qr_barcode_app/core/config/app_config.dart';
import 'package:qr_barcode_app/data/ads/ads_initializer.dart';
import 'package:qr_barcode_app/domain/entities/app_failure.dart';

/// Pure frequency + cooldown gate (unit-testable).
class InterstitialFrequencyGate {
  InterstitialFrequencyGate({
    this.everyNActions = AdPolicy.interstitialEveryNActions,
    this.cooldown = AdPolicy.interstitialCooldown,
  });

  final int everyNActions;
  final Duration cooldown;

  int actionsSinceLastShow = 0;
  DateTime? lastShownAt;

  /// Records one relevant action. Returns true when an interstitial may show.
  bool recordAction({DateTime? now}) {
    final clock = now ?? DateTime.now();
    actionsSinceLastShow++;
    if (actionsSinceLastShow < everyNActions) return false;
    final last = lastShownAt;
    if (last != null && clock.difference(last) < cooldown) return false;
    return true;
  }

  void markShown({DateTime? now}) {
    actionsSinceLastShow = 0;
    lastShownAt = now ?? DateTime.now();
  }
}

/// Loads and shows interstitial ads with every-Nth-action + cooldown policy.
class InterstitialAdManager {
  InterstitialAdManager({InterstitialFrequencyGate? gate})
      : _gate = gate ?? InterstitialFrequencyGate();

  final InterstitialFrequencyGate _gate;
  InterstitialAd? _ad;
  bool _loading = false;
  bool _showing = false;

  bool get isReady => _ad != null;

  @visibleForTesting
  InterstitialFrequencyGate get gateForTest => _gate;

  Future<Result<void>> preload() async {
    await AdsInitializer.instance.ensureInitialized();
    if (!AdsInitializer.instance.isInitialized) {
      return const Err(AppFailure(AppFailureCode.adUnavailable));
    }
    if (_ad != null || _loading) return const Ok(null);

    return AdLoadMutex.run(() async {
      if (_ad != null || _loading) return const Ok(null);
      _loading = true;
      final completer = Completer<Result<void>>();

      try {
        await InterstitialAd.load(
          adUnitId: AdUnits.interstitial,
          request: const AdRequest(),
          adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (ad) {
              _ad = ad;
              _loading = false;
              if (!completer.isCompleted) completer.complete(const Ok(null));
            },
            onAdFailedToLoad: (error) {
              debugPrint(
                'Interstitial failed: code=${error.code} ${error.message}',
              );
              _ad = null;
              _loading = false;
              if (!completer.isCompleted) {
                completer.complete(
                  const Err(AppFailure(AppFailureCode.adUnavailable)),
                );
              }
            },
          ),
        );
      } catch (e) {
        _loading = false;
        if (!completer.isCompleted) {
          completer.complete(
            const Err(AppFailure(AppFailureCode.adUnavailable)),
          );
        }
      }

      return completer.future;
    });
  }

  /// Call after a relevant UX action (e.g. free export).
  /// Shows an interstitial only on every Nth action and after cooldown.
  Future<Result<void>> onRelevantAction() async {
    if (!_gate.recordAction()) return const Ok(null);
    return _showInternal(resetGateOnShow: true);
  }

  /// Legacy alias — prefer [onRelevantAction] so frequency capping applies.
  Future<Result<void>> showIfReady() => onRelevantAction();

  Future<Result<void>> _showInternal({required bool resetGateOnShow}) async {
    if (_showing) return const Ok(null);
    if (_ad == null) {
      await preload();
    }
    final ad = _ad;
    if (ad == null) return const Ok(null);

    _showing = true;
    final completer = Completer<Result<void>>();
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (shown) {
        shown.dispose();
        _ad = null;
        _showing = false;
        if (resetGateOnShow) _gate.markShown();
        if (!completer.isCompleted) completer.complete(const Ok(null));
        unawaited(preload());
      },
      onAdFailedToShowFullScreenContent: (shown, error) {
        debugPrint('Interstitial show failed: ${error.message}');
        shown.dispose();
        _ad = null;
        _showing = false;
        if (!completer.isCompleted) completer.complete(const Ok(null));
        unawaited(preload());
      },
    );

    _ad = null;
    try {
      await ad.show();
    } catch (e) {
      _showing = false;
      debugPrint('Interstitial show threw: $e');
      return const Ok(null);
    }
    return completer.future;
  }

  void dispose() {
    _ad?.dispose();
    _ad = null;
  }
}
