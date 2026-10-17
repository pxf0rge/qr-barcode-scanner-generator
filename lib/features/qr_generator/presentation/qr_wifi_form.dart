import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:qr_barcode_app/core/errors/failure_mapper.dart';
import 'package:qr_barcode_app/core/router/routes.dart';
import 'package:qr_barcode_app/core/theme/app_theme.dart';
import 'package:qr_barcode_app/core/widgets/app_scaffold.dart';
import 'package:qr_barcode_app/domain/entities/generated_code.dart';
import 'package:qr_barcode_app/domain/entities/qr_models.dart';
import 'package:qr_barcode_app/domain/qr/qr_payload_builder.dart';
import 'package:qr_barcode_app/l10n/app_localizations.dart';

class QrWifiForm extends StatefulWidget {
  const QrWifiForm({super.key});

  @override
  State<QrWifiForm> createState() => _QrWifiFormState();
}

class _QrWifiFormState extends State<QrWifiForm> {
  final _ssid = TextEditingController();
  final _password = TextEditingController();
  final _builder = QrPayloadBuilder();
  WifiSecurity _security = WifiSecurity.wpa;
  bool _hidden = false;
  bool _obscure = true;
  String? _error;

  @override
  void dispose() {
    _ssid.dispose();
    _password.dispose();
    super.dispose();
  }

  void _generate() {
    final l10n = AppLocalizations.of(context);
    final result = _builder.fromWifi(
      WifiNetworkConfig(
        ssid: _ssid.text,
        security: _security,
        password: _password.text,
        hidden: _hidden,
      ),
    );
    result.when(
      ok: (payload) {
        setState(() => _error = null);
        context.push(
          AppRoutes.preview,
          extra: GeneratedCode.qr(
            type: payload.type,
            payload: payload.rawValue,
            title: l10n.qrTypeWifi,
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
      title: Text(l10n.qrTypeWifi),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          TextField(
            controller: _ssid,
            decoration: InputDecoration(
              labelText: l10n.fieldSsid,
              errorText: _error,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<WifiSecurity>(
            initialValue: _security,
            decoration: InputDecoration(labelText: l10n.fieldSecurity),
            items: [
              DropdownMenuItem(
                value: WifiSecurity.wpa,
                child: Text(l10n.securityWpa),
              ),
              DropdownMenuItem(
                value: WifiSecurity.wep,
                child: Text(l10n.securityWep),
              ),
              DropdownMenuItem(
                value: WifiSecurity.nopass,
                child: Text(l10n.securityNone),
              ),
            ],
            onChanged: (v) {
              if (v != null) setState(() => _security = v);
            },
          ),
          if (_security != WifiSecurity.nopass) ...[
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _password,
              obscureText: _obscure,
              decoration: InputDecoration(
                labelText: l10n.fieldPassword,
                suffixIcon: IconButton(
                  tooltip: l10n.fieldPassword,
                  onPressed: () => setState(() => _obscure = !_obscure),
                  icon: Icon(
                    _obscure ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
              ),
            ),
          ],
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.fieldHiddenNetwork),
            value: _hidden,
            onChanged: (v) => setState(() => _hidden = v),
          ),
          const SizedBox(height: AppSpacing.xl),
          FilledButton(
            onPressed: _generate,
            child: Text(l10n.actionGenerate),
          ),
        ],
      ),
    );
  }
}
