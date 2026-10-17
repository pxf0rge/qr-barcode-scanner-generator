import 'package:flutter_test/flutter_test.dart';
import 'package:qr_barcode_app/data/export/svg_export_service.dart';
import 'package:qr_barcode_app/domain/entities/barcode_models.dart';
import 'package:qr_barcode_app/domain/entities/generated_code.dart';
import 'package:qr_barcode_app/domain/entities/qr_models.dart';
import 'package:xml/xml.dart';

void main() {
  final service = SvgExportService();

  test('QR SVG is Illustrator-friendly vector with per-module rects', () {
    final svg = service.buildQrSvg('https://example.com/vectorqr');
    expect(svg.startsWith('<?xml'), isTrue);
    expect(svg.contains('xmlns="http://www.w3.org/2000/svg"'), isTrue);
    expect(svg.contains('viewBox="0 0 '), isTrue);
    expect(svg.contains('<rect'), isTrue);
    expect(svg.contains('fill="#000000"'), isTrue);
    expect(svg.contains('id="qr_modules"'), isTrue);
    expect(svg.toLowerCase().contains('data:image'), isFalse);
    expect(svg.toLowerCase().contains('<image'), isFalse);
    expect(svg.contains('PNG'), isFalse);
    final doc = XmlDocument.parse(svg);
    expect(doc.rootElement.name.local, 'svg');
    expect(doc.rootElement.getAttribute('xmlns'), 'http://www.w3.org/2000/svg');
    expect(doc.rootElement.getAttribute('viewBox'), isNotNull);
    expect(doc.rootElement.getAttribute('width'), isNotNull);
    expect(doc.rootElement.getAttribute('height'), isNotNull);
    expect(doc.findAllElements('rect').length, greaterThan(10));
  });

  test('barcode SVG uses editable rect bars for Code128', () {
    final svg = service.buildBarcodeSvg(
      GeneratedCode.barcode(
        symbology: BarcodeSymbology.code128,
        payload: 'ABC123',
        title: 'Code128',
      ),
    );
    expect(svg.startsWith('<?xml'), isTrue);
    expect(svg.contains('xmlns="http://www.w3.org/2000/svg"'), isTrue);
    expect(svg.contains('viewBox="0 0 '), isTrue);
    expect(svg.contains('<rect'), isTrue);
    expect(svg.contains('id="barcode_bars"'), isTrue);
    expect(svg.toLowerCase().contains('data:image'), isFalse);
    final doc = XmlDocument.parse(svg);
    expect(doc.rootElement.getAttribute('xmlns'), 'http://www.w3.org/2000/svg');
    expect(doc.rootElement.getAttribute('viewBox'), isNotNull);
  });

  test('EAN-13 SVG exports as vector', () {
    final svg = service.buildBarcodeSvg(
      GeneratedCode.barcode(
        symbology: BarcodeSymbology.ean13,
        payload: '5901234123457',
        title: 'EAN-13',
      ),
    );
    expect(svg.contains('<rect'), isTrue);
    expect(svg.toLowerCase().contains('<image'), isFalse);
    expect(() => XmlDocument.parse(svg), returnsNormally);
  });

  test('EAN-8 SVG exports as vector', () {
    final result = service.export(
      GeneratedCode.barcode(
        symbology: BarcodeSymbology.ean8,
        payload: '96385074',
        title: 'EAN-8',
      ),
    );
    expect(result.isOk, isTrue);
    final text = result.valueOrNull!.text!;
    expect(text.contains('<rect'), isTrue);
    expect(utf8Safe(text), isTrue);
  });

  test('export returns svg mime and .svg filename for QR', () {
    final result = service.export(
      GeneratedCode.qr(
        type: QrContentType.text,
        payload: 'test',
        title: 'Text',
      ),
    );
    expect(result.isOk, isTrue);
    expect(result.valueOrNull?.mimeType, 'image/svg+xml');
    expect(result.valueOrNull?.fileName.endsWith('.svg'), isTrue);
    expect(result.valueOrNull!.bytes.isNotEmpty, isTrue);
  });
}

bool utf8Safe(String svg) {
  try {
    XmlDocument.parse(svg);
    return true;
  } catch (_) {
    return false;
  }
}
