import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:qr_barcode_app/core/router/routes.dart';
import 'package:qr_barcode_app/core/theme/app_theme.dart';
import 'package:qr_barcode_app/core/widgets/app_scaffold.dart';
import 'package:qr_barcode_app/core/widgets/feature_tile.dart';
import 'package:qr_barcode_app/features/ads/presentation/widgets/banner_ad_slot.dart';
import 'package:qr_barcode_app/l10n/app_localizations.dart';

class QrTypeScreen extends StatelessWidget {
  const QrTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppScaffold(
      title: Text(l10n.qrTypeTitle),
      bottomAd: const BannerAdSlot(),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          FeatureTile(
            icon: Icons.text_fields_rounded,
            title: l10n.qrTypeText,
            subtitle: l10n.qrTypeTextDesc,
            onTap: () => context.push(AppRoutes.qrText),
          ),
          FeatureTile(
            icon: Icons.link_rounded,
            title: l10n.qrTypeUrl,
            subtitle: l10n.qrTypeUrlDesc,
            accent: const Color(0xFF2F6B8A),
            onTap: () => context.push(AppRoutes.qrUrl),
          ),
          FeatureTile(
            icon: Icons.wifi_rounded,
            title: l10n.qrTypeWifi,
            subtitle: l10n.qrTypeWifiDesc,
            accent: const Color(0xFF3D7A5A),
            onTap: () => context.push(AppRoutes.qrWifi),
          ),
          FeatureTile(
            icon: Icons.contact_page_outlined,
            title: l10n.qrTypeContact,
            subtitle: l10n.qrTypeContactDesc,
            accent: const Color(0xFF8A5A2F),
            onTap: () => context.push(AppRoutes.qrContact),
          ),
          FeatureTile(
            icon: Icons.chat_rounded,
            title: l10n.qrTypeWhatsapp,
            subtitle: l10n.qrTypeWhatsappDesc,
            accent: const Color(0xFF25D366),
            onTap: () => context.push(AppRoutes.qrWhatsapp),
          ),
          FeatureTile(
            icon: Icons.play_circle_outline_rounded,
            title: l10n.qrTypeYoutube,
            subtitle: l10n.qrTypeYoutubeDesc,
            accent: const Color(0xFFCC0000),
            onTap: () => context.push(AppRoutes.qrYoutube),
          ),
          FeatureTile(
            icon: Icons.facebook_rounded,
            title: l10n.qrTypeFacebook,
            subtitle: l10n.qrTypeFacebookDesc,
            accent: const Color(0xFF1877F2),
            onTap: () => context.push(AppRoutes.qrFacebook),
          ),
          FeatureTile(
            icon: Icons.camera_alt_outlined,
            title: l10n.qrTypeInstagram,
            subtitle: l10n.qrTypeInstagramDesc,
            accent: const Color(0xFFE1306C),
            onTap: () => context.push(AppRoutes.qrInstagram),
          ),
        ],
      ),
    );
  }
}
