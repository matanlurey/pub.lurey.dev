import 'dart:collection';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:meta/meta.dart';

part 'collection/fixed_length_iterable.dart';
part 'collection/flat_queue.dart';
part 'collection/index_map.dart';
part 'collection/index_set.dart';
part 'collection/indexed_map_entry.dart';

/// The default hash function, i.e. [Object.hashCode].
int _defaultHashCode(Object? key) => key.hashCode;

/// The default equality function, i.e. [Object.==].
bool _defaultEquals(Object? key1, Object? key2) => key1 == key2;

/// Swap the element at [index] with the last element in the list and remove it.
///
/// This is a helper function for removing elements from a list in O(1) time;
/// the order of the remaining elements is not preserved by this operation.
E _removeSwap<E>(List<E> list, int index) {
  final last = list.removeLast();
  if (index < list.length) {
    final element = list[index];
    list[index] = last;
    return element;
  }
  return last;
}
