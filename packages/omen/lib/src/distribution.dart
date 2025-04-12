import 'dart:math';

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
