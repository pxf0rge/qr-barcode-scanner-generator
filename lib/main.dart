import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:qr_barcode_app/app.dart';
import 'package:qr_barcode_app/core/widgets/main_shell.dart';
import 'package:qr_barcode_app/data/ads/ads_bootstrap.dart';
import 'package:qr_barcode_app/features/settings/presentation/theme_preference.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const QrBarcodeApp(),
    ),
  );

  // If welcome was already completed, warm ads AFTER the first UI frame —
  // never before runApp (that caused a black hang with UMP).
  if (!kIsWeb && (prefs.getBool(welcomeCompletedKey) ?? false)) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future<void>.delayed(const Duration(milliseconds: 800), () {
        unawaited(AdsBootstrap.run());
      });
    });
  }
}
