import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:qr_barcode_app/core/router/routes.dart';
import 'package:qr_barcode_app/core/theme/app_theme.dart';
import 'package:qr_barcode_app/features/create/presentation/create_screen.dart';
import 'package:qr_barcode_app/features/qr_generator/presentation/qr_url_form.dart';
import 'package:qr_barcode_app/l10n/app_localizations.dart';
import 'package:qr_barcode_app/l10n/app_localizations_en.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('create screen survives 1.5x text scale without overflow',
      (tester) async {
    final l10n = AppLocalizationsEn();

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(1.5)),
        child: MaterialApp(
          theme: AppTheme.light(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const CreateScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(l10n.createTypeLink), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('navigates to URL form from create', (tester) async {
    final l10n = AppLocalizationsEn();
    final router = GoRouter(
      initialLocation: AppRoutes.create,
      routes: [
        GoRoute(
          path: AppRoutes.create,
          builder: (context, state) => const CreateScreen(),
        ),
        GoRoute(
          path: AppRoutes.qrUrl,
          builder: (context, state) => const QrUrlForm(),
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(
        theme: AppTheme.light(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text(l10n.createTypeLink));
    await tester.pumpAndSettle();

    expect(find.text(l10n.fieldUrl), findsWidgets);
    expect(find.text(l10n.actionGenerate), findsOneWidget);
  });
}
