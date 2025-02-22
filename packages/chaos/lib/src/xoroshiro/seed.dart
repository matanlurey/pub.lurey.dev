part of '../xoroshiro.dart';

abstract class _Xohsiro128Seed<T extends Xoshiro128> with SeedableGenerator<T> {
  static final _defaultBadSeed =
      Uint32List(4)
        ..[0] = 0xBAD5EED
        ..[1] = 0xBAD5EED
        ..[2] = 0xBAD5EED
        ..[3] = 0xBAD5EED;

  const _Xohsiro128Seed();

  @override
  Uint8List defaultZeroSeed() => Uint8List(_xoshiro128SeedSize);

  T _fromState(Uint32List state);

  @override
  T fromSeed(List<int> seed) {
    Uint32List seed32;
    seed32 = switch (seed) {
      final Uint32List _ => seed,
      final TypedData b => b.buffer.asUint32List(),
      final List<int> l => Uint32List.fromList(l),
    };
    if (seed32.every((element) => element == 0)) {
      seed32 = _defaultBadSeed;
    }
    return _fromState(seed32);
  }

  @override
  T fromSeed32(int value) {
    if (value == 0) {
      return _fromState(_defaultBadSeed);
    }
    final seed = defaultZeroSeed().buffer.asUint32List();
    seed
      ..[0] = value
      ..[1] = seed[0] ^ 0x1825a9e7
      ..[2] = seed[1] + seed[0]
      ..[3] = seed[2] * seed[1];
    return _fromState(seed);
  }
}
