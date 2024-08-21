import 'dart:collection';
import 'dart:typed_data';

import 'package:lodim/lodim.dart';
// This is a private import of a "friend" package.
// ignore: implementation_imports
import 'package:lodim/src/grid.dart';
import 'package:meta/meta.dart';
import 'package:sector/src/collection.dart';
import 'package:sector/src/graph.dart';

export 'package:lodim/lodim.dart' show Pos, Rect;

part 'grid/grid.dart';
part 'grid/grid_walkable.dart';
part 'grid/list_grid.dart';
part 'grid/splay_tree_grid.dart';

/// Expands each sub-iterable into a single continuous iterable.
///
/// The resulting iterable runs through the elements returned by [elements]
/// in the same iteration order, similar to `elements.expand((i) => i)`.
///
/// Throws [StateError] if each sub-iterable does not have the same `length`.
///
/// ## Example
///
/// ```dart
/// final elements = [
///   [1, 2, 3],
///   [4, 5, 6],
/// ];
/// final expanded = ListGrid.expandEqualLength(elements);
/// print(List.of(expanded)); // [1, 2, 3, 4, 5, 6]
/// ```
Iterable<T> _expandEqualLength<T>(Iterable<Iterable<T>> elements) {
  int? length;
  return elements.expand((subIterable) {
    if (length == null) {
      length = subIterable.length;
    } else if (subIterable.length != length) {
      throw ArgumentError('All sub-iterables must have the same length.');
    }
    return subIterable;
  });
}

/// Returns the most common element in the provided [elements].
///
/// If multiple elements have the same count, the first element is returned.
///
/// If the elements are empty, an error is thrown.
T _mostCommonElement<T>(Iterable<T> elements) {
  T? mostCommon;
  var mostCommonCount = 0;
  final counts = HashMap<T, int>();
  for (final element in elements) {
    final count = counts.update(
      element,
      (value) => value + 1,
      ifAbsent: () => 1,
    );
    if (count > mostCommonCount) {
      mostCommon = element;
      mostCommonCount = count;
    }
  }

  if (mostCommon is! T) {
    throw StateError('$T is not a nullable type, and empty: ... not provided');
  }

  return mostCommon;
}
