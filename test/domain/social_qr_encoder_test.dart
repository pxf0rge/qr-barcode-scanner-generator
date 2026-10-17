import 'package:flutter_test/flutter_test.dart';
import 'package:qr_barcode_app/domain/entities/app_failure.dart';
import 'package:qr_barcode_app/domain/qr/social_qr_encoder.dart';

void main() {
  const encoder = SocialQrEncoder();

  test('whatsapp builds wa.me link', () {
    final r = encoder.whatsapp(phone: '+1 (555) 123-4567', message: 'Hi');
    expect(r.isOk, isTrue);
    expect(r.valueOrNull, contains('wa.me/15551234567'));
    expect(r.valueOrNull, contains('text=Hi'));
  });

  test('youtube accepts video id', () {
    final r = encoder.youtube('dQw4w9WgXcQ');
    expect(r.isOk, isTrue);
    expect(r.valueOrNull, 'https://youtu.be/dQw4w9WgXcQ');
  });

  test('instagram username', () {
    final r = encoder.instagram('@vectorqr');
    expect(r.isOk, isTrue);
    expect(r.valueOrNull, 'https://www.instagram.com/vectorqr/');
  });

  test('facebook rejects empty', () {
    final r = encoder.facebook(' ');
    expect(r.isErr, isTrue);
    expect(r.failureOrNull?.code, AppFailureCode.emptyInput);
  });
}
