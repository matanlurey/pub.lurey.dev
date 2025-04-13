import 'dart:math';
import 'dart:typed_data';

import 'package:meta/meta.dart';

/// A mixin that can produce a random instance of an element of type [T].
///
/// An infinite sequence of elements of type [T] must exist, even if the
/// same element is the only one ever produced.
@immutable
abstract base mixin class Distribution<T> {
  /// @nodoc
  const Distribution();

  /// Creates a distribution that always produces the same element.
  ///
  /// This is equivalent to:
  /// ```dart
  /// Distribution.fromElements([element])
  /// ```
  ///
  /// [Random.nextInt] is not used by this distribution.
  const factory Distribution.always(
    T element, //
  ) = _SingleElementDistribution<T>;

  /// Creates a distribution that delegates to the provided generator function.
  const factory Distribution.generate(
    T Function(Random random) generator, //
  ) = _GeneratorDistribution<T>;

  /// Produces a random instance of an element [T].
  ///
  /// The [random] parameter is used to generate randomness.
  T sample(Random random);
}

final class _SingleElementDistribution<T> with Distribution<T> {
  const _SingleElementDistribution(this._element);
  final T _element;

  @override
  T sample(Random random) => _element;
}

final class _GeneratorDistribution<T> with Distribution<T> {
  const _GeneratorDistribution(this._generator);
  final T Function(Random random) _generator;

  @override
  T sample(Random random) => _generator(random);
}

/// A [Distribution] that produces a random element from a list of elements.
final class ListDistribution<T> with Distribution<T> {
  /// Creates a [ListDistribution] from a `const` list of elements.
  ///
  /// It is undefined behavior to use a `const` list of elements that is empty.
  const ListDistribution(@mustBeConst this._elements);

  /// Creates a [ListDistribution] by copying an iterable of elements.
  ///
  /// The list must not be empty.
  factory ListDistribution.from(Iterable<T> elements) {
    if (elements.isEmpty) {
      throw ArgumentError.value(
        elements,
        'elements',
        'Must have at least one element',
      );
    }
    return ListDistribution._([...elements]);
  }

  const ListDistribution._(this._elements);
  final List<T> _elements;

  @override
  T sample(Random random) {
    final index = random.nextInt(_elements.length);
    return _elements[index];
  }
}

/// Random alphanumeric code points from the range `0-9`, `a-z`, and `A-Z`.
const alphanumeric = CodeUnitDistribution(
  '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ',
);

/// A [Distribution] that produces a random code point from a string.
final class CodeUnitDistribution with Distribution<int> {
  /// Creates a [CodeUnitDistribution] from a `const` string.
  const CodeUnitDistribution(
    @mustBeConst this._string, //
  ) : assert(_string.length > 0, 'Must have at least one code point');

  /// Creates a [CodeUnitDistribution] from a string.
  ///
  /// The string must not be empty.
  factory CodeUnitDistribution.from(String string) {
    if (string.isEmpty) {
      throw ArgumentError.value(
        string,
        'string',
        'Must have at least one code point',
      );
    }
    return CodeUnitDistribution._(string);
  }

  const CodeUnitDistribution._(this._string);
  final String _string;

  @override
  int sample(Random random) {
    final index = random.nextInt(_string.length);
    return _string.codeUnitAt(index);
  }

  /// Returns a random string of the given [length] using `this` distribution.
  String sampleString(Random random, {required int length}) {
    final codeUnits = Uint16List(length);
    for (var i = 0; i < length; i++) {
      codeUnits[i] = sample(random);
    }
    return String.fromCharCodes(codeUnits);
  }
}
