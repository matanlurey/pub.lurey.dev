import 'package:sdk/sdk.dart';

import '_prelude.dart';

void main() {
  test('x64', () {
    check(Architecture.x64)
      ..has((a) => a.isSupported, 'isSupported').isTrue()
      ..has((a) => a.name, 'name').equals('x64')
      ..has((a) => a.toString(), 'toString').equals('Architecture.x64');
  });

  test('arm64', () {
    check(Architecture.arm64)
      ..has((a) => a.isSupported, 'isSupported').isTrue()
      ..has((a) => a.name, 'name').equals('arm64')
      ..has((a) => a.toString(), 'toString').equals('Architecture.arm64');
  });

  test('armv8', () {
    check(Architecture.armv8)
      ..has((a) => a.isSupported, 'isSupported').isTrue()
      ..has((a) => a.name, 'name').equals('armv8')
      ..has((a) => a.toString(), 'toString').equals('Architecture.armv8');
  });

  test('armv7', () {
    check(Architecture.armv7)
      ..has((a) => a.isSupported, 'isSupported').isTrue()
      ..has((a) => a.name, 'name').equals('armv7')
      ..has((a) => a.toString(), 'toString').equals('Architecture.armv7');
  });

  test('ia32', () {
    check(Architecture.ia32)
      ..has((a) => a.isSupported, 'isSupported').isTrue()
      ..has((a) => a.name, 'name').equals('ia32')
      ..has((a) => a.toString(), 'toString').equals('Architecture.ia32');
  });

  test('riscv', () {
    check(Architecture.riscv)
      ..has((a) => a.isSupported, 'isSupported').isTrue()
      ..has((a) => a.name, 'name').equals('riscv')
      ..has((a) => a.toString(), 'toString').equals('Architecture.riscv');
  });

  test('unsupported', () {
    check(Architecture.unsupported('foo'))
      ..has((a) => a.isSupported, 'isSupported').isFalse()
      ..has((a) => a.name, 'name').equals('foo')
      ..has(
        (a) => a.toString(),
        'toString',
      ).equals('Architecture.unsupported(foo)');
  });

  test('== and hashCode', () {
    check(Architecture.x64)
      ..has((a) => a == Architecture.x64, '==').isTrue()
      ..has((a) => a.hashCode, 'hashCode').equals(Architecture.x64.hashCode);
  });

  test('tryFrom (success)', () {
    check(
      Architecture.tryFrom('x64'),
    ).has((a) => a, 'tryFrom').equals(Architecture.x64);
  });

  test('tryFrom (failure)', () {
    check(Architecture.tryFrom('foo')).isNull();
  });

  test('from (success)', () {
    check(
      Architecture.from('x64'),
    ).has((a) => a, 'from').equals(Architecture.x64);
  });

  test('from (failure)', () {
    check(() => Architecture.from('foo')).throws<ArgumentError>();
  });
}
