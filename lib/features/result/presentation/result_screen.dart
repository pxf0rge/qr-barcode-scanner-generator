import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:qr_barcode_app/core/router/routes.dart';
import 'package:qr_barcode_app/core/theme/app_theme.dart';
import 'package:qr_barcode_app/core/widgets/app_scaffold.dart';
import 'package:qr_barcode_app/data/share/share_service.dart';
import 'package:qr_barcode_app/domain/entities/generated_code.dart';
import 'package:qr_barcode_app/domain/entities/qr_models.dart';
import 'package:qr_barcode_app/domain/scan/content_classifier.dart';
import 'package:qr_barcode_app/features/ads/presentation/widgets/banner_ad_slot.dart';
import 'package:qr_barcode_app/features/history/presentation/history_screen.dart';
import 'package:qr_barcode_app/l10n/app_localizations.dart';

class ResultScreen extends ConsumerStatefulWidget {
  const ResultScreen({super.key, required this.data});

  final ScanResultData data;

  @override
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(historyRepositoryProvider).addScan(widget.data);
      ref.read(historyEntriesProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final l10n = AppLocalizations.of(context);
    final classified = const ContentClassifier().classify(data.rawValue);
    final share = ShareService();
    final canOpen = _canOpen(classified);

    return AppScaffold(
      title: Text(l10n.resultTitle),
      bottomAd: const BannerAdSlot(),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(
            data.formatName,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          SelectableText(
            data.rawValue,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          ..._structured(context, classified, l10n),
          const SizedBox(height: AppSpacing.xl),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              FilledButton.tonalIcon(
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: data.rawValue));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.commonSuccessCopied)),
                    );
                  }
                },
                icon: const Icon(Icons.copy),
                label: Text(l10n.actionCopy),
              ),
              FilledButton.tonalIcon(
                onPressed: () => share.shareText(data.rawValue),
                icon: const Icon(Icons.share),
                label: Text(l10n.actionShare),
              ),
              if (canOpen)
                FilledButton.icon(
                  onPressed: () => _open(classified),
                  icon: const Icon(Icons.open_in_new),
                  label: Text(l10n.actionOpen),
                ),
              if (classified.kind == ClassifiedKind.phone)
                FilledButton.icon(
                  onPressed: () => _launch(_telUri(classified.rawValue)),
                  icon: const Icon(Icons.call),
                  label: Text(l10n.actionCall),
                ),
              if (classified.kind == ClassifiedKind.email)
                FilledButton.icon(
                  onPressed: () => _launch(_mailtoUri(classified.rawValue)),
                  icon: const Icon(Icons.email_outlined),
                  label: Text(l10n.actionEmail),
                ),
              FilledButton.icon(
                onPressed: () {
                  context.push(
                    AppRoutes.preview,
                    extra: GeneratedCode.qr(
                      type: QrContentType.text,
                      payload: data.rawValue,
                      title: l10n.resultCreateQr,
                    ),
                  );
                },
                icon: const Icon(Icons.qr_code_2),
                label: Text(l10n.resultCreateQr),
              ),
              OutlinedButton.icon(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.qr_code_scanner),
                label: Text(l10n.actionScanAgain),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool _canOpen(ClassifiedContent classified) {
    switch (classified.kind) {
      case ClassifiedKind.url:
        return true;
      case ClassifiedKind.phone:
      case ClassifiedKind.email:
        return true;
      case ClassifiedKind.vcard:
        final website = classified.contactFields['URL'];
        final email = classified.contactFields['EMAIL'];
        return (website != null && website.isNotEmpty) ||
            (email != null && email.isNotEmpty);
      case ClassifiedKind.wifi:
        return false;
      case ClassifiedKind.text:
        final uri = Uri.tryParse(classified.rawValue.trim());
        return uri != null &&
            uri.hasScheme &&
            (uri.isScheme('http') ||
                uri.isScheme('https') ||
                uri.isScheme('mailto') ||
                uri.isScheme('tel') ||
                uri.isScheme('sms') ||
                uri.isScheme('geo'));
    }
  }

  Future<void> _open(ClassifiedContent classified) async {
    switch (classified.kind) {
      case ClassifiedKind.url:
      case ClassifiedKind.text:
        await _launch(classified.rawValue);
      case ClassifiedKind.phone:
        await _launch(_telUri(classified.rawValue));
      case ClassifiedKind.email:
        await _launch(_mailtoUri(classified.rawValue));
      case ClassifiedKind.vcard:
        final website = classified.contactFields['URL'];
        if (website != null && website.isNotEmpty) {
          await _launch(website);
          return;
        }
        final email = classified.contactFields['EMAIL'];
        if (email != null && email.isNotEmpty) {
          await _launch(_mailtoUri(email));
        }
      case ClassifiedKind.wifi:
        break;
    }
  }

  List<Widget> _structured(
    BuildContext context,
    ClassifiedContent classified,
    AppLocalizations l10n,
  ) {
    switch (classified.kind) {
      case ClassifiedKind.wifi:
        return [
          Text(
            l10n.resultWifiTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text('${l10n.fieldSsid}: ${classified.wifiSsid ?? '-'}'),
          Text('${l10n.fieldPassword}: ${classified.wifiPassword ?? '-'}'),
          Text('${l10n.fieldSecurity}: ${classified.wifiSecurity ?? '-'}'),
        ];
      case ClassifiedKind.vcard:
        return [
          Text(
            l10n.resultContactTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          ...classified.contactFields.entries.map(
            (e) => Text('${e.key}: ${e.value}'),
          ),
        ];
      default:
        return const [];
    }
  }

  String _telUri(String raw) {
    if (raw.toLowerCase().startsWith('tel:')) return raw;
    return 'tel:$raw';
  }

  String _mailtoUri(String raw) {
    if (raw.toLowerCase().startsWith('mailto:')) return raw;
    return 'mailto:$raw';
  }

  Future<void> _launch(String value) async {
    final uri = Uri.tryParse(value);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
