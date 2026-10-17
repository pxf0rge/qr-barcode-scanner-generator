import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:qr_barcode_app/core/config/app_config.dart';
import 'package:qr_barcode_app/core/theme/app_theme.dart';
import 'package:qr_barcode_app/data/ads/consent_service.dart';
import 'package:qr_barcode_app/features/settings/presentation/app_settings.dart';
import 'package:qr_barcode_app/l10n/app_localizations.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(appSettingsProvider);
    final notifier = ref.read(appSettingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          _SectionLabel(l10n.settingsGeneral),
          Card(
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.volume_up_outlined),
                  title: Text(l10n.settingsBeep),
                  subtitle: Text(l10n.settingsBeepHint),
                  value: settings.beep,
                  onChanged: notifier.setBeep,
                ),
                const Divider(height: 1, indent: 56),
                SwitchListTile(
                  secondary: const Icon(Icons.vibration),
                  title: Text(l10n.settingsVibrate),
                  value: settings.vibrate,
                  onChanged: notifier.setVibrate,
                ),
                const Divider(height: 1, indent: 56),
                SwitchListTile(
                  secondary: const Icon(Icons.notifications_none_rounded),
                  title: Text(l10n.settingsNotification),
                  value: settings.notification,
                  onChanged: notifier.setNotification,
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.search),
                  title: Text(l10n.settingsSearch),
                  trailing: Text(
                    settings.searchEngine.label,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onTap: () async {
                    final selected = await showModalBottomSheet<SearchEngine>(
                      context: context,
                      builder: (context) {
                        return SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              for (final engine in SearchEngine.values)
                                ListTile(
                                  title: Text(engine.label),
                                  trailing: engine == settings.searchEngine
                                      ? const Icon(
                                          Icons.check,
                                          color: AppColors.primary,
                                        )
                                      : null,
                                  onTap: () => Navigator.pop(context, engine),
                                ),
                            ],
                          ),
                        );
                      },
                    );
                    if (selected != null) {
                      await notifier.setSearchEngine(selected);
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _SectionLabel(l10n.settingsHelp),
          Card(
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.mail_outline),
                  title: Text(l10n.settingsFeedback),
                  onTap: () => _open('mailto:support@smartapps.example'),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: Text(l10n.settingsPrivacy),
                  onTap: () => _open(AppUrls.privacyPolicy),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.star_outline_rounded),
                  title: Text(l10n.settingsRate),
                  onTap: () async {
                    final info = await PackageInfo.fromPlatform();
                    await _open(
                      'https://play.google.com/store/apps/details?id=${info.packageName}',
                    );
                  },
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.manage_accounts_outlined),
                  title: Text(l10n.settingsPrivacyOptions),
                  onTap: () => ConsentService().showPrivacyOptionsForm(),
                ),
              ],
            ),
          ),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              final version = snapshot.data?.version ?? '—';
              return Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Text(
                  '${l10n.settingsVersion} $version',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.muted),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.muted,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
