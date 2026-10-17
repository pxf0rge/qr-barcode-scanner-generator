import 'package:flutter_test/flutter_test.dart';
import 'package:qr_barcode_app/data/scanner/scan_deduper.dart';

void main() {
  test('accepts first scan', () {
    final deduper = ScanDeduper(window: const Duration(seconds: 1));
    expect(deduper.accept('abc', now: DateTime(2024)), isTrue);
  });

  test('rejects duplicate within window', () {
    final deduper = ScanDeduper(window: const Duration(milliseconds: 500));
    final t0 = DateTime(2024, 1, 1, 12);
    expect(deduper.accept('abc', now: t0), isTrue);
    expect(
      deduper.accept('abc', now: t0.add(const Duration(milliseconds: 100))),
      isFalse,
    );
  });

  test('accepts same value after window', () {
    final deduper = ScanDeduper(window: const Duration(milliseconds: 200));
    final t0 = DateTime(2024, 1, 1, 12);
    expect(deduper.accept('abc', now: t0), isTrue);
    expect(
      deduper.accept('abc', now: t0.add(const Duration(milliseconds: 250))),
      isTrue,
    );
  });

  test('lock blocks all until unlock', () {
    final deduper = ScanDeduper();
    expect(deduper.accept('one'), isTrue);
    deduper.lock();
    expect(deduper.accept('two'), isFalse);
    deduper.unlock();
    expect(deduper.accept('two'), isTrue);
  });

  test('rejects empty', () {
    final deduper = ScanDeduper();
    expect(deduper.accept(''), isFalse);
  });
}
