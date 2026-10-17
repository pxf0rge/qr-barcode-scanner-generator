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

class QrPhoneForm extends StatefulWidget {
  const QrPhoneForm({super.key});

  @override
  State<QrPhoneForm> createState() => _QrPhoneFormState();
}

class _QrPhoneFormState extends State<QrPhoneForm> {
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
    _builder.fromPhone(_controller.text).when(
      ok: (payload) {
        setState(() => _error = null);
        context.push(
          AppRoutes.preview,
          extra: GeneratedCode.qr(
            type: QrContentType.phone,
            payload: payload.rawValue,
            title: l10n.createTypeTelephone,
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
      title: Text(l10n.createTypeTelephone),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: l10n.fieldPhone,
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

class QrEmailForm extends StatefulWidget {
  const QrEmailForm({super.key});

  @override
  State<QrEmailForm> createState() => _QrEmailFormState();
}

class _QrEmailFormState extends State<QrEmailForm> {
  final _email = TextEditingController();
  final _subject = TextEditingController();
  final _body = TextEditingController();
  final _builder = QrPayloadBuilder();
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _subject.dispose();
    _body.dispose();
    super.dispose();
  }

  void _generate() {
    final l10n = AppLocalizations.of(context);
    _builder
        .fromEmail(
          email: _email.text,
          subject: _subject.text,
          body: _body.text,
        )
        .when(
      ok: (payload) {
        setState(() => _error = null);
        context.push(
          AppRoutes.preview,
          extra: GeneratedCode.qr(
            type: QrContentType.email,
            payload: payload.rawValue,
            title: l10n.createTypeEmail,
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
      title: Text(l10n.createTypeEmail),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: l10n.fieldEmail,
                errorText: _error,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _subject,
              decoration: InputDecoration(labelText: l10n.fieldEmailSubject),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _body,
              maxLines: 4,
              decoration: InputDecoration(labelText: l10n.fieldEmailBody),
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

class QrCalendarForm extends StatefulWidget {
  const QrCalendarForm({super.key});

  @override
  State<QrCalendarForm> createState() => _QrCalendarFormState();
}

class _QrCalendarFormState extends State<QrCalendarForm> {
  final _title = TextEditingController();
  final _location = TextEditingController();
  final _description = TextEditingController();
  final _builder = QrPayloadBuilder();
  DateTime? _start;
  DateTime? _end;
  String? _error;

  @override
  void dispose() {
    _title.dispose();
    _location.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _pickStart() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDate: _start ?? DateTime.now(),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_start ?? DateTime.now()),
    );
    if (time == null) return;
    setState(() {
      _start = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  void _generate() {
    final l10n = AppLocalizations.of(context);
    _builder
        .fromCalendar(
          title: _title.text,
          location: _location.text,
          description: _description.text,
          start: _start,
          end: _end ?? _start?.add(const Duration(hours: 1)),
        )
        .when(
      ok: (payload) {
        setState(() => _error = null);
        context.push(
          AppRoutes.preview,
          extra: GeneratedCode.qr(
            type: QrContentType.calendar,
            payload: payload.rawValue,
            title: l10n.createTypeCalendar,
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
      title: Text(l10n.createTypeCalendar),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            TextField(
              controller: _title,
              decoration: InputDecoration(
                labelText: l10n.fieldEventTitle,
                errorText: _error,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _location,
              decoration: InputDecoration(labelText: l10n.fieldEventLocation),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _description,
              maxLines: 3,
              decoration: InputDecoration(labelText: l10n.fieldEventDescription),
            ),
            const SizedBox(height: AppSpacing.md),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.fieldEventStart),
              subtitle: Text(
                _start?.toLocal().toString() ?? l10n.fieldEventPick,
              ),
              trailing: const Icon(Icons.event),
              onTap: _pickStart,
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
