import 'package:flutter/material.dart';

import 'package:qr_barcode_app/core/theme/app_theme.dart';
import 'package:qr_barcode_app/l10n/app_localizations.dart';

Future<bool> showCameraAccessDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (context) => const CameraAccessDialog(),
  );
  return result ?? false;
}

class CameraAccessDialog extends StatelessWidget {
  const CameraAccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    return AlertDialog(
      icon: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.12),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.photo_camera_outlined,
          size: 32,
          color: AppColors.primary,
        ),
      ),
      title: Text(l10n.cameraAccessTitle),
      content: Text(
        l10n.cameraAccessBody,
        style: TextStyle(
          color: scheme.onSurfaceVariant,
          height: 1.4,
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.actionCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.cameraAccessGrant),
        ),
      ],
    );
  }
}
