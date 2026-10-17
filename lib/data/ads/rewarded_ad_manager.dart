import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:qr_barcode_app/core/config/app_config.dart';
import 'package:qr_barcode_app/core/network/connectivity_gate.dart';
import 'package:qr_barcode_app/data/ads/ads_initializer.dart';
import 'package:qr_barcode_app/domain/entities/app_failure.dart';

typedef RewardEarned = void Function();

/// Loads and shows rewarded ads. Unlock only via [onUserEarnedReward]
/// (except an explicit debug-only bypass after repeated load failures).
class RewardedAdManager {
  RewardedAdManager({ConnectivityGate? connectivity})
      : _connectivity = connectivity ?? ConnectivityGate();

  final ConnectivityGate _connectivity;
  RewardedAd? _ad;
  bool _loading = false;

  bool get isReady => _ad != null;

  /// Debug builds only: unlock when sample ads fail so export can be tested.
  bool get allowDebugUnlockFallback => kDebugMode;

  Future<AppFailure> _unavailableFailure() async {
    if (await _connectivity.isOffline) {
      return const AppFailure(AppFailureCode.offlineAds);
    }
    return const AppFailure(AppFailureCode.adUnavailable);
  }

  Future<Result<void>> preload({int maxAttempts = 4}) async {
    await AdsInitializer.instance.ensureInitialized();
    if (!AdsInitializer.instance.isInitialized) {
      return Err(await _unavailableFailure());
    }
    if (await _connectivity.isOffline) {
      return const Err(AppFailure(AppFailureCode.offlineAds));
    }
    if (_ad != null) return const Ok(null);
    if (_loading) {
      for (var i = 0; i < 30 && _loading; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 200));
      }
      if (_ad != null) return const Ok(null);
    }

    Result<void> last = Err(await _unavailableFailure());
    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      last = await AdLoadMutex.run(_loadOnce);
      if (last.isOk) return last;
      // JavascriptEngine / network flakes need longer backoff.
      if (attempt < maxAttempts) {
        await Future<void>.delayed(Duration(milliseconds: 700 * attempt));
      }
    }
    return last;
  }

  Future<Result<void>> _loadOnce() async {
    if (_ad != null) return const Ok(null);
    _loading = true;
    final completer = Completer<Result<void>>();

    try {
      await RewardedAd.load(
        adUnitId: AdUnits.rewarded,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            _ad = ad;
            _loading = false;
            if (!completer.isCompleted) completer.complete(const Ok(null));
          },
          onAdFailedToLoad: (error) {
            debugPrint(
              'Rewarded failed: code=${error.code} domain=${error.domain} '
              'message=${error.message}',
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
    } catch (e, st) {
      debugPrint('Rewarded load threw: $e\n$st');
      _loading = false;
      if (!completer.isCompleted) {
        completer.complete(
          const Err(AppFailure(AppFailureCode.adUnavailable)),
        );
      }
    }

    final result = await completer.future;
    if (result.isErr && await _connectivity.isOffline) {
      return const Err(AppFailure(AppFailureCode.offlineAds));
    }
    return result;
  }

  /// Shows a rewarded ad. Calls [onEarned] only when the user earns the reward.
  Future<Result<void>> show({required RewardEarned onEarned}) async {
    await AdsInitializer.instance.ensureInitialized();

    if (!AdsInitializer.instance.isInitialized) {
      return Err(await _unavailableFailure());
    }
    if (await _connectivity.isOffline) {
      return const Err(AppFailure(AppFailureCode.offlineAds));
    }

    if (_ad == null) {
      final load = await preload();
      if (load.isErr) return load;
    }

    final ad = _ad;
    if (ad == null) {
      return Err(await _unavailableFailure());
    }

    final completer = Completer<Result<void>>();
    var earned = false;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _ad = null;
        if (!completer.isCompleted) {
          completer.complete(
            earned
                ? const Ok(null)
                : const Err(AppFailure(AppFailureCode.adNotEarned)),
          );
        }
        unawaited(preload());
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('Rewarded show failed: ${error.message}');
        ad.dispose();
        _ad = null;
        if (!completer.isCompleted) {
          completer.complete(
            const Err(AppFailure(AppFailureCode.adUnavailable)),
          );
        }
      },
    );

    _ad = null;
    await ad.show(
      onUserEarnedReward: (ad, reward) {
        earned = true;
        onEarned();
      },
    );

    return completer.future;
  }

  void dispose() {
    _ad?.dispose();
    _ad = null;
  }
}
