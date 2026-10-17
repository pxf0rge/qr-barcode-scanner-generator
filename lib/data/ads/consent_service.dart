import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';

/// UMP consent gathering for AdMob.
class ConsentService {
  ConsentService({ConsentInformation? consentInformation})
      : _consentInformation =
            consentInformation ?? ConsentInformation.instance;

  final ConsentInformation _consentInformation;

  /// Request consent info and show the form when required.
  Future<void> gather() async {
    final completer = Completer<void>();
    final params = ConsentRequestParameters();

    _consentInformation.requestConsentInfoUpdate(
      params,
      () async {
        try {
          await ConsentForm.loadAndShowConsentFormIfRequired((error) {
            // Form errors are non-fatal; continue with canRequestAds check.
          });
        } finally {
          if (!completer.isCompleted) completer.complete();
        }
      },
      (error) {
        if (!completer.isCompleted) completer.complete();
      },
    );

    await completer.future;
  }

  Future<bool> canRequestAds() => _consentInformation.canRequestAds();

  Future<void> showPrivacyOptionsForm() async {
    await ConsentForm.showPrivacyOptionsForm((error) {});
  }
}
