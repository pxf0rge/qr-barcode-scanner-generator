import 'package:flutter_test/flutter_test.dart';
import 'package:qr_barcode_app/domain/entities/qr_models.dart';
import 'package:qr_barcode_app/domain/qr/wifi_qr_encoder.dart';

void main() {
  const encoder = WifiQrEncoder();

  test('encodes WPA with escaped specials', () {
    final raw = encoder.encode(
      const WifiNetworkConfig(
        ssid: r'My;Net\Work',
        security: WifiSecurity.wpa,
        password: r'p;a,s"s',
      ),
    );
    expect(raw, contains(r'S:My\;Net\\Work'));
    expect(raw, contains(r'P:p\;a\,s\"s'));
    expect(raw.startsWith('WIFI:T:WPA;'), isTrue);
    expect(raw.endsWith(';;'), isTrue);
  });

  test('encodes nopass without password field', () {
    final raw = encoder.encode(
      const WifiNetworkConfig(
        ssid: 'OpenNet',
        security: WifiSecurity.nopass,
      ),
    );
    expect(raw, 'WIFI:T:nopass;S:OpenNet;;');
    expect(raw.contains(';P:'), isFalse);
  });

  test('encodes hidden flag', () {
    final raw = encoder.encode(
      const WifiNetworkConfig(
        ssid: 'Hidden',
        security: WifiSecurity.wpa,
        password: 'secret',
        hidden: true,
      ),
    );
    expect(raw, contains(';H:true'));
  });
}
