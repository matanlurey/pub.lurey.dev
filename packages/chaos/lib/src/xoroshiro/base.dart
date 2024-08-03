part of '../xoroshiro.dart';

/// The size of the seed for the [Xoshiro128] family of generators.
const _xoshiro128SeedSize = 128 ~/ 8;

/// Creates instances of the [Xoshiro128P] random number generator.
const SeedableGenerator<Xoshiro128P> xoshiro128P = _Xoshiro128PGenerator();

/// Creates instances of the [Xoshiro128PP] random number generator.
const SeedableGenerator<Xoshiro128PP> xoshiro128PP = _Xoshiro128PPGenerator();

/// A base class for the [Xoshiro128] family of random number generators.
///
/// [xoshiro]: https://prng.di.unimi.it/
///
/// Xoshiro is a family of PRNGs that are fast, have a small state, and pass
/// statistical tests. They are not cryptographically secure, but are suitable
/// for most other purposes such as simple simulations, games, and benchmarks.
abstract final class Xoshiro128 implements PersistentRandom {
  Xoshiro128._();

  /// State of a [Xoshiro128] generator, which is exactly 3x32 bits long.
  final _state = Uint32List(4);

  @override
  Uint8List save() => _state.buffer.asUint8List().sublist(0);

  @override
  void restore(Uint8List state) {
    if (state.length != _xoshiro128SeedSize) {
      throw ArgumentError.value(
        state,
        'state',
        'Must be exactly $_xoshiro128SeedSize 8-bit bytes, got ${state.length}',
      );
    }
    _state.setAll(0, state.buffer.asUint32List());
  }

  Uint32 _startUint32();
  Uint32 _finishUint32() {
    final r = _startUint32();
    final t = _state[1] << 9;

    _state[2] ^= _state[0];
    _state[3] ^= _state[1];
    _state[1] ^= _state[2];
    _state[0] ^= _state[3];

    _state[2] ^= t;

    _state[3] = Uint32(_state[3]).rotateLeft(11);

    return r;
  }

  @override
  int nextInt([int max = Uint32.max]) {
    final i = _finishUint32();
    return i != Uint32.max ? i % Uint32.checkRange(max) : i;
  }

  static final _doubleNormalizer = 1.0 / (Uint32.one << 21);

  @override
  double nextDouble() {
    final i = _finishUint32();
    return _doubleNormalizer * (i >>> 11);
  }

  void _applyJump(List<int> values) {
    final s = Uint32List(4);
    for (final j in values) {
      for (var b = 0; b < 32; b++) {
        if ((j & (1 << b)) != 0) {
          s[0] ^= _state[0];
          s[1] ^= _state[1];
          s[2] ^= _state[2];
          s[3] ^= _state[3];
        }
        _finishUint32();
      }
    }
    _state.setAll(0, s);
  }

  /// Simulates 2^64 calls to [nextDouble] in constant time.
  void jump() {
    return _applyJump(const [0x8764000b, 0xf542d2d3, 0x6fa035c3, 0x77f2db5b]);
  }

  /// Simulates 2^96 calls to [nextDouble] in constant time.
  void longJump() {
    return _applyJump(const [0xb523952e, 0x0b6f099f, 0xccf5a0ef, 0x1c580662]);
  }
}
