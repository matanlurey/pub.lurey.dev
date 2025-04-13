/// @docImport 'xoroshiro.dart';
library;

import 'dart:math' show Random;
import 'dart:typed_data';

import 'package:binary/binary.dart' show Uint8;
import 'package:meta/meta.dart';

/// A default instance of [SeedableGenerator] that uses [Random] as the PRNG.
///
/// This is the default instance used by the library, and is suitable for most
/// use-cases, in particular when the state of the PRNG does not need to be
/// preserved or persisted. It is not cryptographically secure, and should not
/// be used for cryptographic purposes.
///
/// ## Example
///
/// ```dart
/// // Equivalent to Random(42), but with a consistent factory API.
/// final random = defaultRandom.fromSeed32(42);
/// ```
const SeedableGenerator<Random> systemRandom = _SystemSeedableRandom();

/// A default instance of [SeedableGenerator] that uses [Random] as the PRNG.
@Deprecated('Use systemRandom instead')
const SeedableGenerator<Random> defaultRandom = systemRandom;

/// A factory class that creates [Random] instances of [T] that can be seeded.
///
/// Ecapsulates the low-level functionality common to all pseudo-random number
/// generators (PRNGs, or algorithmic generators), and provides a consistent
/// API, making it possible to swap out PRNGs without changing the rest of your
/// code.
///
/// ## Implementing
///
/// To implement a new PRNG, create a new class that implements
/// [SeedableGenerator]. The class should typically be immutable:
///
/// ```dart
/// class MyPRNG implements SeedableGenerator<Random> { /* ... */ }
/// ```
///
/// To reduce how much code you need to write, consider mixing in the
/// [SeedableGenerator] instead:
///
/// ```dart
/// class MyPRNG with SeedableGenerator<Random> {
///   @override
///   Uint8List defaultZeroSeed() => Uint8List(16);
///
///   @override
///   Random fromSeed(List<int> seed) {
///     // ...
///   }
/// }
/// ```
///
/// ## Example
///
/// Imagine you start with a simple use of [Random]:
///
/// ```dart
/// final random = Random();
/// print(random.nextInt(100));
/// ```
///
/// Later on, you want to create a Random from a specific seed:
///
/// ```dart
/// final random = Random(42);
/// print(random.nextInt(100));
/// ```
///
/// But then you realize the default [Random] class doesn't have a way to
/// inspect or clone the state of the PRNG, so you switch to [Xoshiro128P]:
///
/// ```dart
/// final random = Xoshiro128P(42);
/// print(random.nextInt(100));
/// ```
///
/// A _seedable generator_ is a swappable factory that can create PRNGs with
/// a consistent API, and can be used to create PRNGs from seeds, integers, or
/// other PRNGs.
///
/// Let's rewrite the above example using a seedable generator:
///
/// ```dart
/// import 'package:chaos/chaos.dart';
///
/// void example(SeedableGenerator<Random> generator) {
///   final random = generator.fromSeed32(42);
///   print(random.nextInt(100));
/// }
///
/// example(defaultRandom);
/// example(xoshiro128P);
/// ```
@immutable
abstract mixin class SeedableGenerator<T extends Random> {
  /// Returns a default seed for the PRNG, typically `0` with an appropriate
  /// `length`.
  @protected
  Uint8List defaultZeroSeed();

  /// Creates a new PRNG using the given [seed].
  ///
  /// PRNG implementations are allowed to assume that bits in the seed are well
  /// distributed: the number of one and zero bits are roughly equal, and values
  /// like `0, `1` and (`size - 1`) are unlikely. Many non-cryptographic PRNGs
  /// show poor quality output if not seeded properly.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final random = defaultRandom.fromSeed([0x42, 0x42, 0x42, 0x42]);
  /// print(random.nextInt(100));
  /// ```
  ///
  /// ## Implementing
  ///
  /// All PRNG implementations should be reproducible unless otherwise noted;
  /// given a fixed [seed] the same sequence of output should be produced on all
  /// runs, library versions and architectures, and "value-breaking" changes to
  /// the generators should require bumping at least the minor version and
  /// documentation of the change.
  ///
  /// It is not required that this function yield the same state as a reference
  /// implementation of the PRNG given an equal seed.
  ///
  /// PRNG implementations should make sure [fromSeed] never throws; a
  /// non-viable seed (like an all-zero seed) should be handled gracefully
  /// and mapped to an alternate constant value(s), for example `0xBAD5EED`,
  /// assuming only a small number of values must be rejected.
  T fromSeed(List<int> seed);

  /// Create a new PRNG using the bottom 32 bits of the given integer.
  ///
  /// This is a convenience-wrapper around [fromSeed] to allow for easy seeding
  /// from a single integer value, and is designed such that low
  /// [Hamming Weight][] numbers like 0 and 1 can be used and should still
  /// result in good, independent seeds to the PRNG which is returned.
  ///
  /// [Hamming Weight]: https://en.wikipedia.org/wiki/Hamming_weight
  ///
  /// This is **not suitable for cryptography**, as should be clear given that
  /// the input size is only 32 bits.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final random = defaultRandom.fromSeed32(42);
  /// print(random.nextInt(100));
  /// ```
  ///
  /// ## Implementing
  ///
  /// Implementations for PRNGs _may_ provide their own implementation.
  T fromSeed32(int value) {
    final seed = defaultZeroSeed();
    for (var i = 0; i < seed.length; i += 4) {
      seed[i + 0] = (Uint8(value) >> 24) & Uint8.max;
      seed[i + 1] = (Uint8(value) >> 16) & Uint8.max;
      seed[i + 2] = (Uint8(value) >> 8) & Uint8.max;
      seed[i + 3] = (Uint8(value) >> 0) & Uint8.max;
    }
    return fromSeed(seed);
  }

  /// Create a new PRNG seeded from another [random] instance.
  ///
  /// This may be useful when needing to rapidly seed many PRNGs from a parent
  /// PRNG, and to allow forking of PRNGs. The parent PRNG should be at least as
  /// high quality as the child PRNGs, and if possible using a cryptographically
  /// secure PRNG to avoid correlation between the parent and child PRNGs.
  ///
  /// ## Example
  ///
  /// ```dart
  /// // Create a new PRNG from a random cryptographically secure seed source.
  /// final parent = xoshiro128P.fromRandom();
  ///
  /// // Create a new PRNG from a specific instance.
  /// final child = xoshiro128P.fromRandom(Random(42));
  /// ```
  T fromRandom([Random? random]) {
    final seed = defaultZeroSeed();
    random ??= Random.secure();
    for (var i = 0; i < seed.length; i++) {
      seed[i] = random.nextInt(0xFF);
    }
    return fromSeed(seed);
  }
}

final class _SystemSeedableRandom with SeedableGenerator<Random> {
  const _SystemSeedableRandom();

  @override
  Uint8List defaultZeroSeed() => Uint8List(16);

  @override
  Random fromSeed(List<int> seed) {
    var value = Uint8.zero;
    for (var i = 0; i < seed.length; i++) {
      value =
          (value.wrappedShiftLeft(8)) |
          (Uint8.fromWrapped(seed[i]) & Uint8.max);
    }
    return Random(value);
  }

  @override
  Random fromSeed32(int value) => Random(value);

  @override
  Random fromRandom([Random? random]) {
    return random == null ? Random() : super.fromRandom(random);
  }
}
