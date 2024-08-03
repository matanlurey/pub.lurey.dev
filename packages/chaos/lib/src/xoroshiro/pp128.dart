part of '../xoroshiro.dart';

/// A 32-bit [Xoshiro128++][] pseudorandom number generator (PRNG).
///
/// Xoshiro128++ is an all-purpose, high-quality PRNG that excels at generating
/// both 32-bit random integers and floating-point numbers. It offers excellent
/// statistical properties and a large state size (128 bits).
///
/// This is the recommended choice if you need a versatile generator for a
/// wide range of applications, including simulations, games, and scientific
/// computing.
///
/// [Xoshiro128++]: https://prng.di.unimi.it/xoshiro128plusplus.c
final class Xoshiro128PP extends Xoshiro128 {
  /// Creates a new instance of the [Xoshiro128P] generator with the given
  /// [seed].
  ///
  /// If no seed is provided, a random seed is generated.
  factory Xoshiro128PP([int? seed]) {
    if (seed == null) {
      return xoshiro128PP.fromRandom();
    }
    return xoshiro128PP.fromSeed32(seed);
  }

  /// Creates a new instance of the [Xoshiro128P] generator with the given
  /// [state].
  ///
  /// The [state] must be exactly 32x4 bytes long, and is typically obtained
  /// from another instance of the same generator using the [Xoshiro128.save].
  factory Xoshiro128PP.fromSeed(List<int> state) {
    return xoshiro128PP.fromSeed(state);
  }

  Xoshiro128PP._() : super._();

  @override
  Xoshiro128PP clone() {
    final clone = Xoshiro128PP._();
    clone.restore(save());
    return clone;
  }

  @override
  bool nextBool() => _finishUint32().nthBit(0);

  @override
  Uint32 _startUint32() {
    return Uint32(_state[0])
        .wrappedAdd(Uint32(_state[3]))
        .rotateLeft(7)
        .wrappedAdd(Uint32(_state[0]));
  }
}

final class _Xoshiro128PPGenerator extends _Xohsiro128Seed<Xoshiro128PP> {
  const _Xoshiro128PPGenerator();

  @override
  Xoshiro128PP _fromState(Uint32List state) {
    final generator = Xoshiro128PP._();
    generator.restore(state.buffer.asUint8List());
    return generator;
  }
}
