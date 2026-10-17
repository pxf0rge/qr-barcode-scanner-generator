import 'package:equatable/equatable.dart';

enum BarcodeSymbology { code128, ean8, ean13 }

class BarcodePayload extends Equatable {
  const BarcodePayload({
    required this.symbology,
    required this.rawValue,
  });

  final BarcodeSymbology symbology;
  final String rawValue;

  @override
  List<Object?> get props => [symbology, rawValue];
}
