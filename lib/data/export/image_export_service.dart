import 'dart:ui' as ui;

import 'package:barcode/barcode.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;
import 'package:qr/qr.dart';

import '../../domain/entities/app_failure.dart';
import '../../domain/entities/generated_code.dart';
import '../../domain/export/export_format.dart';
import '../../core/config/app_config.dart';

class ExportBytes {
  const ExportBytes({
    required this.bytes,
    required this.fileName,
    required this.mimeType,
  });

  final Uint8List bytes;
  final String fileName;
  final String mimeType;
}

/// Isolate-safe map keys for high-res transparent PNG.
class TransparentPngArgs {
  const TransparentPngArgs({
    required this.payload,
    required this.isQr,
    required this.foregroundArgb,
    this.symbologyName,
    this.size = AdPolicy.defaultExportSize,
  });

  final String payload;
  final bool isQr;
  final int foregroundArgb;
  final String? symbologyName;
  final int size;

  Map<String, Object?> toMap() => {
        'payload': payload,
        'isQr': isQr,
        'foregroundArgb': foregroundArgb,
        'symbologyName': symbologyName,
        'size': size,
      };

  static TransparentPngArgs fromMap(Map<String, Object?> map) {
    return TransparentPngArgs(
      payload: map['payload']! as String,
      isQr: map['isQr']! as bool,
      foregroundArgb: map['foregroundArgb']! as int,
      symbologyName: map['symbologyName'] as String?,
      size: (map['size'] as int?) ?? AdPolicy.defaultExportSize,
    );
  }
}

class ImageExportService {
  Future<Result<ExportBytes>> exportFromBoundary({
    required RenderRepaintBoundary boundary,
    required GeneratedCode code,
    required ExportFormat format,
    double pixelRatio = 3,
  }) async {
    if (format == ExportFormat.svg || format == ExportFormat.pngTransparent) {
      return const Err(AppFailure(AppFailureCode.unsupportedFormat));
    }

    try {
      final image = await boundary.toImage(pixelRatio: pixelRatio);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        return const Err(AppFailure(AppFailureCode.exportFailed));
      }
      var pngBytes = byteData.buffer.asUint8List();

      if (format == ExportFormat.jpeg) {
        final decoded = img.decodePng(pngBytes);
        if (decoded == null) {
          return const Err(AppFailure(AppFailureCode.exportFailed));
        }
        // Ensure opaque white background for JPEG.
        final canvas = img.Image(
          width: decoded.width,
          height: decoded.height,
          numChannels: 3,
        );
        img.fill(canvas, color: img.ColorRgb8(255, 255, 255));
        img.compositeImage(canvas, decoded);
        pngBytes = Uint8List.fromList(img.encodeJpg(canvas, quality: 90));
      }

      final stamp = DateTime.now().millisecondsSinceEpoch;
      return Ok(
        ExportBytes(
          bytes: pngBytes,
          fileName: 'code_$stamp.${format.fileExtension}',
          mimeType: format.mimeType,
        ),
      );
    } catch (_) {
      return const Err(AppFailure(AppFailureCode.exportFailed));
    }
  }

  Future<Result<ExportBytes>> exportTransparentPng(
    GeneratedCode code, {
    int foregroundArgb = 0xFF000000,
    int size = AdPolicy.defaultExportSize,
  }) async {
    try {
      final args = TransparentPngArgs(
        payload: code.payloadString,
        isQr: code.kind == GeneratedKind.qr,
        symbologyName: code.barcodeSymbology?.name,
        foregroundArgb: foregroundArgb,
        size: size,
      );
      // Map is safest across isolates; fall back to sync on failure.
      late final Uint8List bytes;
      try {
        bytes = await compute(_rasterTransparentMapped, args.toMap());
      } catch (_) {
        bytes = _rasterTransparent(args);
      }
      final decoded = img.decodePng(bytes);
      if (decoded == null ||
          decoded.width != size ||
          decoded.height != size) {
        return const Err(AppFailure(AppFailureCode.exportFailed));
      }
      final stamp = DateTime.now().millisecondsSinceEpoch;
      return Ok(
        ExportBytes(
          bytes: bytes,
          fileName: 'code_${size}_$stamp.png',
          mimeType: ExportFormat.pngTransparent.mimeType,
        ),
      );
    } catch (_) {
      return const Err(AppFailure(AppFailureCode.exportFailed));
    }
  }
}

Uint8List _rasterTransparentMapped(Map<String, Object?> map) {
  return _rasterTransparent(TransparentPngArgs.fromMap(map));
}

/// Builds an exact [args.size]×[args.size] transparent PNG.
Uint8List _rasterTransparent(TransparentPngArgs args) {
  final size = args.size;
  final fg = args.foregroundArgb;
  final a = (fg >> 24) & 0xFF;
  final r = (fg >> 16) & 0xFF;
  final g = (fg >> 8) & 0xFF;
  final b = fg & 0xFF;
  final ink = img.ColorRgba8(r, g, b, a == 0 ? 255 : a);

  final out = img.Image(width: size, height: size, numChannels: 4);
  img.fill(out, color: img.ColorRgba8(0, 0, 0, 0));

  if (args.isQr) {
    _drawQr(out, payload: args.payload, ink: ink);
  } else {
    _drawBarcode(
      out,
      payload: args.payload,
      symbologyName: args.symbologyName,
      ink: ink,
    );
  }

  return Uint8List.fromList(img.encodePng(out));
}

void _drawQr(
  img.Image out, {
  required String payload,
  required img.ColorRgba8 ink,
}) {
  final qr = QrCode.fromData(
    data: payload,
    errorCorrectLevel: QrErrorCorrectLevel.M,
  );
  final image = QrImage(qr);
  final moduleCount = image.moduleCount;
  const quiet = 4;
  final total = moduleCount + quiet * 2;
  final size = out.width;

  // Integer edge mapping: module i occupies [edge(i), edge(i+1)) — no gaps.
  int edge(int i) => ((i * size) / total).floor();

  for (var y = 0; y < moduleCount; y++) {
    for (var x = 0; x < moduleCount; x++) {
      if (!image.isDark(y, x)) continue;
      final x1 = edge(x + quiet);
      final y1 = edge(y + quiet);
      final x2Exclusive = edge(x + quiet + 1);
      final y2Exclusive = edge(y + quiet + 1);
      final x2 = x2Exclusive - 1;
      final y2 = y2Exclusive - 1;
      if (x2 < x1 || y2 < y1) continue;
      // Draw pixel-by-pixel so alpha is set reliably (fillRect blends can fail
      // on fully transparent destinations with some image package paths).
      for (var py = y1; py <= y2; py++) {
        for (var px = x1; px <= x2; px++) {
          out.setPixelRgba(px, py, ink.r.toInt(), ink.g.toInt(), ink.b.toInt(),
              ink.a.toInt());
        }
      }
    }
  }
}

void _drawBarcode(
  img.Image out, {
  required String payload,
  required String? symbologyName,
  required img.ColorRgba8 ink,
}) {
  final barcode = switch (symbologyName) {
    'ean8' => Barcode.ean8(),
    'ean13' => Barcode.ean13(),
    _ => Barcode.code128(),
  };

  // Draw barcode in the middle band of the 1000×1000 canvas.
  final size = out.width;
  final barHeight = (size * 0.42).round().clamp(120, size);
  final top = (size - barHeight) ~/ 2;
  final horizontalPad = (size * 0.08).round();
  final barWidth = size - horizontalPad * 2;

  final elements = barcode.make(
    payload,
    width: barWidth.toDouble(),
    height: barHeight.toDouble(),
    drawText: false,
  );

  for (final el in elements) {
    if (el is! BarcodeBar || !el.black) continue;
    final x1 = (horizontalPad + el.left).floor().clamp(0, size - 1);
    final x2 = ((horizontalPad + el.left + el.width).ceil() - 1).clamp(0, size - 1);
    final y1 = (top + el.top.floor()).clamp(0, size - 1);
    final y2 = (top + (el.top + el.height).ceil() - 1).clamp(0, size - 1);
    if (x2 < x1 || y2 < y1) continue;
    final ir = ink.r.toInt();
    final ig = ink.g.toInt();
    final ib = ink.b.toInt();
    final ia = ink.a.toInt();
    for (var py = y1; py <= y2; py++) {
      for (var px = x1; px <= x2; px++) {
        out.setPixelRgba(px, py, ir, ig, ib, ia);
      }
    }
  }
}
