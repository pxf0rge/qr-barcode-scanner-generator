import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:qr_barcode_app/core/router/routes.dart';
import 'package:qr_barcode_app/core/theme/app_theme.dart';
import 'package:qr_barcode_app/core/widgets/app_scaffold.dart';
import 'package:qr_barcode_app/data/permissions/startup_permission_gate.dart';
import 'package:qr_barcode_app/features/ads/presentation/widgets/banner_ad_slot.dart';
import 'package:qr_barcode_app/features/settings/presentation/theme_preference.dart';
import 'package:qr_barcode_app/l10n/app_localizations.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestStartupPermissions();
    });
  }

  Future<void> _requestStartupPermissions() async {
    if (!mounted) return;
    final prefs = ref.read(sharedPreferencesProvider);
    await StartupPermissionGate.run(context: context, prefs: prefs);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final topInset = MediaQuery.paddingOf(context).top + kToolbarHeight;

    return AppScaffold(
      transparentAppBar: true,
      extendBodyBehindAppBar: true,
      actions: [
        IconButton(
          tooltip: l10n.actionSettings,
          onPressed: () => context.push(AppRoutes.settings),
          icon: const Icon(Icons.settings_outlined),
        ),
      ],
      bottomAd: const BannerAdSlot(),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    scheme.primary.withValues(alpha: 0.28),
                    scheme.primary.withValues(alpha: 0.12),
                    scheme.surface.withValues(alpha: 0.92),
                    scheme.surface,
                  ]
                : [
                    const Color(0xFFBFE8E2),
                    const Color(0xFFD9EFEC),
                    const Color(0xFFEEF6F5),
                    scheme.surface,
                  ],
            // Keep wash visible until near the bottom of the screen.
            stops: const [0.0, 0.45, 0.82, 1.0],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.xl,
            topInset + AppSpacing.sm,
            AppSpacing.xl,
            AppSpacing.xl,
          ),
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: scheme.primary.withValues(alpha: isDark ? 0.35 : 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.qr_code_2_rounded,
                    color: scheme.primary,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    l10n.appTitle,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.8,
                          height: 1.05,
                          color: scheme.onSurface,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              l10n.appSubtitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            _HomeActionCard(
              icon: Icons.qr_code_2_rounded,
              title: l10n.actionCreateQr,
              subtitle: l10n.qrTypeTextDesc,
              semanticLabel: l10n.semanticsHomeAction(l10n.actionCreateQr),
              accent: scheme.primary,
              onTap: () => context.push(AppRoutes.qr),
            ),
            const SizedBox(height: AppSpacing.md),
            _HomeActionCard(
              icon: Icons.view_week_rounded,
              title: l10n.actionCreateBarcode,
              subtitle: l10n.barcodeTypeCode128Desc,
              semanticLabel: l10n.semanticsHomeAction(l10n.actionCreateBarcode),
              accent: const Color(0xFF2F6B8A),
              onTap: () => context.push(AppRoutes.barcode),
            ),
            const SizedBox(height: AppSpacing.md),
            _HomeActionCard(
              icon: Icons.qr_code_scanner_rounded,
              title: l10n.actionScan,
              subtitle: l10n.scannerHint,
              semanticLabel: l10n.semanticsHomeAction(l10n.actionScan),
              accent: const Color(0xFFC45C26),
              emphasized: true,
              onTap: () => context.push(AppRoutes.scanner),
            ),
            const SizedBox(height: AppSpacing.md),
            _HomeActionCard(
              icon: Icons.history_rounded,
              title: l10n.actionHistory,
              subtitle: l10n.historyTitle,
              semanticLabel: l10n.semanticsHomeAction(l10n.actionHistory),
              accent: const Color(0xFF5A4A8A),
              onTap: () => context.push(AppRoutes.history),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeActionCard extends StatelessWidget {
  const _HomeActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.semanticLabel,
    required this.accent,
    required this.onTap,
    this.emphasized = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String semanticLabel;
  final Color accent;
  final VoidCallback onTap;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      button: true,
      label: semanticLabel,
      child: Material(
        color: emphasized
            ? (isDark
                ? accent.withValues(alpha: 0.22)
                : accent.withValues(alpha: 0.1))
            : (isDark
                ? scheme.surfaceContainerHigh.withValues(alpha: 0.9)
                : Colors.white.withValues(alpha: 0.92)),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radius),
          side: BorderSide(
            color: emphasized
                ? accent.withValues(alpha: 0.35)
                : scheme.outlineVariant.withValues(alpha: 0.55),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        accent.withValues(alpha: 0.95),
                        accent.withValues(alpha: 0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: Colors.white, size: 28),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: accent.withValues(alpha: 0.9),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
