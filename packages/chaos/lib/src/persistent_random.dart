import 'dart:math' show Random;
import 'dart:typed_data';

import 'package:chaos/src/seedable_generator.dart';

/// A [Random] number generator where state can be saved and restored.
///
/// While many PRNGs are seedable, such as the default [Random] class, they
/// do not expose the internal state of the generator. This class is intended
/// to be used with PRNGs that allow the internal state to be saved and
/// restored, which can be useful for debugging, testing, and reproducibility,
/// i.e. for savefile-based games.
///
/// ## Example
///
/// ```dart
/// final xoroshiro = Xoshiro128P();
///
/// // Geneate 100 random numbers.
/// final numbers = List.generate(100, (_) => xoroshiro.nextInt(100));
///
/// // Save the state of the PRNG.
/// final state = xoroshiro.save();
///
/// // ... later ...
///
/// // Restore the state of the PRNG.
/// xoroshiro.restore(state);
/// ```
abstract interface class PersistentRandom implements Random {
  /// Creates a new instance of the PRNG with the same internal state.
  ///
  /// The new instance should be identical to the original, and should produce
  /// the same sequence of random numbers as the original, but should be
  /// independent of the original instance.
  PersistentRandom clone();

  /// A representation of the internal state of the PRNG.
  ///
  /// The value should be bytes representing the internal state of the PRNG, and
  /// compatible with the both the reverse operation (setter), and if the PRNG
  /// provides a [SeedableGenerator] implementation, the `fromSeed` method.
  Uint8List save();

  /// Sets the internal state of the PRNG to the given value.
  ///
  /// What is considered a valid state is PRNG-specific, but generally should be
  /// the same length as the state returned by [state]; the PRNG should be able
  /// to continue generating random numbers from the new state.
  void restore(Uint8List state);
}
