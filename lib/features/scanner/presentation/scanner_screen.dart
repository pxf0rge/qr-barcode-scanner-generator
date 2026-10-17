import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:qr_barcode_app/core/router/routes.dart';
import 'package:qr_barcode_app/core/theme/app_theme.dart';
import 'package:qr_barcode_app/data/permissions/permission_service.dart';
import 'package:qr_barcode_app/data/scanner/scan_deduper.dart';
import 'package:qr_barcode_app/domain/entities/generated_code.dart';
import 'package:qr_barcode_app/features/scanner/presentation/camera_access_dialog.dart';
import 'package:qr_barcode_app/features/settings/presentation/app_settings.dart';
import 'package:qr_barcode_app/features/settings/presentation/theme_preference.dart';
import 'package:qr_barcode_app/l10n/app_localizations.dart';

class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({super.key});

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen>
    with WidgetsBindingObserver {
  static const _cameraPromptKey = 'camera_access_dialog_shown_v1';

  final _permissions = PermissionService();
  final _deduper = ScanDeduper();
  final _picker = ImagePicker();

  MobileScannerController? _controller;
  CameraPermissionState? _permission;
  bool _bootstrapping = true;
  bool _torchOn = false;
  double _zoom = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  MobileScannerController _requireController() {
    return _controller ??= MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      autoStart: false,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_permission != CameraPermissionState.granted) return;
    final controller = _controller;
    if (controller == null) return;
    switch (state) {
      case AppLifecycleState.resumed:
        controller.start();
        _deduper.unlock();
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        controller.stop();
    }
  }

  Future<void> _bootstrap() async {
    try {
      final prefs = ref.read(sharedPreferencesProvider);
      final status = await _permissions.cameraStatus();
      if (!mounted) return;

      if (status != CameraPermissionState.granted) {
        final shown = prefs.getBool(_cameraPromptKey) ?? false;
        if (!shown) {
          final grant = await showCameraAccessDialog(context);
          await prefs.setBool(_cameraPromptKey, true);
          if (grant && mounted) {
            await _requestPermission();
            return;
          }
        }
      }

      await _checkPermission();
    } finally {
      if (mounted) setState(() => _bootstrapping = false);
    }
  }

  Future<void> _checkPermission() async {
    final status = await _permissions.cameraStatus();
    if (!mounted) return;
    setState(() {
      _permission = status;
      _bootstrapping = false;
    });
    if (status == CameraPermissionState.granted) {
      final controller = _requireController();
      await controller.start();
    }
  }

  Future<void> _requestPermission() async {
    final status = await _permissions.requestCamera();
    if (!mounted) return;
    setState(() {
      _permission = status;
      _bootstrapping = false;
    });
    if (status == CameraPermissionState.granted) {
      final controller = _requireController();
      await controller.start();
    }
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    final controller = _controller;
    if (controller == null || _deduper.locked) return;
    final barcode = capture.barcodes.isEmpty ? null : capture.barcodes.first;
    final raw = barcode?.rawValue;
    if (raw == null || raw.isEmpty) return;
    if (!_deduper.accept(raw)) return;

    _deduper.lock();
    await controller.stop();
    await _feedbackOnScan();

    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    final formatName = barcode?.format.name ?? l10n.labelUnknownFormat;
    await context.push(
      AppRoutes.result,
      extra: ScanResultData(
        rawValue: raw,
        formatName: formatName,
        timestamp: DateTime.now(),
      ),
    );

    if (!mounted) return;
    _deduper.unlock();
    await controller.start();
  }

  Future<void> _feedbackOnScan() async {
    final settings = ref.read(appSettingsProvider);
    if (settings.vibrate) {
      await HapticFeedback.mediumImpact();
    }
    if (settings.beep) {
      SystemSound.play(SystemSoundType.click);
    }
  }

  Future<void> _pickFromGallery() async {
    final file = await _picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;
    final controller = _requireController();
    final capture = await controller.analyzeImage(file.path);
    if (capture == null || capture.barcodes.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).scannerNoCodeInImage),
        ),
      );
      return;
    }
    await _onDetect(capture);
  }

  Future<void> _setZoom(double value) async {
    setState(() => _zoom = value);
    await _controller?.setZoomScale(value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final permission = _permission;

    if (_bootstrapping || permission == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    return Scaffold(
      backgroundColor: permission == CameraPermissionState.granted
          ? Colors.black
          : AppColors.lightSurface,
      body: switch (permission) {
        CameraPermissionState.granted => Stack(
            fit: StackFit.expand,
            children: [
              MobileScanner(
                controller: _requireController(),
                onDetect: _onDetect,
              ),
              const _ViewfinderOverlay(),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.45),
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusSm),
                          ),
                          child: Text(
                            l10n.scannerHint,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.55),
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusLg),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.12),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  tooltip: l10n.actionTorch,
                                  onPressed: () async {
                                    await _controller?.toggleTorch();
                                    setState(() => _torchOn = !_torchOn);
                                  },
                                  icon: Icon(
                                    _torchOn
                                        ? Icons.flashlight_on_rounded
                                        : Icons.flashlight_off_outlined,
                                    color: _torchOn
                                        ? AppColors.warm
                                        : Colors.white,
                                  ),
                                ),
                                Expanded(
                                  child: SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      activeTrackColor: AppColors.accent,
                                      inactiveTrackColor: Colors.white24,
                                      thumbColor: Colors.white,
                                      overlayColor: AppColors.accent
                                          .withValues(alpha: 0.2),
                                      trackHeight: 3,
                                    ),
                                    child: Slider(
                                      value: _zoom,
                                      onChanged: _setZoom,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  tooltip: l10n.actionOpen,
                                  onPressed: _pickFromGallery,
                                  icon: const Icon(
                                    Icons.photo_library_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        CameraPermissionState.denied => _PermissionPane(
            title: l10n.cameraAccessTitle,
            body: l10n.scannerPermissionBody,
            primaryLabel: l10n.cameraAccessGrant,
            onPrimary: () async {
              final grant = await showCameraAccessDialog(context);
              if (grant) await _requestPermission();
            },
          ),
        CameraPermissionState.permanentlyDenied ||
        CameraPermissionState.restricted =>
          _PermissionPane(
            title: l10n.cameraAccessTitle,
            body: l10n.scannerPermissionPermanent,
            primaryLabel: l10n.actionOpenSettings,
            onPrimary: () async {
              await _permissions.openAppSettingsPage();
              await _checkPermission();
            },
          ),
      },
    );
  }
}

class _PermissionPane extends StatelessWidget {
  const _PermissionPane({
    required this.title,
    required this.body,
    required this.primaryLabel,
    required this.onPrimary,
  });

  final String title;
  final String body;
  final String primaryLabel;
  final VoidCallback onPrimary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.photo_camera_outlined,
              size: 40,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            body,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.muted, height: 1.4),
          ),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            child:
                FilledButton(onPressed: onPrimary, child: Text(primaryLabel)),
          ),
        ],
      ),
    );
  }
}

class _ViewfinderOverlay extends StatefulWidget {
  const _ViewfinderOverlay();

  @override
  State<_ViewfinderOverlay> createState() => _ViewfinderOverlayState();
}

class _ViewfinderOverlayState extends State<_ViewfinderOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool? _lastOffstage;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _syncAnimation(bool offstage) {
    if (_lastOffstage == offstage) return;
    _lastOffstage = offstage;
    if (offstage) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final offstage =
        context.findAncestorWidgetOfExactType<Offstage>()?.offstage ?? false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _syncAnimation(offstage);
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        final side =
            math.min(constraints.maxWidth, constraints.maxHeight) * 0.68;
        return IgnorePointer(
          child: Center(
            child: SizedBox(
              width: side,
              height: side,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _RoundedFramePainter(
                      progress: _controller.value,
                      color: AppColors.accent,
                    ),
                    child: child,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RoundedFramePainter extends CustomPainter {
  _RoundedFramePainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(
      rect.deflate(2),
      const Radius.circular(22),
    );

    final border = Paint()
      ..color = color.withValues(alpha: 0.95)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawRRect(rrect, border);

    final lineY = 16 + (size.height - 32) * progress;
    final linePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          color.withValues(alpha: 0),
          color.withValues(alpha: 0.85),
          color.withValues(alpha: 0),
        ],
      ).createShader(Rect.fromLTWH(12, lineY - 1, size.width - 24, 2));
    canvas.drawRect(
      Rect.fromLTWH(18, lineY, size.width - 36, 2),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RoundedFramePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
