class ScanDeduper {
  ScanDeduper({this.window = const Duration(milliseconds: 1500)});

  final Duration window;

  String? _lastRaw;
  DateTime? _lastAt;
  bool locked = false;

  bool accept(String raw, {DateTime? now}) {
    if (raw.isEmpty) return false;
    if (locked) return false;
    final ts = now ?? DateTime.now();
    if (_lastRaw == raw &&
        _lastAt != null &&
        ts.difference(_lastAt!) < window) {
      return false;
    }
    _lastRaw = raw;
    _lastAt = ts;
    return true;
  }

  void lock() => locked = true;

  void unlock() {
    locked = false;
    _lastRaw = null;
    _lastAt = null;
  }
}
