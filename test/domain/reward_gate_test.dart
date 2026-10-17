import 'package:flutter_test/flutter_test.dart';
import 'package:qr_barcode_app/domain/ads/reward_gate.dart';

void main() {
  late RewardGate gate;

  setUp(() => gate = RewardGate());

  test('locked until grant', () {
    expect(gate.isUnlocked('a'), isFalse);
    gate.grant('a');
    expect(gate.isUnlocked('a'), isTrue);
  });

  test('consume is single-use', () {
    gate.grant('a');
    expect(gate.consume('a'), isTrue);
    expect(gate.isUnlocked('a'), isFalse);
    expect(gate.consume('a'), isFalse);
  });

  test('grant without consume stays until clear', () {
    gate.grant('b');
    gate.clear('b');
    expect(gate.isUnlocked('b'), isFalse);
  });

  test('export retry re-grants unlock', () {
    gate.grant('c');
    expect(gate.consume('c'), isTrue);
    gate.grantExportRetry('c');
    expect(gate.isUnlocked('c'), isTrue);
    expect(gate.consume('c'), isTrue);
  });

  test('clearAll removes everything', () {
    gate.grant('x');
    gate.grant('y');
    gate.clearAll();
    expect(gate.isUnlocked('x'), isFalse);
    expect(gate.isUnlocked('y'), isFalse);
  });
}
