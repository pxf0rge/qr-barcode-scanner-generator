import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:qr_barcode_app/core/errors/async_guard.dart';
import 'package:qr_barcode_app/core/theme/app_theme.dart';
import 'package:qr_barcode_app/core/widgets/app_scaffold.dart';
import 'package:qr_barcode_app/domain/entities/barcode_models.dart';
import 'package:qr_barcode_app/domain/entities/generated_code.dart';
import 'package:qr_barcode_app/domain/export/export_format.dart';
import 'package:qr_barcode_app/domain/qr/qr_style.dart';
import 'package:qr_barcode_app/features/ads/presentation/widgets/banner_ad_slot.dart';
import 'package:qr_barcode_app/features/export/presentation/controllers/export_controller.dart';
import 'package:qr_barcode_app/features/history/presentation/history_screen.dart';
import 'package:qr_barcode_app/l10n/app_localizations.dart';

class PreviewScreen extends ConsumerStatefulWidget {
  const PreviewScreen({super.key, required this.code});

  final GeneratedCode code;

  @override
  ConsumerState<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends ConsumerState<PreviewScreen> {
  final _boundaryKey = GlobalKey();
  bool _expanded = false;
  QrStyle _style = const QrStyle();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final repo = ref.read(historyRepositoryProvider);
      await repo.addGenerated(widget.code);
      ref.read(historyEntriesProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final code = widget.code;
    final isQr = code.kind == GeneratedKind.qr;
    final exportState = ref.watch(exportControllerProvider);
    final busy = exportState.phase == ExportPhase.loadingAd ||
        exportState.phase == ExportPhase.showingAd ||
        exportState.phase == ExportPhase.exporting;

    return AppScaffold(
      title: Text(l10n.previewTitle),
      bottomAd: const BannerAdSlot(),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                Center(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: isQr ? _style.background : AppColors.quietZone,
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radius),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .outlineVariant
                            .withValues(alpha: 0.5),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radius),
                      child: RepaintBoundary(
                        key: _boundaryKey,
                        child: ColoredBox(
                          color: isQr ? _style.background : AppColors.quietZone,
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.xl),
                            child: _CodeVisual(code: code, style: _style),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (isQr) ...[
                  const SizedBox(height: AppSpacing.xl),
                  _QrCustomizePanel(
                    style: _style,
                    onChanged: (next) => setState(() => _style = next),
                  ),
                ],
                const SizedBox(height: AppSpacing.xl),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Chip(
                    avatar: Icon(
                      isQr
                          ? Icons.qr_code_2_rounded
                          : Icons.view_week_rounded,
                      size: 18,
                    ),
                    label: Text(code.displayTitle),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  l10n.previewContent,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: AppSpacing.sm),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest
                        .withValues(alpha: 0.45),
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: SelectableText(
                      _expanded || code.payloadString.length <= 200
                          ? code.payloadString
                          : '${code.payloadString.substring(0, 200)}…',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
                if (code.payloadString.length > 200)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () => setState(() => _expanded = !_expanded),
                      child: Text(
                        _expanded ? l10n.actionShowLess : l10n.actionShowMore,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .outlineVariant
                        .withValues(alpha: 0.5),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: busy
                          ? null
                          : () {
                              Clipboard.setData(
                                ClipboardData(text: code.payloadString),
                              );
                              showSuccessSnackBar(
                                context,
                                l10n.commonSuccessCopied,
                              );
                            },
                      icon: const Icon(Icons.copy_rounded),
                      label: Text(l10n.actionCopy),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    flex: 1,
                    child: FilledButton.icon(
                      onPressed: busy
                          ? null
                          : () => _showExportSheet(context),
                      icon: busy
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.download_rounded),
                      label: Text(
                        busy ? l10n.exporting : l10n.actionExport,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showExportSheet(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final format = await showModalBottomSheet<ExportFormat>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  l10n.exportTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              _FormatTile(
                title: l10n.exportJpeg,
                badge: l10n.exportFree,
                onTap: () => Navigator.pop(context, ExportFormat.jpeg),
              ),
              _FormatTile(
                title: l10n.exportPng,
                badge: l10n.exportFree,
                onTap: () => Navigator.pop(context, ExportFormat.pngOpaque),
              ),
              _FormatTile(
                title: l10n.exportPngTransparent,
                badge: l10n.exportPremium,
                locked: true,
                onTap: () =>
                    Navigator.pop(context, ExportFormat.pngTransparent),
              ),
              _FormatTile(
                title: l10n.exportSvg,
                badge: l10n.exportComingSoon,
                comingSoon: true,
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        );
      },
    );

    if (format == null || !context.mounted) return;
    await runGuarded<void>(
      context: context,
      action: () async {
        await _runExport(format);
      },
    );
  }

  Future<void> _runExport(ExportFormat format) async {
    final l10n = AppLocalizations.of(context);
    final boundary = _boundaryKey.currentContext?.findRenderObject()
        as RenderRepaintBoundary?;

    final controller = ref.read(exportControllerProvider.notifier);
    final result = await controller.export(
      code: widget.code,
      format: format,
      boundary: boundary,
      foregroundArgb: _style.foreground.toARGB32(),
    );

    if (!mounted) return;

    if (result.isErr) {
      showErrorSnackBar(context, result.failureOrNull!);
      return;
    }

    // Full-screen ads leave the activity unsettled; wait before another sheet.
    await Future<void>.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;

    // Transparent PNG: offer both Downloads (keeps alpha) and Gallery.
    final isTransparentPng = format == ExportFormat.pngTransparent;

    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.share),
                title: Text(l10n.actionShare),
                onTap: () => Navigator.pop(context, 'share'),
              ),
              if (isTransparentPng)
                ListTile(
                  leading: const Icon(Icons.download_outlined),
                  title: Text(l10n.exportSaveFile),
                  subtitle: Text(l10n.exportSaveDownloadsHint),
                  onTap: () => Navigator.pop(context, 'save_downloads'),
                ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text(l10n.actionSaveGallery),
                onTap: () => Navigator.pop(context, 'save_gallery'),
              ),
              ListTile(
                leading: const Icon(Icons.close),
                title: Text(l10n.actionCancel),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );

    if (!mounted || action == null) return;
    if (action == 'share') {
      final shareResult = await controller.shareLast();
      if (!mounted) return;
      shareResult.when(
        ok: (_) => showSuccessSnackBar(context, l10n.commonSuccessShared),
        err: (f) => showErrorSnackBar(context, f),
      );
    } else if (action == 'save_downloads') {
      final saveResult = await controller.saveLastFile();
      if (!mounted) return;
      saveResult.when(
        ok: (_) => showSuccessSnackBar(context, l10n.exportSavedTransparentPng),
        err: (f) => showErrorSnackBar(context, f),
      );
    } else if (action == 'save_gallery') {
      final saveResult = await controller.saveLastToGallery();
      if (!mounted) return;
      saveResult.when(
        ok: (_) => showSuccessSnackBar(context, l10n.commonSuccessSaved),
        err: (f) => showErrorSnackBar(context, f),
      );
    }
  }
}

class _QrCustomizePanel extends StatelessWidget {
  const _QrCustomizePanel({
    required this.style,
    required this.onChanged,
  });

  final QrStyle style;
  final ValueChanged<QrStyle> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.qrCustomizeTitle,
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          l10n.qrCustomizeColor,
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final color in QrStyle.presets)
              _ColorDot(
                color: color,
                selected: style.foreground.toARGB32() == color.toARGB32(),
                onTap: () => onChanged(style.copyWith(foreground: color)),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          l10n.qrCustomizeShape,
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SegmentedButton<QrDataModuleShape>(
          segments: [
            ButtonSegment(
              value: QrDataModuleShape.square,
              label: Text(l10n.qrShapeSquare),
              icon: const Icon(Icons.square_rounded, size: 16),
            ),
            ButtonSegment(
              value: QrDataModuleShape.circle,
              label: Text(l10n.qrShapeCircle),
              icon: const Icon(Icons.circle, size: 16),
            ),
          ],
          selected: {style.moduleShape},
          onSelectionChanged: (next) {
            final shape = next.first;
            onChanged(
              style.copyWith(
                moduleShape: shape,
                eyeShape: shape == QrDataModuleShape.circle
                    ? QrEyeShape.circle
                    : QrEyeShape.square,
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outlineVariant,
            width: selected ? 3 : 1,
          ),
        ),
      ),
    );
  }
}

class _FormatTile extends StatelessWidget {
  const _FormatTile({
    required this.title,
    required this.badge,
    required this.onTap,
    this.locked = false,
    this.comingSoon = false,
  });

  final String title;
  final String badge;
  final VoidCallback onTap;
  final bool locked;
  final bool comingSoon;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final enabled = !comingSoon;
    return ListTile(
      enabled: enabled,
      leading: Icon(
        comingSoon
            ? Icons.schedule_outlined
            : locked
                ? Icons.lock_outline
                : Icons.image_outlined,
        semanticLabel: comingSoon
            ? l10n.exportComingSoon
            : locked
                ? l10n.labelRequiresAd
                : null,
      ),
      title: Text(title),
      subtitle: comingSoon
          ? Text(l10n.exportComingSoonHint)
          : locked
              ? Text(l10n.labelRequiresAd)
              : null,
      trailing: Text(
        badge,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: comingSoon
                  ? Theme.of(context).colorScheme.onSurfaceVariant
                  : null,
            ),
      ),
      onTap: enabled ? onTap : null,
    );
  }
}

class _CodeVisual extends StatelessWidget {
  const _CodeVisual({required this.code, required this.style});

  final GeneratedCode code;
  final QrStyle style;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final maxSide = (MediaQuery.sizeOf(context).width - 64).clamp(160.0, 280.0);

    if (code.kind == GeneratedKind.qr) {
      return Semantics(
        label: l10n.semanticsQrPreview,
        image: true,
        child: QrImageView(
          data: code.payloadString,
          size: maxSide,
          backgroundColor: style.background,
          eyeStyle: QrEyeStyle(
            eyeShape: style.eyeShape,
            color: style.foreground,
          ),
          dataModuleStyle: QrDataModuleStyle(
            dataModuleShape: style.moduleShape,
            color: style.foreground,
          ),
        ),
      );
    }

    final barcode = switch (code.barcodeSymbology) {
      BarcodeSymbology.ean8 => Barcode.ean8(),
      BarcodeSymbology.ean13 => Barcode.ean13(),
      _ => Barcode.code128(),
    };

    return Semantics(
      label: l10n.semanticsBarcodePreview,
      image: true,
      child: SizedBox(
        width: maxSide,
        child: BarcodeWidget(
          barcode: barcode,
          data: code.payloadString,
          width: maxSide,
          height: maxSide / 3,
          color: Colors.black,
          backgroundColor: AppColors.quietZone,
          drawText: true,
        ),
      ),
    );
  }
}
