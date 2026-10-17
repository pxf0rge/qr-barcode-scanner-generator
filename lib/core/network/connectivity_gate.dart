import 'package:connectivity_plus/connectivity_plus.dart';

/// Thin connectivity helper for ads-only offline messaging.
class ConnectivityGate {
  ConnectivityGate({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  /// Returns true when the device appears to have no usable network.
  Future<bool> get isOffline async {
    final results = await _connectivity.checkConnectivity();
    if (results.isEmpty) return true;
    return results.every((r) => r == ConnectivityResult.none);
  }

  Future<bool> get isOnline async => !(await isOffline);
}
