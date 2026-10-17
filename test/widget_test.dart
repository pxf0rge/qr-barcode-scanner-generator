import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:qr_barcode_app/app.dart';
import 'package:qr_barcode_app/features/settings/presentation/theme_preference.dart';
import 'package:qr_barcode_app/l10n/app_localizations_en.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('app smoke test pumps welcome', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final l10n = AppLocalizationsEn();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const QrBarcodeApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(l10n.welcomeBrand), findsOneWidget);
    expect(find.text(l10n.welcomeStart), findsOneWidget);
  });
}
