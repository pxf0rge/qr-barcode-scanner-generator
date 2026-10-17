import '../entities/app_failure.dart';

class UrlValidator {
  const UrlValidator();

  Result<String> validate(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) {
      return const Err(AppFailure(AppFailureCode.emptyInput));
    }

    final uri = Uri.tryParse(trimmed);
    if (uri == null ||
        !(uri.isScheme('http') || uri.isScheme('https')) ||
        uri.host.isEmpty) {
      return const Err(AppFailure(AppFailureCode.invalidUrl));
    }

    // Preserve trimmed URL exactly (ends trimmed only).
    return Ok(trimmed);
  }
}
