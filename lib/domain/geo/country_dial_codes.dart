/// Dial codes for WhatsApp phone entry (flag via ISO region emoji).
class CountryDialCode {
  const CountryDialCode({
    required this.name,
    required this.iso2,
    required this.dialCode,
  });

  final String name;
  final String iso2;
  final String dialCode;

  /// Regional-indicator flag emoji (e.g. US → 🇺🇸).
  String get flagEmoji {
    final upper = iso2.toUpperCase();
    if (upper.length != 2) return '🏳️';
    final first = upper.codeUnitAt(0) - 0x41 + 0x1F1E6;
    final second = upper.codeUnitAt(1) - 0x41 + 0x1F1E6;
    return String.fromCharCodes([first, second]);
  }

  String get label => '$flagEmoji  $name (+$dialCode)';
}

/// Common countries for WhatsApp QR (sorted by name).
const kCountryDialCodes = <CountryDialCode>[
  CountryDialCode(name: 'Afghanistan', iso2: 'AF', dialCode: '93'),
  CountryDialCode(name: 'Australia', iso2: 'AU', dialCode: '61'),
  CountryDialCode(name: 'Bangladesh', iso2: 'BD', dialCode: '880'),
  CountryDialCode(name: 'Brazil', iso2: 'BR', dialCode: '55'),
  CountryDialCode(name: 'Canada', iso2: 'CA', dialCode: '1'),
  CountryDialCode(name: 'China', iso2: 'CN', dialCode: '86'),
  CountryDialCode(name: 'Egypt', iso2: 'EG', dialCode: '20'),
  CountryDialCode(name: 'France', iso2: 'FR', dialCode: '33'),
  CountryDialCode(name: 'Germany', iso2: 'DE', dialCode: '49'),
  CountryDialCode(name: 'India', iso2: 'IN', dialCode: '91'),
  CountryDialCode(name: 'Indonesia', iso2: 'ID', dialCode: '62'),
  CountryDialCode(name: 'Iran', iso2: 'IR', dialCode: '98'),
  CountryDialCode(name: 'Iraq', iso2: 'IQ', dialCode: '964'),
  CountryDialCode(name: 'Italy', iso2: 'IT', dialCode: '39'),
  CountryDialCode(name: 'Japan', iso2: 'JP', dialCode: '81'),
  CountryDialCode(name: 'Malaysia', iso2: 'MY', dialCode: '60'),
  CountryDialCode(name: 'Mexico', iso2: 'MX', dialCode: '52'),
  CountryDialCode(name: 'Netherlands', iso2: 'NL', dialCode: '31'),
  CountryDialCode(name: 'Nigeria', iso2: 'NG', dialCode: '234'),
  CountryDialCode(name: 'Pakistan', iso2: 'PK', dialCode: '92'),
  CountryDialCode(name: 'Philippines', iso2: 'PH', dialCode: '63'),
  CountryDialCode(name: 'Russia', iso2: 'RU', dialCode: '7'),
  CountryDialCode(name: 'Saudi Arabia', iso2: 'SA', dialCode: '966'),
  CountryDialCode(name: 'South Africa', iso2: 'ZA', dialCode: '27'),
  CountryDialCode(name: 'South Korea', iso2: 'KR', dialCode: '82'),
  CountryDialCode(name: 'Spain', iso2: 'ES', dialCode: '34'),
  CountryDialCode(name: 'Turkey', iso2: 'TR', dialCode: '90'),
  CountryDialCode(name: 'Ukraine', iso2: 'UA', dialCode: '380'),
  CountryDialCode(name: 'United Arab Emirates', iso2: 'AE', dialCode: '971'),
  CountryDialCode(name: 'United Kingdom', iso2: 'GB', dialCode: '44'),
  CountryDialCode(name: 'United States', iso2: 'US', dialCode: '1'),
];

CountryDialCode countryDialByIso(String iso2) {
  return kCountryDialCodes.firstWhere(
    (c) => c.iso2 == iso2,
    orElse: () => kCountryDialCodes.firstWhere((c) => c.iso2 == 'US'),
  );
}
