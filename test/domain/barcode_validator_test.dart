import 'package:flutter_test/flutter_test.dart';
import 'package:qr_barcode_app/domain/entities/app_failure.dart';
import 'package:qr_barcode_app/domain/entities/barcode_models.dart';
import 'package:qr_barcode_app/domain/validation/barcode_validator.dart';

void main() {
  final validator = BarcodeValidator();

  group('Code128', () {
    test('rejects empty', () {
      final result = validator.validateCode128('');
      expect(result.failureOrNull?.code, AppFailureCode.code128Empty);
    });

    test('accepts basic ascii', () {
      final result = validator.validateCode128('Hello-123');
      expect(result.isOk, isTrue);
      expect(result.valueOrNull?.symbology, BarcodeSymbology.code128);
    });

    test('rejects illegal char', () {
      final result = validator.validateCode128('bad\nline');
      expect(result.failureOrNull?.code, AppFailureCode.code128IllegalChar);
    });
  });

  group('EAN', () {
    test('accepts 7 digits and normalizes EAN-8', () {
      final result = validator.validateEan8('9638507');
      expect(result.valueOrNull?.rawValue, '96385074');
    });

    test('rejects non-numeric', () {
      final result = validator.validateEan13('12A456789012');
      expect(result.failureOrNull?.code, AppFailureCode.eanNonNumeric);
    });

    test('rejects bad checksum', () {
      final result = validator.validateEan8('96385075');
      expect(result.failureOrNull?.code, AppFailureCode.eanInvalidChecksum);
    });

    test('rejects wrong length', () {
      final result = validator.validateEan13('12345');
      expect(result.failureOrNull?.code, AppFailureCode.eanInvalidLength);
    });
  });
}
