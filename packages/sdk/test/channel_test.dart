import 'package:sdk/sdk.dart';

import '_prelude.dart';

void main() {
  test('stable', () {
    check(Channel.stable)
      ..has((c) => c.name, 'name').equals('stable')
      ..has((c) => c.isSupported, 'isSupported').isTrue()
      ..has((c) => c.isStable, 'isStable').isTrue()
      ..has((c) => c.toString(), 'toString').equals('Channel.stable');
  });

  test('beta', () {
    check(Channel.beta)
      ..has((c) => c.name, 'name').equals('beta')
      ..has((c) => c.isSupported, 'isSupported').isTrue()
      ..has((c) => c.isStable, 'isStable').isFalse()
      ..has((c) => c.toString(), 'toString').equals('Channel.beta');
  });

  test('dev', () {
    check(Channel.dev)
      ..has((c) => c.name, 'name').equals('dev')
      ..has((c) => c.isSupported, 'isSupported').isTrue()
      ..has((c) => c.isStable, 'isStable').isFalse()
      ..has((c) => c.toString(), 'toString').equals('Channel.dev');
  });

  test('main', () {
    check(Channel.main)
      ..has((c) => c.name, 'name').equals('main')
      ..has((c) => c.isSupported, 'isSupported').isTrue()
      ..has((c) => c.isStable, 'isStable').isFalse()
      ..has((c) => c.toString(), 'toString').equals('Channel.main');
  });

  test('unsupported', () {
    check(Channel.unsupported('foo'))
      ..has((c) => c.name, 'name').equals('foo')
      ..has((c) => c.isSupported, 'isSupported').isFalse()
      ..has((c) => c.isStable, 'isStable').isFalse()
      ..has((c) => c.toString(), 'toString').equals('Channel.unsupported(foo)');
  });

  test('tryFrom (success)', () {
    check(Channel.tryFrom('stable')).equals(Channel.stable);
    check(Channel.tryFrom('beta')).equals(Channel.beta);
    check(Channel.tryFrom('dev')).equals(Channel.dev);
    check(Channel.tryFrom('main')).equals(Channel.main);
  });

  test('tryFrom (failure)', () {
    check(Channel.tryFrom('foo')).isNull();
  });

  test('from (success)', () {
    check(Channel.from('stable')).equals(Channel.stable);
    check(Channel.from('beta')).equals(Channel.beta);
    check(Channel.from('dev')).equals(Channel.dev);
    check(Channel.from('main')).equals(Channel.main);
  });

  test('from (failure)', () {
    check(() => Channel.from('foo')).throws<ArgumentError>();
  });

  test('== and hashCode', () {
    check(Channel.stable)
      ..has((c) => c == Channel.stable, '==').isTrue()
      ..has((c) => c.hashCode, 'hashCode').equals(Channel.stable.hashCode);
  });
}
