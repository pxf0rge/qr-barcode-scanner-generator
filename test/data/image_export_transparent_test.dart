import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:qr_barcode_app/core/config/app_config.dart';
import 'package:qr_barcode_app/data/export/image_export_service.dart';
import 'package:qr_barcode_app/domain/entities/barcode_models.dart';
import 'package:qr_barcode_app/domain/entities/generated_code.dart';
import 'package:qr_barcode_app/domain/entities/qr_models.dart';

void main() {
  final service = ImageExportService();

  test('transparent QR PNG is exactly 1000×1000 with alpha', () async {
    final result = await service.exportTransparentPng(
      GeneratedCode.qr(
        type: QrContentType.text,
        payload: 'HELLO-VECTORQR-1000',
        title: 'Text',
      ),
    );
    expect(result.isOk, isTrue);
    final bytes = result.valueOrNull!.bytes;
    final decoded = img.decodePng(bytes)!;
    expect(decoded.width, AdPolicy.defaultExportSize);
    expect(decoded.height, AdPolicy.defaultExportSize);
    expect(result.valueOrNull!.fileName.contains('1000'), isTrue);

    // Corner of quiet zone must be fully transparent.
    final corner = decoded.getPixel(0, 0);
    expect(corner.a.toInt(), 0);

    // Some dark module must be opaque.
    var foundInk = false;
    for (var y = 0; y < decoded.height && !foundInk; y++) {
      for (var x = 0; x < decoded.width; x++) {
        if (decoded.getPixel(x, y).a.toInt() > 200) {
          foundInk = true;
          break;
        }
      }
    }
    expect(foundInk, isTrue);
  });

  test('transparent barcode PNG is also 1000×1000 canvas', () async {
    final result = await service.exportTransparentPng(
      GeneratedCode.barcode(
        symbology: BarcodeSymbology.code128,
        payload: 'ABC123',
        title: 'Code128',
      ),
    );
    expect(result.isOk, isTrue);
    final decoded = img.decodePng(result.valueOrNull!.bytes)!;
    expect(decoded.width, 1000);
    expect(decoded.height, 1000);
    expect(decoded.getPixel(0, 0).a.toInt(), 0);
  });
}
