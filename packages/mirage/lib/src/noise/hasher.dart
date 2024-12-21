import 'dart:typed_data';

import 'package:chaos/chaos.dart';

/// An interface for computing a hash value for a list of integers.
abstract interface class NoiseHasher {
  /// Creates a new default noise hasher.
  factory NoiseHasher() = NoiseTable;

  /// Hashes the given list of [values] and returns the result.
  ///
  /// The list must be non-empty.
  int hash(List<int> values);
}

/// A seed table used for noise hashing.
///
/// Table creation is expensive, so create one per generator and reuse it.
final class NoiseTable implements NoiseHasher {
  static const _tableSize = 0xFF + 1;

  /// Generates a new seed table using the given [random] number generator.
  factory NoiseTable([Random? random]) {
    final table = Uint8List(_tableSize);
    for (var i = 0; i < _tableSize; i++) {
      table[i] = i;
    }
    table.shuffle(random);
    return NoiseTable._(table);
  }

  /// Generates a new seed table using the given [seed].
  ///
  /// If [seed] is omitted, a new seed is generated.
  factory NoiseTable.fromSeed([int? seed]) {
    final seed_ = seed ?? Xoshiro128.randomSeed();
    final real = Uint8List(16)..[0] = 1;
    for (var i = 1; i < 4; i++) {
      real[i * 4] = seed_;
      real[i * 4 + 1] = seed_ >> 8;
      real[i * 4 + 2] = seed_ >> 16;
      real[i * 4 + 3] = seed_ >> 24;
    }
    final rng = Xoshiro128P.fromSeed(real);
    return NoiseTable(rng);
  }

  const NoiseTable._(this._table);
  final Uint8List _table;

  @override
  int hash(List<int> values) {
    var hash = 0;
    for (final value in values) {
      hash = _table[hash ^ (value & 0xFF)];
    }
    return hash;
  }
}
