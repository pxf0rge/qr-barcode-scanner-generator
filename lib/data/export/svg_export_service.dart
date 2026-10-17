import 'dart:convert';
import 'dart:typed_data';

import 'package:barcode/barcode.dart';
import 'package:qr/qr.dart';
import 'package:xml/xml.dart';

import '../../domain/entities/app_failure.dart';
import '../../domain/entities/barcode_models.dart';
import '../../domain/entities/generated_code.dart';
import '../../domain/export/export_format.dart';

/// Builds Illustrator / CorelDRAW / Inkscape-friendly editable vector SVG.
/// Never embeds raster images — only `<rect>` / `<text>` vector primitives.
class SvgExportService {
  /// Module size in user units so coordinates are large enough for design apps.
  static const double moduleSize = 10;

  Result<ExportBytesLike> export(GeneratedCode code) {
    try {
      final svg = code.kind == GeneratedKind.qr
          ? buildQrSvg(code.payloadString)
          : buildBarcodeSvg(code);
      XmlDocument.parse(svg);
      if (!_isValidVectorSvg(svg)) {
        return const Err(AppFailure(AppFailureCode.exportFailed));
      }
      final stamp = DateTime.now().millisecondsSinceEpoch;
      final prefix = code.kind == GeneratedKind.qr ? 'qr' : 'barcode';
      // UTF-8 without BOM — standard for SVG opened in Adobe / Corel.
      final bytes = Uint8List.fromList(utf8.encode(svg));
      return Ok(
        ExportBytesLike(
          bytes: bytes,
          fileName: '${prefix}_$stamp.svg',
          mimeType: ExportFormat.svg.mimeType,
          text: svg,
        ),
      );
    } catch (_) {
      return const Err(AppFailure(AppFailureCode.exportFailed));
    }
  }

  bool _isValidVectorSvg(String svg) {
    final lower = svg.toLowerCase();
    if (!lower.contains('<svg')) return false;
    // Required for standard viewers / editors to treat the file as SVG.
    if (!lower.contains('xmlns="http://www.w3.org/2000/svg"')) return false;
    if (!RegExp(r'viewbox\s*=\s*"0\s+0\s+[0-9.]+(?:e[+-]?\d+)?\s+[0-9.]+(?:e[+-]?\d+)?"')
        .hasMatch(lower)) {
      return false;
    }
    if (lower.contains('data:image')) return false;
    if (lower.contains('xlink:href') && lower.contains('base64')) return false;
    if (lower.contains('ihdr') || lower.contains('<image')) return false;
    if (!lower.contains('<rect')) return false;
    return true;
  }

  /// Root `<svg>` with XML prolog, xmlns, viewBox, and explicit size.
  static String _svgOpenTag({required double width, required double height}) {
    final w = _fmt(width);
    final h = _fmt(height);
    return '<svg xmlns="http://www.w3.org/2000/svg" '
        'xmlns:xlink="http://www.w3.org/1999/xlink" '
        'version="1.1" '
        'viewBox="0 0 $w $h" '
        'width="$w" height="$h" '
        'preserveAspectRatio="xMidYMid meet">';
  }

  /// One editable `<rect>` per dark QR module (fully selectable in Illustrator).
  String buildQrSvg(String data, {int quietZone = 4}) {
    final qrCode = QrCode.fromData(
      data: data,
      errorCorrectLevel: QrErrorCorrectLevel.M,
    );
    final qrImage = QrImage(qrCode);
    final n = qrImage.moduleCount;
    final modules = n + quietZone * 2;
    final size = modules * moduleSize;

    final buffer = StringBuffer();
    buffer.writeln('<?xml version="1.0" encoding="UTF-8" standalone="no"?>');
    buffer.writeln(_svgOpenTag(width: size, height: size));
    buffer.writeln('<title>VectorQR editable QR</title>');
    buffer.writeln('<g id="qr_modules">');

    for (var y = 0; y < n; y++) {
      for (var x = 0; x < n; x++) {
        if (!qrImage.isDark(y, x)) continue;
        final px = (x + quietZone) * moduleSize;
        final py = (y + quietZone) * moduleSize;
        buffer.writeln(
          '<rect x="${_fmt(px)}" y="${_fmt(py)}" '
          'width="${_fmt(moduleSize)}" height="${_fmt(moduleSize)}" '
          'fill="#000000"/>',
        );
      }
    }

    buffer.writeln('</g>');
    buffer.writeln('</svg>');
    return buffer.toString();
  }

  /// Each barcode bar is a separate editable `<rect>` vector shape.
  String buildBarcodeSvg(GeneratedCode code) {
    final barcode = switch (code.barcodeSymbology) {
      BarcodeSymbology.ean8 => Barcode.ean8(),
      BarcodeSymbology.ean13 => Barcode.ean13(),
      _ => Barcode.code128(),
    };

    const width = 400.0;
    const height = 160.0;
    final elements = barcode.make(
      code.payloadString,
      width: width,
      height: height,
      drawText: true,
      fontHeight: 16,
    );

    final buffer = StringBuffer();
    buffer.writeln('<?xml version="1.0" encoding="UTF-8" standalone="no"?>');
    buffer.writeln(_svgOpenTag(width: width, height: height));
    buffer.writeln('<title>VectorQR editable barcode</title>');
    buffer.writeln('<g id="barcode_bars">');

    final labels = <BarcodeText>[];
    var barIndex = 0;
    for (final elem in elements) {
      if (elem is BarcodeBar && elem.black) {
        buffer.writeln(
          '<rect id="bar_$barIndex" '
          'x="${_fmt(elem.left)}" y="${_fmt(elem.top)}" '
          'width="${_fmt(elem.width)}" height="${_fmt(elem.height)}" '
          'fill="#000000"/>',
        );
        barIndex++;
      } else if (elem is BarcodeText) {
        labels.add(elem);
      }
    }
    buffer.writeln('</g>');

    if (labels.isNotEmpty) {
      buffer.writeln('<g id="barcode_text" fill="#000000">');
      for (var i = 0; i < labels.length; i++) {
        final label = labels[i];
        final anchor = switch (label.align) {
          BarcodeTextAlign.left => 'start',
          BarcodeTextAlign.center => 'middle',
          BarcodeTextAlign.right => 'end',
        };
        final lx = switch (label.align) {
          BarcodeTextAlign.left => label.left,
          BarcodeTextAlign.center => label.left + label.width / 2,
          BarcodeTextAlign.right => label.left + label.width,
        };
        final ly = label.top + label.height * 0.8;
        buffer.writeln(
          '<text id="label_$i" x="${_fmt(lx)}" y="${_fmt(ly)}" '
          'text-anchor="$anchor" font-family="Arial" font-size="16">'
          '${_escapeXml(label.text)}</text>',
        );
      }
      buffer.writeln('</g>');
    }

    buffer.writeln('</svg>');
    return buffer.toString();
  }

  static String _fmt(double v) {
    if (v == v.roundToDouble()) return v.toInt().toString();
    return v.toStringAsFixed(3);
  }

  static String _escapeXml(String value) {
    return value
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&apos;');
  }
}

class ExportBytesLike {
  const ExportBytesLike({
    required this.bytes,
    required this.fileName,
    required this.mimeType,
    this.text,
  });

  final Uint8List bytes;
  final String fileName;
  final String mimeType;
  final String? text;
}
