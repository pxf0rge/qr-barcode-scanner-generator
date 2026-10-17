import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// Basic on-device QR appearance for preview and raster export.
@immutable
class QrStyle {
  const QrStyle({
    this.foreground = const Color(0xFF000000),
    this.background = const Color(0xFFFFFFFF),
    this.eyeShape = QrEyeShape.square,
    this.moduleShape = QrDataModuleShape.square,
  });

  final Color foreground;
  final Color background;
  final QrEyeShape eyeShape;
  final QrDataModuleShape moduleShape;

  static const presets = <Color>[
    Color(0xFF000000),
    Color(0xFF0F766E),
    Color(0xFF1D4ED8),
    Color(0xFF7C3AED),
    Color(0xFFBE123C),
    Color(0xFFC2410C),
  ];

  QrStyle copyWith({
    Color? foreground,
    Color? background,
    QrEyeShape? eyeShape,
    QrDataModuleShape? moduleShape,
  }) {
    return QrStyle(
      foreground: foreground ?? this.foreground,
      background: background ?? this.background,
      eyeShape: eyeShape ?? this.eyeShape,
      moduleShape: moduleShape ?? this.moduleShape,
    );
  }
}
