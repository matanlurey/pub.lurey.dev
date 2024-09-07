import 'dart:collection';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:lodim/lodim.dart';
import 'package:sector/src/collection.dart';
import 'package:sector/src/graph.dart';

export 'package:lodim/lodim.dart' show Pos, Rect;

part 'grid/grid.dart';
part 'grid/grid_walkable.dart';
part 'grid/list_grid.dart';
part 'grid/splay_tree_grid.dart';

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
