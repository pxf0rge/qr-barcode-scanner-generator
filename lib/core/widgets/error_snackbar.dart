import 'package:flutter/material.dart';

import 'package:qr_barcode_app/core/errors/failure_mapper.dart';
import 'package:qr_barcode_app/domain/entities/app_failure.dart';
import 'package:qr_barcode_app/l10n/app_localizations.dart';

void showErrorSnackBar(BuildContext context, AppFailure failure) {
  final l10n = AppLocalizations.of(context);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(child: Text(mapFailure(l10n, failure))),
        ],
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

void showSuccessSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(child: Text(message)),
        ],
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
