import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:qr_barcode_app/core/errors/failure_mapper.dart';
import 'package:qr_barcode_app/core/router/routes.dart';
import 'package:qr_barcode_app/core/theme/app_theme.dart';
import 'package:qr_barcode_app/core/widgets/app_scaffold.dart';
import 'package:qr_barcode_app/domain/entities/generated_code.dart';
import 'package:qr_barcode_app/domain/qr/qr_payload_builder.dart';
import 'package:qr_barcode_app/l10n/app_localizations.dart';

class QrTextForm extends StatefulWidget {
  const QrTextForm({super.key});

  @override
  State<QrTextForm> createState() => _QrTextFormState();
}

class _QrTextFormState extends State<QrTextForm> {
  final _controller = TextEditingController();
  final _builder = QrPayloadBuilder();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _generate() {
    final l10n = AppLocalizations.of(context);
    final result = _builder.fromText(_controller.text);
    result.when(
      ok: (payload) {
        setState(() => _error = null);
        context.push(
          AppRoutes.preview,
          extra: GeneratedCode.qr(
            type: payload.type,
            payload: payload.rawValue,
            title: l10n.qrTypeText,
          ),
        );
      },
      err: (failure) => setState(() => _error = mapFailure(l10n, failure)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppScaffold(
      title: Text(l10n.qrTypeText),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 6,
              decoration: InputDecoration(
                labelText: l10n.fieldText,
                errorText: _error,
              ),
              onChanged: (_) {
                if (_error != null) setState(() => _error = null);
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _generate,
                child: Text(l10n.actionGenerate),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
