/// Per-export reward unlock gate.
/// Unlock only after [grant] (reward callback). Load/show alone never unlocks.
class RewardGate {
  final Map<String, _Unlock> _unlocks = {};

  void grant(String exportId, {bool allowExportRetry = false}) {
    _unlocks[exportId] = _Unlock(
      granted: true,
      allowExportRetry: allowExportRetry,
    );
  }

  bool isUnlocked(String exportId) => _unlocks[exportId]?.granted == true;

  /// Returns true if unlock was present and consumed.
  bool consume(String exportId) {
    final unlock = _unlocks[exportId];
    if (unlock == null || !unlock.granted) return false;
    _unlocks.remove(exportId);
    return true;
  }

  /// Fairness: if export fails after reward, grant one retry without new ad.
  void grantExportRetry(String exportId) {
    _unlocks[exportId] = const _Unlock(granted: true, allowExportRetry: true);
  }

  void clear(String exportId) => _unlocks.remove(exportId);

  void clearAll() => _unlocks.clear();
}

class _Unlock {
  const _Unlock({required this.granted, this.allowExportRetry = false});
  final bool granted;
  final bool allowExportRetry;
}
