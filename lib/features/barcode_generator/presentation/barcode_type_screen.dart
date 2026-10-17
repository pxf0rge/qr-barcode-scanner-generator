import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:qr_barcode_app/core/router/routes.dart';
import 'package:qr_barcode_app/core/theme/app_theme.dart';
import 'package:qr_barcode_app/core/widgets/app_scaffold.dart';
import 'package:qr_barcode_app/core/widgets/feature_tile.dart';
import 'package:qr_barcode_app/features/ads/presentation/widgets/banner_ad_slot.dart';
import 'package:qr_barcode_app/l10n/app_localizations.dart';

class BarcodeTypeScreen extends StatelessWidget {
  const BarcodeTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppScaffold(
      title: Text(l10n.barcodeTypeTitle),
      bottomAd: const BannerAdSlot(),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          FeatureTile(
            icon: Icons.view_week_rounded,
            title: l10n.barcodeTypeCode128,
            subtitle: l10n.barcodeTypeCode128Desc,
            onTap: () => context.push(AppRoutes.barcodeCode128),
          ),
          FeatureTile(
            icon: Icons.numbers_rounded,
            title: l10n.barcodeTypeEan8,
            subtitle: l10n.barcodeTypeEan8Desc,
            accent: const Color(0xFF2F6B8A),
            onTap: () => context.push(AppRoutes.barcodeEan8),
          ),
          FeatureTile(
            icon: Icons.pin_rounded,
            title: l10n.barcodeTypeEan13,
            subtitle: l10n.barcodeTypeEan13Desc,
            accent: const Color(0xFF8A5A2F),
            onTap: () => context.push(AppRoutes.barcodeEan13),
          ),
        ],
      ),
    );
  }
}
