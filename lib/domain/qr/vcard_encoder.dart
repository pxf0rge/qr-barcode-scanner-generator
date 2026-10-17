import '../entities/qr_models.dart';

class VCardEncoder {
  const VCardEncoder();

  String encode(ContactCard card) {
    final first = card.firstName.trim();
    final last = card.lastName.trim();
    final fn = [first, last].where((p) => p.isNotEmpty).join(' ');

    final lines = <String>[
      'BEGIN:VCARD',
      'VERSION:3.0',
      'N:${_escape(last)};${_escape(first)};;;',
      'FN:${_escape(fn)}',
    ];

    void add(String key, String value) {
      final v = value.trim();
      if (v.isNotEmpty) {
        lines.add('$key:${_escape(v)}');
      }
    }

    add('TEL', card.phone);
    add('EMAIL', card.email);
    add('ORG', card.organization);
    if (card.address.trim().isNotEmpty) {
      lines.add('ADR:;;${_escape(card.address.trim())};;;;');
    }
    add('URL', card.website);
    lines.add('END:VCARD');
    return lines.join('\n');
  }

  String _escape(String value) {
    return value
        .replaceAll(r'\', r'\\')
        .replaceAll(';', r'\;')
        .replaceAll(',', r'\,')
        .replaceAll('\n', r'\n');
  }
}
