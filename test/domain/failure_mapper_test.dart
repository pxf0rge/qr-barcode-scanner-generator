import 'package:flutter_test/flutter_test.dart';
import 'package:qr_barcode_app/core/errors/failure_mapper.dart';
import 'package:qr_barcode_app/domain/entities/app_failure.dart';
import 'package:qr_barcode_app/l10n/app_localizations_en.dart';

void main() {
  final l10n = AppLocalizationsEn();

  test('maps every AppFailureCode to a non-empty string', () {
    for (final code in AppFailureCode.values) {
      final message = mapFailure(l10n, AppFailure(code));
      expect(message, isNotEmpty, reason: '$code should map');
    }
  });

  test('offline ads has dedicated copy', () {
    expect(
      mapFailure(l10n, const AppFailure(AppFailureCode.offlineAds)),
      l10n.errorOfflineAds,
    );
  });
}
