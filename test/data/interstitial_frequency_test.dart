import 'package:flutter_test/flutter_test.dart';
import 'package:qr_barcode_app/data/ads/interstitial_ad_manager.dart';

void main() {
  test('interstitial only after every 4th action', () {
    final gate = InterstitialFrequencyGate(
      everyNActions: 4,
      cooldown: Duration.zero,
    );
    final t0 = DateTime(2026, 1, 1);

    expect(gate.recordAction(now: t0), isFalse); // 1
    expect(gate.recordAction(now: t0), isFalse); // 2
    expect(gate.recordAction(now: t0), isFalse); // 3
    expect(gate.recordAction(now: t0), isTrue); // 4
    gate.markShown(now: t0);

    expect(gate.recordAction(now: t0), isFalse); // 1
    expect(gate.recordAction(now: t0), isFalse); // 2
    expect(gate.recordAction(now: t0), isFalse); // 3
    expect(gate.recordAction(now: t0), isTrue); // 4
  });

  test('cooldown blocks even when action threshold met', () {
    final gate = InterstitialFrequencyGate(
      everyNActions: 4,
      cooldown: const Duration(seconds: 60),
    );
    final t0 = DateTime(2026, 1, 1, 12, 0, 0);
    for (var i = 0; i < 3; i++) {
      expect(gate.recordAction(now: t0), isFalse);
    }
    expect(gate.recordAction(now: t0), isTrue);
    gate.markShown(now: t0);

    for (var i = 0; i < 3; i++) {
      expect(gate.recordAction(now: t0.add(const Duration(seconds: 10))), isFalse);
    }
    // 4th after show, but still within cooldown
    expect(
      gate.recordAction(now: t0.add(const Duration(seconds: 30))),
      isFalse,
    );
    // After cooldown, pending threshold still allows show
    expect(
      gate.recordAction(now: t0.add(const Duration(seconds: 61))),
      isTrue,
    );
  });
}
