import 'package:flutter_test/flutter_test.dart';
import 'package:qr_barcode_app/domain/validation/ean_checksum.dart';

void main() {
  const checksum = EanChecksum();

  test('valid EAN-8 and EAN-13', () {
    expect(checksum.isValid('96385074'), isTrue); // classic sample
    expect(checksum.isValid('4006381333931'), isTrue);
  });

  test('invalid checksum rejected', () {
    expect(checksum.isValid('96385075'), isFalse);
    expect(checksum.isValid('4006381333932'), isFalse);
  });

  test('computeCheckDigit for 7 and 12 bodies', () {
    expect(checksum.computeCheckDigit('9638507'), '4');
    expect(checksum.computeCheckDigit('400638133393'), '1');
  });

  test('normalize appends check digit', () {
    expect(checksum.normalize(input: '9638507', targetLength: 8), '96385074');
    expect(
      checksum.normalize(input: '400638133393', targetLength: 13),
      '4006381333931',
    );
  });

  test('normalize returns null for bad length', () {
    expect(checksum.normalize(input: '123', targetLength: 8), isNull);
  });
}
