import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:qr_barcode_app/core/config/app_config.dart';
import 'package:qr_barcode_app/core/router/routes.dart';
import 'package:qr_barcode_app/core/theme/app_theme.dart';
import 'package:qr_barcode_app/core/widgets/main_shell.dart';
import 'package:qr_barcode_app/data/ads/ads_bootstrap.dart';
import 'package:qr_barcode_app/features/settings/presentation/theme_preference.dart';
import 'package:qr_barcode_app/l10n/app_localizations.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _start(BuildContext context, WidgetRef ref) async {
    await WelcomeGate.complete(ref.read(sharedPreferencesProvider));
    if (context.mounted) {
      context.go(AppRoutes.create);
    }
    Future<void>.delayed(const Duration(milliseconds: 1200), () {
      unawaited(AdsBootstrap.run());
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F766E),
              Color(0xFF146B64),
              Color(0xFF1A8A7F),
              Color(0xFFF2F7F6),
            ],
            stops: [0.0, 0.28, 0.52, 0.88],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 24, 28, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(flex: 2),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Image.asset('assets/app_icon.png'),
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  l10n.welcomeBrand,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.8,
                    height: 1.05,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.appSubtitle,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.45,
                    color: Colors.white.withValues(alpha: 0.88),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Spacer(flex: 3),
                FilledButton(
                  onPressed: () => _start(context, ref),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primaryDark,
                    minimumSize: const Size.fromHeight(54),
                  ),
                  child: Text(l10n.welcomeStart),
                ),
                const SizedBox(height: 16),
                Text.rich(
                  TextSpan(
                    style: TextStyle(
                      fontSize: 12.5,
                      color: scheme.onSurface.withValues(alpha: 0.7),
                      height: 1.4,
                    ),
                    children: [
                      TextSpan(text: '${l10n.welcomeAgreePrefix} '),
                      TextSpan(
                        text: l10n.welcomePrivacyPolicy,
                        style: const TextStyle(
                          color: AppColors.primaryDark,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w600,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => _open(AppUrls.privacyPolicy),
                      ),
                      const TextSpan(text: ' and '),
                      TextSpan(
                        text: l10n.welcomeTerms,
                        style: const TextStyle(
                          color: AppColors.primaryDark,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w600,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => _open(AppUrls.termsOfService),
                      ),
                      const TextSpan(text: '.'),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
