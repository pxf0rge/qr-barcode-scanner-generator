import 'package:flutter_contacts/flutter_contacts.dart';

import 'package:qr_barcode_app/domain/entities/app_failure.dart';
import 'package:qr_barcode_app/domain/entities/qr_models.dart';

/// Imports a device contact via the system picker into a [ContactCard].
class ContactImportService {
  static const _pickerProperties = {
    ContactProperty.name,
    ContactProperty.phone,
    ContactProperty.email,
    ContactProperty.address,
    ContactProperty.organization,
    ContactProperty.website,
  };

  /// Opens the native picker. On Android, requests read permission when needed
  /// so phone/email/address fields can be filled.
  Future<Result<ContactCard>> pickContact() async {
    try {
      final permission = await FlutterContacts.permissions.request(
        PermissionType.read,
      );
      if (permission == PermissionStatus.permanentlyDenied ||
          permission == PermissionStatus.restricted) {
        return const Err(
          AppFailure(AppFailureCode.contactsPermanentlyDenied),
        );
      }
      if (permission != PermissionStatus.granted &&
          permission != PermissionStatus.limited) {
        return const Err(AppFailure(AppFailureCode.contactsDenied));
      }

      final contact = await FlutterContacts.native.showPicker(
        properties: _pickerProperties,
      );
      if (contact == null) {
        return const Err(AppFailure(AppFailureCode.contactPickCancelled));
      }

      return Ok(_mapContact(contact));
    } catch (_) {
      return const Err(AppFailure(AppFailureCode.contactPickFailed));
    }
  }

  ContactCard _mapContact(Contact contact) {
    final name = contact.name;
    var first = name?.first?.trim() ?? '';
    var last = name?.last?.trim() ?? '';

    if (first.isEmpty && last.isEmpty) {
      final display = contact.displayName?.trim() ?? '';
      if (display.isNotEmpty) {
        final parts = display.split(RegExp(r'\s+'));
        first = parts.first;
        if (parts.length > 1) {
          last = parts.sublist(1).join(' ');
        }
      }
    }

    final phone = contact.phones.isNotEmpty ? contact.phones.first.number : '';
    final email = contact.emails.isNotEmpty ? contact.emails.first.address : '';
    final website =
        contact.websites.isNotEmpty ? contact.websites.first.url : '';
    final organization = contact.organizations.isNotEmpty
        ? (contact.organizations.first.name ?? '')
        : '';

    String address = '';
    if (contact.addresses.isNotEmpty) {
      final a = contact.addresses.first;
      address = (a.formatted?.trim().isNotEmpty == true)
          ? a.formatted!.trim()
          : [
              a.street,
              a.city,
              a.state,
              a.postalCode,
              a.country,
            ].whereType<String>().map((e) => e.trim()).where((e) => e.isNotEmpty).join(', ');
    }

    return ContactCard(
      firstName: first,
      lastName: last,
      phone: phone,
      email: email,
      organization: organization,
      address: address,
      website: website,
    );
  }
}
