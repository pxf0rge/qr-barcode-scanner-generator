import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:qr_barcode_app/core/router/routes.dart';
import 'package:qr_barcode_app/core/widgets/main_shell.dart';
import 'package:qr_barcode_app/domain/entities/generated_code.dart';
import 'package:qr_barcode_app/domain/qr/social_qr_encoder.dart';
import 'package:qr_barcode_app/features/barcode_generator/presentation/barcode_code128_form.dart';
import 'package:qr_barcode_app/features/barcode_generator/presentation/barcode_ean13_form.dart';
import 'package:qr_barcode_app/features/barcode_generator/presentation/barcode_ean8_form.dart';
import 'package:qr_barcode_app/features/barcode_generator/presentation/barcode_type_screen.dart';
import 'package:qr_barcode_app/features/create/presentation/create_screen.dart';
import 'package:qr_barcode_app/features/history/presentation/history_screen.dart';
import 'package:qr_barcode_app/features/preview/presentation/preview_screen.dart';
import 'package:qr_barcode_app/features/qr_generator/presentation/qr_contact_form.dart';
import 'package:qr_barcode_app/features/qr_generator/presentation/qr_extra_forms.dart';
import 'package:qr_barcode_app/features/qr_generator/presentation/qr_social_form.dart';
import 'package:qr_barcode_app/features/qr_generator/presentation/qr_text_form.dart';
import 'package:qr_barcode_app/features/qr_generator/presentation/qr_url_form.dart';
import 'package:qr_barcode_app/features/qr_generator/presentation/qr_wifi_form.dart';
import 'package:qr_barcode_app/features/result/presentation/result_screen.dart';
import 'package:qr_barcode_app/features/scanner/presentation/scanner_screen.dart';
import 'package:qr_barcode_app/features/settings/presentation/settings_screen.dart';
import 'package:qr_barcode_app/features/settings/presentation/theme_preference.dart';
import 'package:qr_barcode_app/features/welcome/presentation/welcome_screen.dart';
import 'package:qr_barcode_app/l10n/app_localizations.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final appRouterProvider = Provider<GoRouter>((ref) {
  final welcomeDone =
      ref.watch(sharedPreferencesProvider).getBool(welcomeCompletedKey) ??
          false;

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: welcomeDone ? AppRoutes.create : AppRoutes.welcome,
    routes: [
      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.scanner,
                builder: (context, state) => const ScannerScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.history,
                builder: (context, state) => const HistoryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.create,
                builder: (context, state) => const CreateScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: AppRoutes.qrText,
        builder: (context, state) => const QrTextForm(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: AppRoutes.qrUrl,
        builder: (context, state) => const QrUrlForm(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: AppRoutes.qrWifi,
        builder: (context, state) => const QrWifiForm(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: AppRoutes.qrContact,
        builder: (context, state) => const QrContactForm(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: AppRoutes.qrMyCard,
        builder: (context, state) => const QrContactForm(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: AppRoutes.qrPhone,
        builder: (context, state) => const QrPhoneForm(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: AppRoutes.qrEmail,
        builder: (context, state) => const QrEmailForm(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: AppRoutes.qrCalendar,
        builder: (context, state) => const QrCalendarForm(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: AppRoutes.qrWhatsapp,
        builder: (context, state) =>
            const QrSocialForm(kind: SocialQrKind.whatsapp),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: AppRoutes.qrYoutube,
        builder: (context, state) =>
            const QrSocialForm(kind: SocialQrKind.youtube),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: AppRoutes.qrFacebook,
        builder: (context, state) =>
            const QrSocialForm(kind: SocialQrKind.facebook),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: AppRoutes.qrInstagram,
        builder: (context, state) =>
            const QrSocialForm(kind: SocialQrKind.instagram),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: AppRoutes.barcode,
        builder: (context, state) => const BarcodeTypeScreen(),
        routes: [
          GoRoute(
            path: 'code128',
            builder: (context, state) => const BarcodeCode128Form(),
          ),
          GoRoute(
            path: 'ean8',
            builder: (context, state) => const BarcodeEan8Form(),
          ),
          GoRoute(
            path: 'ean13',
            builder: (context, state) => const BarcodeEan13Form(),
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: AppRoutes.preview,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is! GeneratedCode) {
            return const _MissingExtraScreen(kind: 'preview');
          }
          return PreviewScreen(code: extra);
        },
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: AppRoutes.result,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is! ScanResultData) {
            return const _MissingExtraScreen(kind: 'result');
          }
          return ResultScreen(data: extra);
        },
      ),
    ],
  );
});

class _MissingExtraScreen extends StatelessWidget {
  const _MissingExtraScreen({required this.kind});

  final String kind;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.commonError)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.errorGeneric),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.go(AppRoutes.create),
              child: Text(l10n.navCreate),
            ),
          ],
        ),
      ),
    );
  }
}
