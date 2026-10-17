import 'package:permission_handler/permission_handler.dart';

import 'package:qr_barcode_app/domain/entities/app_failure.dart';

enum AppPermissionState {
  granted,
  denied,
  permanentlyDenied,
  restricted,
}

/// Alias kept for existing scanner call sites.
typedef CameraPermissionState = AppPermissionState;

class PermissionService {
  Future<AppPermissionState> cameraStatus() async {
    return _map(await Permission.camera.status);
  }

  Future<AppPermissionState> requestCamera() async {
    return _map(await Permission.camera.request());
  }

  Future<AppPermissionState> contactsStatus() async {
    return _map(await Permission.contacts.status);
  }

  Future<AppPermissionState> requestContacts() async {
    return _map(await Permission.contacts.request());
  }

  /// Requests camera + contacts at app start when not already decided.
  /// Skips permanently denied / restricted to avoid useless system prompts.
  Future<void> requestStartupPermissions() async {
    final camera = await Permission.camera.status;
    if (_shouldRequest(camera)) {
      await Permission.camera.request();
    }

    final contacts = await Permission.contacts.status;
    if (_shouldRequest(contacts)) {
      await Permission.contacts.request();
    }
  }

  bool _shouldRequest(PermissionStatus status) {
    if (status.isGranted || status.isLimited) return false;
    if (status.isPermanentlyDenied || status.isRestricted) return false;
    return true;
  }

  Future<bool> openAppSettingsPage() => openAppSettings();

  AppFailure? failureFor(AppPermissionState state) {
    return switch (state) {
      AppPermissionState.granted => null,
      AppPermissionState.permanentlyDenied ||
      AppPermissionState.restricted =>
        const AppFailure(AppFailureCode.cameraPermanentlyDenied),
      AppPermissionState.denied =>
        const AppFailure(AppFailureCode.cameraDenied),
    };
  }

  AppPermissionState _map(PermissionStatus status) {
    if (status.isGranted || status.isLimited) {
      return AppPermissionState.granted;
    }
    if (status.isPermanentlyDenied || status.isRestricted) {
      return AppPermissionState.permanentlyDenied;
    }
    return AppPermissionState.denied;
  }
}
