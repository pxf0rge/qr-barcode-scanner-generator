import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:qr_barcode_app/core/errors/failure_mapper.dart';
import 'package:qr_barcode_app/core/router/routes.dart';
import 'package:qr_barcode_app/core/theme/app_theme.dart';
import 'package:qr_barcode_app/core/widgets/app_scaffold.dart';
import 'package:qr_barcode_app/domain/entities/generated_code.dart';
import 'package:qr_barcode_app/domain/validation/barcode_validator.dart';
import 'package:qr_barcode_app/l10n/app_localizations.dart';

class BarcodeEan8Form extends StatefulWidget {
  const BarcodeEan8Form({super.key});

  @override
  State<BarcodeEan8Form> createState() => _BarcodeEan8FormState();
}

class _BarcodeEan8FormState extends State<BarcodeEan8Form> {
  final _controller = TextEditingController();
  final _validator = BarcodeValidator();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _generate() {
    final l10n = AppLocalizations.of(context);
    final result = _validator.validateEan8(_controller.text);
    result.when(
      ok: (payload) {
        setState(() => _error = null);
        context.push(
          AppRoutes.preview,
          extra: GeneratedCode.barcode(
            symbology: payload.symbology,
            payload: payload.rawValue,
            title: l10n.barcodeTypeEan8,
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
      title: Text(l10n.barcodeTypeEan8),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: l10n.fieldBarcodeData,
                hintText: l10n.barcodeTypeEan8Desc,
                errorText: _error,
              ),
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
