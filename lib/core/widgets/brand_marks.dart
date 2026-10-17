import 'package:flutter/material.dart';

import 'package:qr_barcode_app/core/theme/app_theme.dart';

/// Lightweight brand marks painted in code (no external logo assets).
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, required this.kind, this.size = 36});

  final BrandKind kind;
  final double size;

  @override
  Widget build(BuildContext context) {
    return switch (kind) {
      BrandKind.youtube => _YoutubeMark(size: size),
      BrandKind.facebook => _FacebookMark(size: size),
      BrandKind.instagram => _InstagramMark(size: size),
      BrandKind.whatsapp => _WhatsappMark(size: size),
    };
  }
}

enum BrandKind { youtube, facebook, instagram, whatsapp }

class _YoutubeMark extends StatelessWidget {
  const _YoutubeMark({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size * 0.72,
      decoration: BoxDecoration(
        color: const Color(0xFFFF0000),
        borderRadius: BorderRadius.circular(size * 0.18),
      ),
      child: Icon(
        Icons.play_arrow_rounded,
        color: Colors.white,
        size: size * 0.7,
      ),
    );
  }
}

class _FacebookMark extends StatelessWidget {
  const _FacebookMark({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF1877F2),
        borderRadius: BorderRadius.circular(size * 0.22),
      ),
      alignment: Alignment.center,
      child: Text(
        'f',
        style: TextStyle(
          color: Colors.white,
          fontSize: size * 0.72,
          fontWeight: FontWeight.w800,
          height: 1,
        ),
      ),
    );
  }
}

class _InstagramMark extends StatelessWidget {
  const _InstagramMark({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.28),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFFF58529),
            Color(0xFFDD2A7B),
            Color(0xFF8134AF),
            Color(0xFF515BD4),
          ],
        ),
      ),
      child: Icon(
        Icons.camera_alt_outlined,
        color: Colors.white,
        size: size * 0.5,
      ),
    );
  }
}

class _WhatsappMark extends StatelessWidget {
  const _WhatsappMark({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFF25D366),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.chat_rounded,
        color: Colors.white,
        size: size * 0.5,
      ),
    );
  }
}

class CreateTypeIcon extends StatelessWidget {
  const CreateTypeIcon({super.key, required this.icon, this.size = 32});

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(icon, size: size, color: AppColors.primary);
  }
}
