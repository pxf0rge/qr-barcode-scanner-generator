import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../domain/entities/app_failure.dart';

extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

String mapFailure(AppLocalizations l10n, AppFailure failure) {
  return switch (failure.code) {
    AppFailureCode.emptyInput => l10n.errorEmptyInput,
    AppFailureCode.invalidUrl => l10n.errorInvalidUrl,
    AppFailureCode.wifiSsidRequired => l10n.errorWifiSsidRequired,
    AppFailureCode.contactNameRequired => l10n.errorContactNameRequired,
    AppFailureCode.eanInvalidLength => l10n.errorEanInvalidLength,
    AppFailureCode.eanInvalidChecksum => l10n.errorEanInvalidChecksum,
    AppFailureCode.eanNonNumeric => l10n.errorEanNonNumeric,
    AppFailureCode.code128Empty => l10n.errorCode128Empty,
    AppFailureCode.code128IllegalChar => l10n.errorCode128IllegalChar,
    AppFailureCode.exportFailed => l10n.errorExportFailed,
    AppFailureCode.shareFailed => l10n.errorShareFailed,
    AppFailureCode.saveFailed => l10n.errorSaveFailed,
    AppFailureCode.adUnavailable => l10n.errorAdUnavailable,
    AppFailureCode.adNotEarned => l10n.errorAdNotEarned,
    AppFailureCode.offlineAds => l10n.errorOfflineAds,
    AppFailureCode.cameraDenied ||
    AppFailureCode.cameraPermanentlyDenied =>
      l10n.errorCameraDenied,
    AppFailureCode.contactsDenied ||
    AppFailureCode.contactsPermanentlyDenied =>
      l10n.errorContactsDenied,
    AppFailureCode.contactPickCancelled => l10n.errorContactPickCancelled,
    AppFailureCode.contactPickFailed => l10n.errorContactPickFailed,
    AppFailureCode.invalidSocialInput => l10n.errorInvalidSocialInput,
    AppFailureCode.unsupportedFormat => l10n.errorUnsupportedFormat,
    AppFailureCode.qrTooLarge => l10n.errorQrTooLarge,
    AppFailureCode.scannerFailed || AppFailureCode.generic => l10n.errorGeneric,
  };
}
