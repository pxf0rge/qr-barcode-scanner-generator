import 'package:flutter_test/flutter_test.dart';
import 'package:qr_barcode_app/domain/entities/app_failure.dart';
import 'package:qr_barcode_app/domain/validation/url_validator.dart';

void main() {
  const validator = UrlValidator();

  test('accepts http and https URLs', () {
    expect(validator.validate('https://example.com').isOk, isTrue);
    expect(validator.validate('http://example.com/path').isOk, isTrue);
  });

  test('rejects empty', () {
    final result = validator.validate('  ');
    expect(result.isErr, isTrue);
    expect(result.failureOrNull?.code, AppFailureCode.emptyInput);
  });

  test('rejects ftp and hostless', () {
    expect(validator.validate('ftp://example.com').isErr, isTrue);
    expect(validator.validate('https://').isErr, isTrue);
    expect(validator.validate('not-a-url').isErr, isTrue);
  });

  test('preserves trimmed URL', () {
    final result = validator.validate('  https://example.com/a  ');
    expect(result.valueOrNull, 'https://example.com/a');
  });
}
