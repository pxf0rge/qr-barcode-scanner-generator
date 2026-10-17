import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:qr_barcode_app/core/errors/failure_mapper.dart';
import 'package:qr_barcode_app/core/router/routes.dart';
import 'package:qr_barcode_app/core/theme/app_theme.dart';
import 'package:qr_barcode_app/core/widgets/app_scaffold.dart';
import 'package:qr_barcode_app/domain/entities/generated_code.dart';
import 'package:qr_barcode_app/domain/entities/qr_models.dart';
import 'package:qr_barcode_app/domain/geo/country_dial_codes.dart';
import 'package:qr_barcode_app/domain/qr/qr_payload_builder.dart';
import 'package:qr_barcode_app/domain/qr/social_qr_encoder.dart';
import 'package:qr_barcode_app/l10n/app_localizations.dart';

class QrSocialForm extends StatefulWidget {
  const QrSocialForm({super.key, required this.kind});

  final SocialQrKind kind;

  @override
  State<QrSocialForm> createState() => _QrSocialFormState();
}

class _QrSocialFormState extends State<QrSocialForm> {
  final _primary = TextEditingController();
  final _secondary = TextEditingController();
  final _builder = QrPayloadBuilder();
  String? _error;
  CountryDialCode _country = countryDialByIso('US');

  @override
  void dispose() {
    _primary.dispose();
    _secondary.dispose();
    super.dispose();
  }

  String _title(AppLocalizations l10n) => switch (widget.kind) {
        SocialQrKind.whatsapp => l10n.qrTypeWhatsapp,
        SocialQrKind.youtube => l10n.createTypeYoutube,
        SocialQrKind.facebook => l10n.createTypeFacebook,
        SocialQrKind.instagram => l10n.qrTypeInstagram,
      };

  QrContentType get _type => switch (widget.kind) {
        SocialQrKind.whatsapp => QrContentType.whatsapp,
        SocialQrKind.youtube => QrContentType.youtube,
        SocialQrKind.facebook => QrContentType.facebook,
        SocialQrKind.instagram => QrContentType.instagram,
      };

  String get _whatsappPhone {
    final local = _primary.text.replaceAll(RegExp(r'[^\d]'), '');
    // Drop a single leading trunk 0 common in local numbers.
    final normalized =
        local.startsWith('0') && local.length > 1 ? local.substring(1) : local;
    return '${_country.dialCode}$normalized';
  }

  void _generate() {
    final l10n = AppLocalizations.of(context);
    final result = switch (widget.kind) {
      SocialQrKind.whatsapp => _builder.fromWhatsapp(
          phone: _whatsappPhone,
          message: _secondary.text,
        ),
      SocialQrKind.youtube => _builder.fromYoutube(_primary.text),
      SocialQrKind.facebook => _builder.fromFacebook(_primary.text),
      SocialQrKind.instagram => _builder.fromInstagram(_primary.text),
    };

    result.when(
      ok: (payload) {
        setState(() => _error = null);
        context.push(
          AppRoutes.preview,
          extra: GeneratedCode.qr(
            type: _type,
            payload: payload.rawValue,
            title: _title(l10n),
          ),
        );
      },
      err: (failure) => setState(() => _error = mapFailure(l10n, failure)),
    );
  }

  Future<void> _pickCountry() async {
    final selected = await showModalBottomSheet<CountryDialCode>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (context, controller) {
            return ListView.builder(
              controller: controller,
              itemCount: kCountryDialCodes.length,
              itemBuilder: (context, index) {
                final country = kCountryDialCodes[index];
                final selectedIso = country.iso2 == _country.iso2;
                return ListTile(
                  leading: Text(
                    country.flagEmoji,
                    style: const TextStyle(fontSize: 28),
                  ),
                  title: Text(country.name),
                  subtitle: Text('+${country.dialCode}'),
                  trailing: selectedIso
                      ? Icon(
                          Icons.check_circle,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : null,
                  onTap: () => Navigator.pop(context, country),
                );
              },
            );
          },
        );
      },
    );
    if (selected != null) {
      setState(() => _country = selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isWhatsapp = widget.kind == SocialQrKind.whatsapp;

    final label = switch (widget.kind) {
      SocialQrKind.whatsapp => l10n.fieldWhatsappPhone,
      SocialQrKind.youtube => l10n.fieldYoutube,
      SocialQrKind.facebook => l10n.fieldFacebook,
      SocialQrKind.instagram => l10n.fieldInstagram,
    };
    final hint = switch (widget.kind) {
      SocialQrKind.whatsapp => l10n.hintWhatsappPhone,
      SocialQrKind.youtube => l10n.hintYoutube,
      SocialQrKind.facebook => l10n.hintFacebook,
      SocialQrKind.instagram => l10n.hintInstagram,
    };

    return AppScaffold(
      title: Text(_title(l10n)),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            TextField(
              controller: _primary,
              keyboardType:
                  isWhatsapp ? TextInputType.phone : TextInputType.text,
              decoration: InputDecoration(
                labelText: label,
                hintText: hint,
                errorText: _error,
                prefixIcon: isWhatsapp
                    ? _CountryCodePrefix(
                        country: _country,
                        onTap: _pickCountry,
                      )
                    : null,
                prefixIconConstraints: isWhatsapp
                    ? const BoxConstraints(minWidth: 0, minHeight: 0)
                    : null,
              ),
              onChanged: (_) {
                if (_error != null) setState(() => _error = null);
              },
            ),
            if (isWhatsapp) ...[
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _secondary,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: l10n.fieldWhatsappMessage,
                ),
              ),
            ],
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

/// Compact country + dial code control inside the phone TextField.
class _CountryCodePrefix extends StatelessWidget {
  const _CountryCodePrefix({
    required this.country,
    required this.onTap,
  });

  final CountryDialCode country;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: Padding(
        padding: const EdgeInsets.only(left: 12, right: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(country.flagEmoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 6),
            Text(
              '+${country.dialCode}',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            Container(
              width: 1,
              height: 24,
              margin: const EdgeInsets.only(left: 4, right: 8),
              color: theme.colorScheme.outlineVariant,
            ),
          ],
        ),
      ),
    );
  }
}
