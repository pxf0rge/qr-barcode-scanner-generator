import '../entities/app_failure.dart';
import '../entities/qr_models.dart';
import '../validation/url_validator.dart';

/// Builds social-media QR payloads as plain https links (no APIs).
class SocialQrEncoder {
  const SocialQrEncoder({UrlValidator? urlValidator})
      : _urlValidator = urlValidator ?? const UrlValidator();

  final UrlValidator _urlValidator;

  Result<String> whatsapp({required String phone, String? message}) {
    final digits = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.length < 8) {
      return const Err(AppFailure(AppFailureCode.invalidSocialInput));
    }
    final uri = Uri(
      scheme: 'https',
      host: 'wa.me',
      path: '/$digits',
      queryParameters: (message != null && message.trim().isNotEmpty)
          ? {'text': message.trim()}
          : null,
    );
    return Ok(uri.toString());
  }

  Result<String> youtube(String input) =>
      _socialUrl(input, hosts: ['youtube.com', 'youtu.be'], fallbackHost: 'youtu.be');

  Result<String> facebook(String input) => _socialUrl(
        input,
        hosts: ['facebook.com', 'fb.com'],
        fallbackHost: 'www.facebook.com',
      );

  Result<String> instagram(String input) => _socialUrl(
        input,
        hosts: ['instagram.com'],
        fallbackHost: 'www.instagram.com',
        trailingSlash: true,
        stripAt: true,
      );

  Result<String> _socialUrl(
    String input, {
    required List<String> hosts,
    required String fallbackHost,
    String fallbackPathPrefix = '/',
    bool trailingSlash = false,
    bool stripAt = false,
  }) {
    var trimmed = input.trim();
    if (trimmed.isEmpty) {
      return const Err(AppFailure(AppFailureCode.emptyInput));
    }
    final asUrl = _urlValidator.validate(trimmed);
    if (asUrl.isOk) {
      final url = asUrl.valueOrNull!;
      final host = Uri.parse(url).host.toLowerCase();
      if (hosts.any(host.contains)) {
        return Ok(url);
      }
      return const Err(AppFailure(AppFailureCode.invalidSocialInput));
    }
    if (stripAt) {
      trimmed = trimmed.replaceFirst(RegExp(r'^@'), '');
    }
    if (!RegExp(r'^[\w.\-/@%]{2,}$').hasMatch(trimmed)) {
      return const Err(AppFailure(AppFailureCode.invalidSocialInput));
    }
    final path = fallbackPathPrefix.endsWith('/')
        ? '$fallbackPathPrefix$trimmed'
        : '$fallbackPathPrefix$trimmed';
    final uri = Uri.https(fallbackHost, trailingSlash ? '$path/' : path);
    return Ok(uri.toString());
  }

  QrContentType typeFor(SocialQrKind kind) => switch (kind) {
        SocialQrKind.whatsapp => QrContentType.whatsapp,
        SocialQrKind.youtube => QrContentType.youtube,
        SocialQrKind.facebook => QrContentType.facebook,
        SocialQrKind.instagram => QrContentType.instagram,
      };
}

enum SocialQrKind { whatsapp, youtube, facebook, instagram }
