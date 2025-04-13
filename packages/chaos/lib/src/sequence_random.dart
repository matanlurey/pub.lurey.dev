import 'dart:typed_data';

import 'package:binary/binary.dart';
import 'package:chaos/src/persistent_random.dart';

/// A fixed number generator that produces a sequence of predetermined numbers.
///
/// This class is useful for unit testing and debugging, as it allows you to
/// tightly control the sequence of random numbers produced, but is typically
/// not suitable for production use due to the lack of randomness.
///
/// ## End of sequence
///
/// If the sequence is exhausted, the generator will start over from the
/// beginning. This means that the sequence `[0.1, 0.2, 0.3]` will produce the
/// sequence `[0.1, 0.2, 0.3, 0.1, 0.2, 0.3, ...]` indefinitely.
///
/// Optionally, `terminal` can be set to `true` to stop the generator from
/// repeating the sequence. In this case, the generator will throw a
/// [StateError] when the sequence is exhausted.
///
/// If no numbers are provided, the sequence will be empty, and all calls to
/// `nextInt`, `nextDouble`, and `nextBool` will throw a `StateError`. This
/// can be useful for testing cases where you expect no random numbers to be
/// generated.
///
/// ## Non-floating point values
///
/// Random numbers are typically defined as their cooresponding floating point
/// values in the range [0, 1). In other words, if `0` is the next double, then
/// `nextInt(20)` will return `0`, and `nextDouble()` will return `0.0`:
///
/// `nextDouble()` | `nextInt(20)` | `nextBool()`
/// ---------------|----------------|------------
/// `0.25`         | `5`            | `false`
/// `0.50`         | `10`           | `true`
/// `0.75`         | `15`           | `true`
///
/// In other words, the sequence `[0.25, 0.50, 0.75]` will produce the sequence
/// `[5, 10, 15]` when calling `nextInt(20)`, and the sequence
/// `[false, true, true]` when calling `nextBool()`.
///
/// ## Cloning and saving state
///
/// The state of the generator can be saved and restored using the [save] and
/// [restore] methods. The state is a byte array that can be used to restore the
/// generator to the exact state it was in when the state was saved, including
/// the sequence, the current index, and the terminal state.
///
/// ## Example
///
/// ```dart
/// final sequence = SequenceRandom([0.1, 0.2, 0.3]);
/// print(sequence.nextInt(10)); // 1
/// print(sequence.nextInt(10)); // 2
/// print(sequence.nextInt(10)); // 3
/// ```
final class SequenceRandom implements PersistentRandom {
  /// Creates a new instance of [SequenceRandom] that always repeats one number.
  ///
  /// This is equivalent to `SequenceRandom([value])`.
  factory SequenceRandom.always(double value, {bool terminal = false}) {
    return SequenceRandom([value], terminal: terminal);
  }

  /// Creates a new instance of [SequenceRandom] that always throws an error.
  ///
  /// This is equivalent to `SequenceRandom([])`.
  factory SequenceRandom.never() {
    return SequenceRandom(const []);
  }

  /// Creates a new instance of [SequenceRandom] with the given `int` sequence.
  ///
  /// This is a convenience constructor that converts the `int` values to
  /// `double` values in the range [0, 1) so that the test sequence can be
  /// easily defined as integers, e.g. `SequenceRandom.ints([1, 2, 3])` instead
  /// of `SequenceRandom([0.1, 0.2, 0.3])`.
  ///
  /// [min] and [max] can be used to specify the range of the integers. If not
  /// provided, the smallest and largest values in the sequence will be used.
  factory SequenceRandom.ints(
    List<int> sequence, {
    bool terminal = false,
    int? min,
    int? max,
  }) {
    // If the sequence is empty, return an empty sequence.
    if (sequence.isEmpty) {
      return SequenceRandom.never();
    }

    // Find the smallest and largest values in the sequence.
    var iMin = min ?? sequence.first;
    var iMax = max ?? sequence.first;
    if (min == null || max == null) {
      for (var i = 1; i < sequence.length; i++) {
        final value = sequence[i];
        if (value < iMin) {
          iMin = value;
        } else if (value > iMax) {
          iMax = value;
        }
      }
    }

    // Create a normalized sequence.
    final s = Float64List(sequence.length);
    for (var i = 0; i < sequence.length; i++) {
      s[i] = (sequence[i] - iMin) / (iMax - iMin);
    }

    return SequenceRandom(s, terminal: terminal);
  }

  /// Creates a new instance of [SequenceRandom] with the given `bool` sequence.
  ///
  /// This is a convenience constructor that converts the `bool` values to
  /// `double` values in the range [0, 1) so that the test sequence can be
  /// easily defined as booleans, e.g. `SequenceRandom.bools([true, false])`
  /// instead of `SequenceRandom([1.0, 0.0])`.
  factory SequenceRandom.bools(List<bool> sequence, {bool terminal = false}) {
    final s = Float64List(sequence.length);
    for (var i = 0; i < sequence.length; i++) {
      s[i] = sequence[i] ? _maxExclusiveDobule : 0.0;
    }
    return SequenceRandom(s, terminal: terminal);
  }

  /// Creates a new instance of [SequenceRandom] with an uniform distribution.
  ///
  /// A single number, which is the total size of the sequence, is required,
  /// and numbers will be generated in the range [0, 1) with a uniform
  /// distribution.
  ///
  /// ## Example
  ///
  /// ```dart
  /// // Equivalent to SequenceRandom([0.0, 0.5, 1.0]).
  /// final sequence = SequenceRandom.uniform(3);
  /// print(sequence.nextInt(10)); // 0
  /// print(sequence.nextInt(10)); // 5
  /// print(sequence.nextInt(10)); // 10
  /// ```
  factory SequenceRandom.uniform(int size, {bool terminal = false}) {
    final s = Float64List(size);
    for (var i = 0; i < size; i++) {
      s[i] = i / (size - 1);
    }
    return SequenceRandom(s, terminal: terminal);
  }

  /// Creates a new instance of [SequenceRandom] with a linear distribution.
  ///
  /// Two numbers are required: the start and end of the sequence. Numbers will
  /// be generated in the range [0, 1) with a linear distribution.
  ///
  /// ## Example
  ///
  /// ```dart
  /// // Equivalent to SequenceRandom([0.0, 0.5, 1.0]).
  /// final sequence = SequenceRandom.linear(0, 1, length: 3);
  /// print(sequence.nextInt(10)); // 0
  /// print(sequence.nextInt(10)); // 5
  /// print(sequence.nextInt(10)); // 10
  /// ```
  factory SequenceRandom.linear(
    double start,
    double end, {
    required int length,
    bool terminal = false,
  }) {
    final s = Float64List(length);
    for (var i = 0; i < length; i++) {
      s[i] = start + (end - start) * i / (length - 1);
    }
    return SequenceRandom(s, terminal: terminal);
  }

  static const _maxExclusiveDobule = 0.9999999999999999;

  /// Creates a new instance of [SequenceRandom] with the given sequence.
  ///
  /// Any numbers out of range will be normalized to the range [0, 1).
  factory SequenceRandom(List<double> sequence, {bool terminal = false}) {
    final s = Float64List(sequence.length);
    for (var i = 0; i < sequence.length; i++) {
      final r = sequence[i];
      if (r < 0.0) {
        s[i] = 0.0;
      } else if (r >= 1.0) {
        s[i] = _maxExclusiveDobule;
      } else {
        s[i] = r;
      }
    }
    return SequenceRandom._(s, terminal: terminal);
  }

  SequenceRandom._(
    this._sequence, { //
    required bool terminal,
  }) : _terminal = terminal;
  final Float64List _sequence;

  var _index = 0;
  bool _terminal;

  @override
  double nextDouble() {
    if (_sequence.isEmpty) {
      throw StateError('No random numbers available.');
    }
    final i = _sequence[_index++];
    if (_index == _sequence.length) {
      if (_terminal) {
        throw StateError('Sequence exhausted.');
      }
      _index = 0;
    }
    assert(i >= 0.0 && i < 1.0, 'Must be in range [0, 1), got $i');
    return i;
  }

  /// Generates a random integer in the range [0, max).
  ///
  /// [max] must be a positive integer between 1 and 2^32.
  ///
  /// The double value from [nextDouble] is multiplied by [max] and then
  /// truncated to an integer.
  @override
  int nextInt(int max) {
    Uint32.checkRange(max);
    final result = (nextDouble() * max).floor();
    assert(
      result >= 0 && result < max,
      'Must be in range [0, $max), got $result',
    );
    return result;
  }

  /// Generates a random boolean value.
  ///
  /// This is equivalent to `nextDouble() > 0.5`.
  @override
  bool nextBool() => nextDouble() > 0.5;

  @override
  Uint8List save() {
    // Store the current index, terminal state, and sequence.
    final state = Float64List(2 + _sequence.length);
    state[0] = _index.toDouble();
    state[1] = _terminal ? 1.0 : 0.0;
    state.setAll(2, _sequence);
    return state.buffer.asUint8List();
  }

  @override
  void restore(Uint8List state) {
    final s = state.buffer.asFloat64List();
    if (s.length < 2) {
      throw ArgumentError.value(
        state,
        'state',
        'Must be at least 2 8-bit bytes, got ${state.length}',
      );
    }
    _index = s[0].toInt();
    _terminal = s[1] != 0.0;
    _sequence.setAll(0, s.sublist(2));
  }

  @override
  SequenceRandom clone() {
    final clone = SequenceRandom._(_sequence, terminal: _terminal);
    clone._index = _index;
    return clone;
  }
}
