class EanChecksum {
  const EanChecksum();

  /// Returns true if [digits] (including check digit) is valid.
  bool isValid(String digits) {
    if (!RegExp(r'^\d+$').hasMatch(digits)) return false;
    if (digits.length != 8 && digits.length != 13) return false;
    final body = digits.substring(0, digits.length - 1);
    final expected = computeCheckDigit(body);
    return expected == digits[digits.length - 1];
  }

  /// [body] is 7 digits (EAN-8) or 12 digits (EAN-13).
  String computeCheckDigit(String body) {
    if (!RegExp(r'^\d+$').hasMatch(body)) {
      throw ArgumentError('body must be numeric');
    }
    if (body.length != 7 && body.length != 12) {
      throw ArgumentError('body length must be 7 or 12');
    }

    var sum = 0;
    for (var i = 0; i < body.length; i++) {
      final digit = int.parse(body[body.length - 1 - i]);
      final weight = i.isEven ? 3 : 1;
      sum += digit * weight;
    }
    final check = (10 - (sum % 10)) % 10;
    return '$check';
  }

  /// Accepts 7/8 for EAN-8 or 12/13 for EAN-13. Returns full code with check.
  String? normalize({required String input, required int targetLength}) {
    final digits = input.trim();
    if (!RegExp(r'^\d+$').hasMatch(digits)) return null;

    final bodyLength = targetLength - 1;
    if (digits.length == bodyLength) {
      return digits + computeCheckDigit(digits);
    }
    if (digits.length == targetLength && isValid(digits)) {
      return digits;
    }
    return null;
  }
}
