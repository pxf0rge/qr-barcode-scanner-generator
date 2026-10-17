import 'package:equatable/equatable.dart';

enum ClassifiedKind { text, url, phone, email, wifi, vcard }

class ClassifiedContent extends Equatable {
  const ClassifiedContent({
    required this.kind,
    required this.rawValue,
    this.wifiSsid,
    this.wifiPassword,
    this.wifiSecurity,
    this.wifiHidden,
    this.contactFields = const {},
  });

  final ClassifiedKind kind;
  final String rawValue;
  final String? wifiSsid;
  final String? wifiPassword;
  final String? wifiSecurity;
  final bool? wifiHidden;
  final Map<String, String> contactFields;

  @override
  List<Object?> get props => [
        kind,
        rawValue,
        wifiSsid,
        wifiPassword,
        wifiSecurity,
        wifiHidden,
        contactFields,
      ];
}

class ContentClassifier {
  const ContentClassifier();

  ClassifiedContent classify(String raw) {
    final value = raw.trim();
    if (value.toUpperCase().startsWith('WIFI:')) {
      return _parseWifi(value);
    }
    if (value.toUpperCase().contains('BEGIN:VCARD')) {
      return _parseVcard(value);
    }
    if (value.toLowerCase().startsWith('mailto:')) {
      return ClassifiedContent(kind: ClassifiedKind.email, rawValue: value);
    }
    if (value.toLowerCase().startsWith('tel:')) {
      return ClassifiedContent(kind: ClassifiedKind.phone, rawValue: value);
    }
    final email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (email.hasMatch(value)) {
      return ClassifiedContent(kind: ClassifiedKind.email, rawValue: value);
    }
    final phone = RegExp(r'^\+?[\d\s\-().]{7,}$');
    if (phone.hasMatch(value) && RegExp(r'\d').allMatches(value).length >= 7) {
      return ClassifiedContent(kind: ClassifiedKind.phone, rawValue: value);
    }
    final uri = Uri.tryParse(value);
    if (uri != null &&
        (uri.isScheme('http') || uri.isScheme('https')) &&
        uri.host.isNotEmpty) {
      return ClassifiedContent(kind: ClassifiedKind.url, rawValue: value);
    }
    return ClassifiedContent(kind: ClassifiedKind.text, rawValue: value);
  }

  ClassifiedContent _parseWifi(String value) {
    String? field(String key) {
      final match = RegExp('$key:((?:\\\\.|[^;])*)', caseSensitive: false)
          .firstMatch(value);
      if (match == null) return null;
      return match.group(1)
          ?.replaceAll(r'\;', ';')
          .replaceAll(r'\,', ',')
          .replaceAll(r'\"', '"')
          .replaceAll(r'\\', r'\');
    }

    final hiddenRaw = field('H');
    return ClassifiedContent(
      kind: ClassifiedKind.wifi,
      rawValue: value,
      wifiSsid: field('S'),
      wifiPassword: field('P'),
      wifiSecurity: field('T'),
      wifiHidden: hiddenRaw?.toLowerCase() == 'true',
    );
  }

  ClassifiedContent _parseVcard(String value) {
    final fields = <String, String>{};
    for (final line in value.split(RegExp(r'\r?\n'))) {
      final idx = line.indexOf(':');
      if (idx <= 0) continue;
      final key = line.substring(0, idx).split(';').first.toUpperCase();
      final v = line.substring(idx + 1).trim();
      if (v.isNotEmpty) fields[key] = v;
    }
    return ClassifiedContent(
      kind: ClassifiedKind.vcard,
      rawValue: value,
      contactFields: fields,
    );
  }
}
