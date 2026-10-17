import 'package:equatable/equatable.dart';

import 'barcode_models.dart';
import 'qr_models.dart';

enum GeneratedKind { qr, barcode }

class GeneratedCode extends Equatable {
  GeneratedCode({
    required this.kind,
    required this.displayTitle,
    required this.payloadString,
    this.qrType,
    this.barcodeSymbology,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);

  final GeneratedKind kind;
  final String displayTitle;
  final String payloadString;
  final QrContentType? qrType;
  final BarcodeSymbology? barcodeSymbology;
  final DateTime createdAt;

  factory GeneratedCode.qr({
    required QrContentType type,
    required String payload,
    required String title,
  }) {
    return GeneratedCode(
      kind: GeneratedKind.qr,
      displayTitle: title,
      payloadString: payload,
      qrType: type,
      createdAt: DateTime.now(),
    );
  }

  factory GeneratedCode.barcode({
    required BarcodeSymbology symbology,
    required String payload,
    required String title,
  }) {
    return GeneratedCode(
      kind: GeneratedKind.barcode,
      displayTitle: title,
      payloadString: payload,
      barcodeSymbology: symbology,
      createdAt: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        kind,
        displayTitle,
        payloadString,
        qrType,
        barcodeSymbology,
      ];
}

class ScanResultData extends Equatable {
  const ScanResultData({
    required this.rawValue,
    required this.formatName,
    required this.timestamp,
  });

  final String rawValue;
  final String formatName;
  final DateTime timestamp;

  @override
  List<Object?> get props => [rawValue, formatName, timestamp];
}
