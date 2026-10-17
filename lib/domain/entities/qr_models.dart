import 'package:equatable/equatable.dart';

enum QrContentType {
  text,
  url,
  wifi,
  vCard,
  phone,
  email,
  calendar,
  whatsapp,
  youtube,
  facebook,
  instagram,
  x,
  spotify,
  tiktok,
  linkedin,
}

class QrPayload extends Equatable {
  const QrPayload({
    required this.type,
    required this.rawValue,
  });

  final QrContentType type;
  final String rawValue;

  @override
  List<Object?> get props => [type, rawValue];
}

enum WifiSecurity { wpa, wep, nopass }

class WifiNetworkConfig extends Equatable {
  const WifiNetworkConfig({
    required this.ssid,
    required this.security,
    this.password,
    this.hidden = false,
  });

  final String ssid;
  final String? password;
  final WifiSecurity security;
  final bool hidden;

  @override
  List<Object?> get props => [ssid, password, security, hidden];
}

class ContactCard extends Equatable {
  const ContactCard({
    this.firstName = '',
    this.lastName = '',
    this.phone = '',
    this.email = '',
    this.organization = '',
    this.address = '',
    this.website = '',
  });

  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String organization;
  final String address;
  final String website;

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        phone,
        email,
        organization,
        address,
        website,
      ];
}
