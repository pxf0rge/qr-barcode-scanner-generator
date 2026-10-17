import 'package:flutter/material.dart';

import 'package:qr_barcode_app/core/widgets/error_snackbar.dart';
import 'package:qr_barcode_app/domain/entities/app_failure.dart';

export 'package:qr_barcode_app/core/widgets/error_snackbar.dart';

/// Runs an async action, maps unexpected errors to [AppFailure], and optionally
/// shows a SnackBar. Expected domain failures should be returned by callers,
/// not thrown.
Future<T?> runGuarded<T>({
  required BuildContext context,
  required Future<T> Function() action,
  void Function(AppFailure failure)? onFailure,
  bool showSnackBar = true,
}) async {
  try {
    return await action();
  } catch (error, stack) {
    debugPrint('runGuarded caught: $error\n$stack');
    const failure = AppFailure(AppFailureCode.generic);
    if (context.mounted && showSnackBar) {
      showErrorSnackBar(context, failure);
    }
    onFailure?.call(failure);
    return null;
  }
}
