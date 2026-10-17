import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:qr_barcode_app/data/permissions/permission_service.dart';
import 'package:qr_barcode_app/l10n/app_localizations.dart';

/// Shows a one-time rationale, then requests camera + contacts on first launch.
class StartupPermissionGate {
  static const _promptedKey = 'startup_permissions_prompted_v1';
  static bool _running = false;

  static Future<void> run({
    required BuildContext context,
    required SharedPreferences prefs,
  }) async {
    // Avoid blocking widget tests with system dialogs.
    if (const bool.fromEnvironment('FLUTTER_TEST')) return;

    if (_running) return;
    _running = true;
    try {
      final l10n = AppLocalizations.of(context);
      final service = PermissionService();

      final prompted = prefs.getBool(_promptedKey) ?? false;
      if (!prompted && context.mounted) {
        await showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text(l10n.startupPermissionsTitle),
              content: Text(l10n.startupPermissionsBody),
              actions: [
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.actionContinue),
                ),
              ],
            );
          },
        );
        await prefs.setBool(_promptedKey, true);
      }

      await service.requestStartupPermissions();
    } finally {
      _running = false;
    }
  }
}
