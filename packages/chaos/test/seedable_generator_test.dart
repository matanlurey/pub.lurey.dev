import 'dart:typed_data';

import 'package:binary/binary.dart';
import 'package:chaos/chaos.dart';

import 'src/prelude.dart';

void main() {
  test('implements fromSeed32', () {
    final generator = _TestSeedableRandom();
    final random = generator.fromSeed(Uint8List.fromList([0, 0, 0, 42]));
    check(random).has((a) => a.seed, 'seed').equals(42);
  });

  test(
    'implements fromRandom (Random.secure)',
    () {
      final generator = _TestSeedableRandom();
      check(generator.fromRandom).returnsNormally();
    },
    testOn: '!node',
  );

  test('implements fromRandom (provided)', () {
    final generator = _TestSeedableRandom();
    final random = _FakeRandom(42);
    final seeded = generator.fromRandom(random);
    check(seeded).isA<_FakeRandom>();
    check(seeded).has((a) => a.seed, 'seed').equals(707406378);
  });

  group('defaultRandom', () {
    test('fromSeed', () {
      final random = defaultRandom.fromSeed(Uint8List.fromList([0, 0, 0, 42]));
      check(random.nextInt(100)).equals(87);
    });

    test('fromSeed32', () {
      final random = defaultRandom.fromSeed32(42);
      check(random.nextInt(100)).equals(87);
    });

    test('fromRandom (default)', () {
      final seeded = defaultRandom.fromRandom();
      check(() => seeded.nextInt(100)).returnsNormally();
    });

    test('fromRandom (provided)', () {
      final random = _FakeRandom(42);
      final seeded = defaultRandom.fromRandom(random);
      check(seeded.nextInt(100)).equals(87);
    });
  });
}

final class _TestSeedableRandom with SeedableGenerator<_FakeRandom> {
  const _TestSeedableRandom();

  @override
  Uint8List defaultZeroSeed() => Uint8List(4);

  @override
  _FakeRandom fromSeed(List<int> seed) {
    var value = Uint32.zero;
    for (var i = 0; i < seed.length; i++) {
      value = (value << 8) | (Uint32(seed[i]) & Uint32.max);
    }
    return _FakeRandom(value);
  }
}

final class _FakeRandom implements Random {
  _FakeRandom(this.seed);
  final int seed;

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  int nextInt(int max) {
    return seed % max;
  }
}
