import '../entities/app_failure.dart';
import '../entities/barcode_models.dart';
import 'ean_checksum.dart';

class BarcodeValidator {
  BarcodeValidator({EanChecksum? checksum})
      : _checksum = checksum ?? const EanChecksum();

  final EanChecksum _checksum;

  static final _illegalCode128 = RegExp(r'[^\x20-\x7E]');

  Result<BarcodePayload> validateCode128(String input) {
    if (input.isEmpty) {
      return const Err(AppFailure(AppFailureCode.code128Empty));
    }
    if (_illegalCode128.hasMatch(input)) {
      return const Err(AppFailure(AppFailureCode.code128IllegalChar));
    }
    return Ok(
      BarcodePayload(symbology: BarcodeSymbology.code128, rawValue: input),
    );
  }

  Result<BarcodePayload> validateEan8(String input) {
    return _validateEan(input, targetLength: 8, symbology: BarcodeSymbology.ean8);
  }

  Result<BarcodePayload> validateEan13(String input) {
    return _validateEan(
      input,
      targetLength: 13,
      symbology: BarcodeSymbology.ean13,
    );
  }

  Result<BarcodePayload> _validateEan(
    String input, {
    required int targetLength,
    required BarcodeSymbology symbology,
  }) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) {
      return const Err(AppFailure(AppFailureCode.emptyInput));
    }
    if (!RegExp(r'^\d+$').hasMatch(trimmed)) {
      return const Err(AppFailure(AppFailureCode.eanNonNumeric));
    }

    final bodyLength = targetLength - 1;
    if (trimmed.length != bodyLength && trimmed.length != targetLength) {
      return const Err(AppFailure(AppFailureCode.eanInvalidLength));
    }

    if (trimmed.length == targetLength && !_checksum.isValid(trimmed)) {
      return const Err(AppFailure(AppFailureCode.eanInvalidChecksum));
    }

    final normalized = _checksum.normalize(
      input: trimmed,
      targetLength: targetLength,
    );
    if (normalized == null) {
      return const Err(AppFailure(AppFailureCode.eanInvalidChecksum));
    }

    return Ok(BarcodePayload(symbology: symbology, rawValue: normalized));
  }
}
