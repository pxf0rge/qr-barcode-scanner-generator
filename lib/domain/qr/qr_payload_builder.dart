import 'dart:convert';

import '../entities/app_failure.dart';
import '../entities/qr_models.dart';
import '../validation/url_validator.dart';
import 'social_qr_encoder.dart';
import 'vcard_encoder.dart';
import 'wifi_qr_encoder.dart';

class QrPayloadBuilder {
  QrPayloadBuilder({
    UrlValidator? urlValidator,
    WifiQrEncoder? wifiEncoder,
    VCardEncoder? vCardEncoder,
    SocialQrEncoder? socialEncoder,
  })  : _urlValidator = urlValidator ?? const UrlValidator(),
        _wifiEncoder = wifiEncoder ?? const WifiQrEncoder(),
        _vCardEncoder = vCardEncoder ?? const VCardEncoder(),
        _socialEncoder = socialEncoder ?? const SocialQrEncoder();

  final UrlValidator _urlValidator;
  final WifiQrEncoder _wifiEncoder;
  final VCardEncoder _vCardEncoder;
  final SocialQrEncoder _socialEncoder;

  /// Approximate QR binary capacity for version 40-L; keep a safer MVP limit.
  static const int maxUtf8Bytes = 2953;

  Result<QrPayload> fromText(String input) {
    if (input.trim().isEmpty) {
      return const Err(AppFailure(AppFailureCode.emptyInput));
    }
    return _wrap(QrContentType.text, input);
  }

  Result<QrPayload> fromUrl(String input) {
    final validated = _urlValidator.validate(input);
    return validated.when(
      ok: (url) => _wrap(QrContentType.url, url),
      err: Err.new,
    );
  }

  Result<QrPayload> fromWifi(WifiNetworkConfig config) {
    if (config.ssid.trim().isEmpty) {
      return const Err(AppFailure(AppFailureCode.wifiSsidRequired));
    }
    final normalized = WifiNetworkConfig(
      ssid: config.ssid.trim(),
      security: config.security,
      password:
          config.security == WifiSecurity.nopass ? null : config.password,
      hidden: config.hidden,
    );
    return _wrap(QrContentType.wifi, _wifiEncoder.encode(normalized));
  }

  Result<QrPayload> fromContact(ContactCard card) {
    if (card.firstName.trim().isEmpty && card.lastName.trim().isEmpty) {
      return const Err(AppFailure(AppFailureCode.contactNameRequired));
    }
    return _wrap(QrContentType.vCard, _vCardEncoder.encode(card));
  }

  Result<QrPayload> fromPhone(String input) {
    final digits = input.replaceAll(RegExp(r'[^\d+]'), '');
    if (digits.replaceAll('+', '').length < 5) {
      return const Err(AppFailure(AppFailureCode.emptyInput));
    }
    return _wrap(QrContentType.phone, 'tel:$digits');
  }

  Result<QrPayload> fromEmail({
    required String email,
    String? subject,
    String? body,
  }) {
    final trimmed = email.trim();
    if (trimmed.isEmpty || !trimmed.contains('@')) {
      return const Err(AppFailure(AppFailureCode.emptyInput));
    }
    final params = <String, String>{};
    if (subject != null && subject.trim().isNotEmpty) {
      params['subject'] = subject.trim();
    }
    if (body != null && body.trim().isNotEmpty) {
      params['body'] = body.trim();
    }
    final uri = Uri(
      scheme: 'mailto',
      path: trimmed,
      queryParameters: params.isEmpty ? null : params,
    );
    return _wrap(QrContentType.email, uri.toString());
  }

  Result<QrPayload> fromCalendar({
    required String title,
    String? location,
    String? description,
    DateTime? start,
    DateTime? end,
  }) {
    final t = title.trim();
    if (t.isEmpty) {
      return const Err(AppFailure(AppFailureCode.emptyInput));
    }
    final buffer = StringBuffer()
      ..writeln('BEGIN:VCALENDAR')
      ..writeln('VERSION:2.0')
      ..writeln('BEGIN:VEVENT')
      ..writeln('SUMMARY:$t');
    if (location != null && location.trim().isNotEmpty) {
      buffer.writeln('LOCATION:${location.trim()}');
    }
    if (description != null && description.trim().isNotEmpty) {
      buffer.writeln('DESCRIPTION:${description.trim()}');
    }
    String fmt(DateTime d) =>
        '${d.toUtc().toIso8601String().replaceAll(RegExp(r'[-:]'), '').split('.').first}Z';
    if (start != null) buffer.writeln('DTSTART:${fmt(start)}');
    if (end != null) buffer.writeln('DTEND:${fmt(end)}');
    buffer
      ..writeln('END:VEVENT')
      ..writeln('END:VCALENDAR');
    return _wrap(QrContentType.calendar, buffer.toString());
  }

  Result<QrPayload> fromWhatsapp({required String phone, String? message}) {
    return _socialEncoder.whatsapp(phone: phone, message: message).when(
          ok: (raw) => _wrap(QrContentType.whatsapp, raw),
          err: Err.new,
        );
  }

  Result<QrPayload> fromYoutube(String input) {
    return _socialEncoder.youtube(input).when(
          ok: (raw) => _wrap(QrContentType.youtube, raw),
          err: Err.new,
        );
  }

  Result<QrPayload> fromFacebook(String input) {
    return _socialEncoder.facebook(input).when(
          ok: (raw) => _wrap(QrContentType.facebook, raw),
          err: Err.new,
        );
  }

  Result<QrPayload> fromInstagram(String input) {
    return _socialEncoder.instagram(input).when(
          ok: (raw) => _wrap(QrContentType.instagram, raw),
          err: Err.new,
        );
  }

  Result<QrPayload> _wrap(QrContentType type, String raw) {
    if (utf8.encode(raw).length > maxUtf8Bytes) {
      return const Err(AppFailure(AppFailureCode.qrTooLarge));
    }
    return Ok(QrPayload(type: type, rawValue: raw));
  }
}
