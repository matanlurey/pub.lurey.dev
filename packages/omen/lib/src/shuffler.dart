import 'dart:math';

import 'package:meta/meta.dart';

/// Cuts the list at the given [index].
///
/// The cards before the cut are moved to the end of the list, and the cards
/// after the cut are moved to the front.
///
/// [index] must be a valid index in the list.
void cut<T>(List<T> list, {required int index}) {
  RangeError.checkValidRange(index, 0, list.length);
  if (index == 0 || index == list.length - 1) {
    return;
  }
  final cut = list.sublist(index);
  list.removeRange(index, list.length);
  list.insertAll(0, cut);
}

/// A default instance of [Shuffler] that uses [List.shuffle].
///
/// This is the default instance used by the library, and is suitable for most
/// use-cases, in particular when the state of the PRNG does not need to be
/// preserved or persisted. It is not cryptographically secure, and should not
/// be used for cryptographic purposes.
///
/// ## Example
///
/// ```dart
/// // Equivalent to List.shuffle(), but could be swapped out in the future.
/// final list = [1, 2, 3, 4, 5];
/// systemShuffler.shuffle(list);
/// ```
const Shuffler<void> systemShuffler = _SystemShuffler();

/// A [Shuffler] that simulates the perfect riffle shuffle of a deck of cards.
///
/// The list is split exaclty in half, and the elements are interleaved.
const Shuffler<void> perfectRiffleShuffler = _PerfectRiffleShuffler();

/// A type that can [shuffle] a list of elements.
@optionalTypeArgs
abstract interface class Shuffler<T> {
  /// Creates a default instance of [Shuffler] that uses [List.shuffle].
  ///
  /// A singleton instance of this constructor is available as [systemShuffler].
  const factory Shuffler() = _SystemShuffler;

  /// Creates a [Shuffler] that uses the provided [Random] instance.
  ///
  /// [List.shuffle] is used to shuffle the list of elements with the provided
  /// [Random].
  const factory Shuffler.fromRandom(Random random) = _RandomShuffler;

  /// Creates a [Shuffler] that does not shuffle the list of elements.
  const factory Shuffler.identity() = _IdentityShuffler;

  /// Creates a [Shuffler] that sequentially applies the provided [shufflers].
  ///
  /// The [shufflers] are applied in the order they are provided, and the
  /// resulting shuffler is a composite of all the provided shufflers. If no
  /// elements are provided, the resulting shuffler is equivalent to
  /// [Shuffler.identity].
  factory Shuffler.combine(Iterable<Shuffler<T>> shufflers) = _CombinedShuffler;

  /// Shuffles the list of elements.
  void shuffle(List<T> list);
}

final class _IdentityShuffler<T> implements Shuffler<T> {
  const _IdentityShuffler();

  @override
  void shuffle(List<T> list) {
    // No-op
  }
}

final class _SystemShuffler<T> implements Shuffler<T> {
  const _SystemShuffler();

  @override
  void shuffle(List<T> list) {
    list.shuffle();
  }
}

final class _RandomShuffler<T> implements Shuffler<T> {
  const _RandomShuffler(this._random);
  final Random _random;

  @override
  void shuffle(List<T> list) {
    list.shuffle(_random);
  }
}

final class _CombinedShuffler<T> implements Shuffler<T> {
  _CombinedShuffler(
    Iterable<Shuffler<T>> shufflers, //
  ) : _shufflers = [...shufflers];
  final List<Shuffler<T>> _shufflers;

  @override
  void shuffle(List<T> list) {
    for (final shuffler in _shufflers) {
      shuffler.shuffle(list);
    }
  }
}

final class _PerfectRiffleShuffler<T> implements Shuffler<T> {
  const _PerfectRiffleShuffler();

  @override
  void shuffle(List<T> list) {
    final length = list.length;
    if (length < 2) {
      return;
    }

    final half = length ~/ 2;
    final left = list.sublist(0, half);
    final right = list.sublist(half);

    for (var i = 0; i < half; i++) {
      list[i * 2] = left[i];
      if (i < right.length) {
        list[i * 2 + 1] = right[i];
      }
    }
  }
}
