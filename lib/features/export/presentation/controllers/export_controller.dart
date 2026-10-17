import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qr_barcode_app/data/ads/ads_bootstrap.dart';
import 'package:qr_barcode_app/data/ads/interstitial_ad_manager.dart';
import 'package:qr_barcode_app/data/ads/rewarded_ad_manager.dart';
import 'package:qr_barcode_app/data/export/image_export_service.dart';
import 'package:qr_barcode_app/data/export/svg_export_service.dart';
import 'package:qr_barcode_app/data/share/share_service.dart';
import 'package:qr_barcode_app/domain/ads/reward_gate.dart';
import 'package:qr_barcode_app/domain/entities/app_failure.dart';
import 'package:qr_barcode_app/domain/entities/generated_code.dart';
import 'package:qr_barcode_app/domain/export/export_format.dart';

enum ExportPhase { idle, loadingAd, showingAd, exporting, success }

class ExportState {
  const ExportState({
    this.phase = ExportPhase.idle,
    this.failure,
    this.lastBytes,
    this.lastSavedPath,
  });

  final ExportPhase phase;
  final AppFailure? failure;
  final ExportBytes? lastBytes;
  final String? lastSavedPath;

  ExportState copyWith({
    ExportPhase? phase,
    AppFailure? failure,
    ExportBytes? lastBytes,
    String? lastSavedPath,
    bool clearFailure = false,
    bool clearSavedPath = false,
  }) {
    return ExportState(
      phase: phase ?? this.phase,
      failure: clearFailure ? null : (failure ?? this.failure),
      lastBytes: lastBytes ?? this.lastBytes,
      lastSavedPath:
          clearSavedPath ? null : (lastSavedPath ?? this.lastSavedPath),
    );
  }
}

final rewardGateProvider = Provider<RewardGate>((ref) => RewardGate());

/// Same instance warmed by [AdsBootstrap] so preload is not wasted.
final rewardedAdManagerProvider = Provider<RewardedAdManager>((ref) {
  return AdsBootstrap.rewarded;
});

final interstitialAdManagerProvider = Provider<InterstitialAdManager>((ref) {
  return AdsBootstrap.interstitial;
});

final imageExportServiceProvider = Provider((ref) => ImageExportService());
final svgExportServiceProvider = Provider((ref) => SvgExportService());
final shareServiceProvider = Provider((ref) => ShareService());
final gallerySaveServiceProvider = Provider((ref) => GallerySaveService());

final exportControllerProvider =
    NotifierProvider<ExportController, ExportState>(ExportController.new);

class ExportController extends Notifier<ExportState> {
  @override
  ExportState build() => const ExportState();

  Future<Result<ExportBytes>> export({
    required GeneratedCode code,
    required ExportFormat format,
    required RenderRepaintBoundary? boundary,
    int foregroundArgb = 0xFF000000,
  }) async {
    state = state.copyWith(
      phase: ExportPhase.idle,
      clearFailure: true,
      clearSavedPath: true,
    );

    if (format.isComingSoon) {
      const failure = AppFailure(AppFailureCode.unsupportedFormat);
      state = state.copyWith(phase: ExportPhase.idle, failure: failure);
      return const Err(failure);
    }

    final gate = ref.read(rewardGateProvider);
    final unlockKey = 'premium_${format.name}';

    if (format.isPremium) {
      if (!gate.isUnlocked(unlockKey)) {
        state = state.copyWith(phase: ExportPhase.loadingAd);
        final rewarded = ref.read(rewardedAdManagerProvider);
        final showResult = await rewarded.show(
          onEarned: () => gate.grant(unlockKey),
        );

        if (showResult.isErr) {
          if (rewarded.allowDebugUnlockFallback && kDebugMode) {
            gate.grant(unlockKey);
          } else {
            state = state.copyWith(
              phase: ExportPhase.idle,
              failure: showResult.failureOrNull,
            );
            return Err(showResult.failureOrNull!);
          }
        }
      }

      if (!gate.isUnlocked(unlockKey)) {
        const failure = AppFailure(AppFailureCode.adNotEarned);
        state = state.copyWith(phase: ExportPhase.idle, failure: failure);
        return const Err(failure);
      }
    }

    state = state.copyWith(phase: ExportPhase.exporting);
    final result = await _performExport(
      code: code,
      format: format,
      boundary: boundary,
      foregroundArgb: foregroundArgb,
    );

    return result.when(
      ok: (bytes) {
        if (format.isPremium) {
          gate.consume(unlockKey);
        }
        state = state.copyWith(phase: ExportPhase.success, lastBytes: bytes);
        if (!format.isPremium) {
          unawaited(
            ref.read(interstitialAdManagerProvider).onRelevantAction(),
          );
        }
        return Ok(bytes);
      },
      err: (failure) {
        if (format.isPremium) {
          gate.grantExportRetry(unlockKey);
        }
        state = state.copyWith(phase: ExportPhase.idle, failure: failure);
        return Err(failure);
      },
    );
  }

  Future<Result<ExportBytes>> _performExport({
    required GeneratedCode code,
    required ExportFormat format,
    required RenderRepaintBoundary? boundary,
    int foregroundArgb = 0xFF000000,
  }) async {
    final images = ref.read(imageExportServiceProvider);
    final svgs = ref.read(svgExportServiceProvider);

    switch (format) {
      case ExportFormat.jpeg:
      case ExportFormat.pngOpaque:
        if (boundary == null) {
          return const Err(AppFailure(AppFailureCode.exportFailed));
        }
        return images.exportFromBoundary(
          boundary: boundary,
          code: code,
          format: format,
        );
      case ExportFormat.pngTransparent:
        return images.exportTransparentPng(
          code,
          foregroundArgb: foregroundArgb,
        );
      case ExportFormat.svg:
        // Kept for future V2 — not offered in V1 UI.
        final svgResult = svgs.export(code);
        return svgResult.when(
          ok: (like) => Ok(
            ExportBytes(
              bytes: like.bytes,
              fileName: like.fileName,
              mimeType: like.mimeType,
            ),
          ),
          err: Err.new,
        );
    }
  }

  /// Fairness: if SVG save fails after the ad, allow one more try without a new ad.
  void restorePremiumRetry(ExportFormat format) {
    if (!format.isPremium) return;
    ref.read(rewardGateProvider).grantExportRetry('premium_${format.name}');
  }

  Future<Result<void>> shareLast() async {
    final bytes = state.lastBytes;
    if (bytes == null) {
      return const Err(AppFailure(AppFailureCode.shareFailed));
    }
    return ref.read(shareServiceProvider).shareBytes(
          bytes: bytes.bytes,
          fileName: bytes.fileName,
          mimeType: bytes.mimeType,
        );
  }

  Future<Result<String>> saveLastFile() async {
    final bytes = state.lastBytes;
    if (bytes == null) {
      return const Err(AppFailure(AppFailureCode.saveFailed));
    }
    final result = await ref.read(shareServiceProvider).saveBytes(
          bytes: bytes.bytes,
          fileName: bytes.fileName,
          mimeType: bytes.mimeType,
        );
    return result.when(
      ok: (path) {
        state = state.copyWith(lastSavedPath: path);
        return Ok(path);
      },
      err: Err.new,
    );
  }

  Future<Result<void>> saveLastToGallery() async {
    final bytes = state.lastBytes;
    if (bytes == null) {
      return const Err(AppFailure(AppFailureCode.saveFailed));
    }
    if (bytes.mimeType == ExportFormat.svg.mimeType) {
      return const Err(AppFailure(AppFailureCode.unsupportedFormat));
    }
    return ref.read(gallerySaveServiceProvider).saveImageBytes(
          bytes.bytes,
          name: bytes.fileName,
        );
  }

  void reset() {
    state = const ExportState();
  }
}
