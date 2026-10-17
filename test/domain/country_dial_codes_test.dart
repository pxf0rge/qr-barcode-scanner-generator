import 'package:flutter_test/flutter_test.dart';
import 'package:qr_barcode_app/domain/geo/country_dial_codes.dart';

void main() {
  test('country list has dial codes and flag emoji', () {
    expect(kCountryDialCodes, isNotEmpty);
    final us = countryDialByIso('US');
    expect(us.dialCode, '1');
    expect(us.flagEmoji, isNotEmpty);
    expect(us.label.contains('+1'), isTrue);
  });

  test('Iran dial code is 98', () {
    final ir = countryDialByIso('IR');
    expect(ir.dialCode, '98');
    expect(ir.iso2, 'IR');
  });
}
