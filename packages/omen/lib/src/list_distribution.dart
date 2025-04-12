import 'dart:math';
import 'package:meta/meta.dart';
import 'package:omen/src/distribution.dart';

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
    final index = random.nextInt(_elements.length - 1);
    return _elements[index];
  }
}
