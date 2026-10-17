import '../entities/qr_models.dart';

class WifiQrEncoder {
  const WifiQrEncoder();

  String encode(WifiNetworkConfig config) {
    final ssid = _escape(config.ssid);
    final buffer = StringBuffer('WIFI:T:');
    buffer.write(switch (config.security) {
      WifiSecurity.wpa => 'WPA',
      WifiSecurity.wep => 'WEP',
      WifiSecurity.nopass => 'nopass',
    });
    buffer.write(';S:');
    buffer.write(ssid);
    if (config.security != WifiSecurity.nopass) {
      buffer.write(';P:');
      buffer.write(_escape(config.password ?? ''));
    }
    if (config.hidden) {
      buffer.write(';H:true');
    }
    buffer.write(';;');
    return buffer.toString();
  }

  String _escape(String value) {
    return value
        .replaceAll(r'\', r'\\')
        .replaceAll(';', r'\;')
        .replaceAll(',', r'\,')
        .replaceAll('"', r'\"');
  }
}
