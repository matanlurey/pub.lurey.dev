part of '../xoroshiro.dart';

/// A 32-bit [Xoshiro128+][] pseudorandom number generator (PRNG).
///
/// Xoshiro128+ is a fast and high-quality PRNG known for its speed and
/// statistical properties. It excels at generating 32-bit integers and
/// single-precision floating-point numbers.
///
/// While suitable for most applications, it's worth noting that its lowest
/// four bits exhibit low linear complexity. For applications that prioritize
/// the highest quality randomness for 32-bit integers, consider using
/// [Xoshiro128PP] instead.
///
/// [Xoshiro128+]: https://prng.di.unimi.it/xoshiro128plus.c
final class Xoshiro128P extends Xoshiro128 {
  /// Creates a new instance of the [Xoshiro128P] generator with the given
  /// [seed].
  ///
  /// If no seed is provided, a random seed is generated.
  factory Xoshiro128P([int? seed]) {
    seed ??= Xoshiro128.randomSeed();
    return xoshiro128P.fromSeed32(seed);
  }

  /// Creates a new instance of the [Xoshiro128P] generator with the given
  /// [state].
  ///
  /// The [state] must be exactly 32x8 bytes long, and is typically obtained
  /// from another instance of the same generator using the [Xoshiro128.save].
  factory Xoshiro128P.fromSeed(List<int> state) {
    return xoshiro128P.fromSeed(state);
  }

  Xoshiro128P._() : super._();

  @override
  Xoshiro128P clone() {
    final clone = Xoshiro128P._();
    clone.restore(save());
    return clone;
  }

  @override
  bool nextBool() => _finishUint32().msb;

  @override
  Uint32 _startUint32() => Uint32(_state[0]).wrappedAdd(Uint32(_state[3]));
}

final class _Xoshiro128PGenerator extends _Xohsiro128Seed<Xoshiro128P> {
  const _Xoshiro128PGenerator();

  @override
  Xoshiro128P _fromState(Uint32List state) {
    final generator = Xoshiro128P._();
    generator.restore(state.buffer.asUint8List());
    return generator;
  }
}
