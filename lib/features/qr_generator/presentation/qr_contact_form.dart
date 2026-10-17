import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:qr_barcode_app/core/errors/async_guard.dart';
import 'package:qr_barcode_app/core/errors/failure_mapper.dart';
import 'package:qr_barcode_app/core/router/routes.dart';
import 'package:qr_barcode_app/core/theme/app_theme.dart';
import 'package:qr_barcode_app/core/widgets/app_scaffold.dart';
import 'package:qr_barcode_app/data/contacts/contact_import_service.dart';
import 'package:qr_barcode_app/data/permissions/permission_service.dart';
import 'package:qr_barcode_app/domain/entities/app_failure.dart';
import 'package:qr_barcode_app/domain/entities/generated_code.dart';
import 'package:qr_barcode_app/domain/entities/qr_models.dart';
import 'package:qr_barcode_app/domain/qr/qr_payload_builder.dart';
import 'package:qr_barcode_app/l10n/app_localizations.dart';

class QrContactForm extends StatefulWidget {
  const QrContactForm({super.key});

  @override
  State<QrContactForm> createState() => _QrContactFormState();
}

class _QrContactFormState extends State<QrContactForm> {
  final _first = TextEditingController();
  final _last = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _org = TextEditingController();
  final _address = TextEditingController();
  final _website = TextEditingController();
  final _builder = QrPayloadBuilder();
  final _importer = ContactImportService();
  final _permissions = PermissionService();

  String? _error;
  bool _picking = false;
  bool _imported = false;

  @override
  void dispose() {
    _first.dispose();
    _last.dispose();
    _phone.dispose();
    _email.dispose();
    _org.dispose();
    _address.dispose();
    _website.dispose();
    super.dispose();
  }

  Future<void> _pickFromContacts() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _picking = true;
      _error = null;
    });

    final result = await _importer.pickContact();
    if (!mounted) return;

    setState(() => _picking = false);

    await result.when(
      ok: (card) async {
        setState(() {
          _first.text = card.firstName;
          _last.text = card.lastName;
          _phone.text = card.phone;
          _email.text = card.email;
          _org.text = card.organization;
          _address.text = card.address;
          _website.text = card.website;
          _imported = true;
          _error = null;
        });
        showSuccessSnackBar(context, l10n.contactImportedHint);
      },
      err: (failure) async {
        if (failure.code == AppFailureCode.contactPickCancelled) {
          return;
        }
        setState(() => _error = mapFailure(l10n, failure));
        if (failure.code == AppFailureCode.contactsPermanentlyDenied) {
          final open = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(l10n.actionPickContact),
              content: Text(l10n.errorContactsDenied),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(l10n.actionCancel),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(l10n.actionOpenSettings),
                ),
              ],
            ),
          );
          if (open == true) {
            await _permissions.openAppSettingsPage();
          }
        } else {
          showErrorSnackBar(context, failure);
        }
      },
    );
  }

  void _generate() {
    final l10n = AppLocalizations.of(context);
    final result = _builder.fromContact(
      ContactCard(
        firstName: _first.text,
        lastName: _last.text,
        phone: _phone.text,
        email: _email.text,
        organization: _org.text,
        address: _address.text,
        website: _website.text,
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
            title: l10n.qrTypeContact,
          ),
        );
      },
      err: (failure) => setState(() => _error = mapFailure(l10n, failure)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    return AppScaffold(
      title: Text(l10n.qrTypeContact),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          OutlinedButton.icon(
            onPressed: _picking ? null : _pickFromContacts,
            icon: _picking
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.contacts_rounded),
            label: Text(l10n.actionPickContact),
          ),
          if (_imported) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.contactImportedHint,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.primary,
                  ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: scheme.error, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      _error!,
                      style: TextStyle(color: scheme.error),
                    ),
                  ),
                ],
              ),
            ),
          TextField(
            controller: _first,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(labelText: l10n.fieldFirstName),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _last,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(labelText: l10n.fieldLastName),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _phone,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(labelText: l10n.fieldPhone),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(labelText: l10n.fieldEmail),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _org,
            decoration: InputDecoration(labelText: l10n.fieldOrganization),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _address,
            decoration: InputDecoration(labelText: l10n.fieldAddress),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _website,
            keyboardType: TextInputType.url,
            decoration: InputDecoration(labelText: l10n.fieldWebsite),
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
