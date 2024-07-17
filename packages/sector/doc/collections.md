A collection of additional data structures used in and by 2D algorithms.

Sector provides additional common data structures that are used in and by 2D
algorithms and not found in the Dart SDK or `package:collection`. These data
structures are not required to use `sector` but are provided for convenience in
building custom algorithms where their performance characteristics are
beneficial.

---

Table of Contents:

- [Fast Insertion-Order Retained `Set` and `Map`](#fast-insertion-order-retained-set-and-map)
- [Fast Minimum Priority Queue](#fast-minimum-priority-queue)
- [Fixed Length `Iterable`](#fixed-length-iterable)

---

## Fast Insertion-Order Retained `Set` and `Map`

`IndexSet` and `IndexMap` provide fast insertion-order retained sets and maps,
respectively, with `O(1)` time complexity for most operations, and are used by
many of the data structures and pathfinding algorithms in this package. For
example, consider the following:

```dart
import 'package:sector/sector.dart';

void main() {
  final set = IndexSet<int>();
  set.add(1);
  set.add(2);
  set.add(3);
  print(set); // {1, 2, 3}

  final map = IndexMap<int, String>();
  map[1] = 'one';
  map[2] = 'two';
  map.entryOf(3).setOrUpdate('three');
  print(map); // {1: 'one', 2: 'two', 3: 'three'}
}
```

Index collections have _most_ of the same characteristics of `LinkedHashSet` and
`LinkedHashMap` (outside of removals), but 2-3x faster iteration speed, similar
removal speed to `HashSet` and `HashMap`, and only somewhat slower insertion
speed (~2x of `HashSet` and `HashMap`) which is still ~5x faster than
`LinkedHashSet` and `LinkedHashMap`.

## Fast Minimum Priority Queue

`FlatQueue` is a minimum priority queue that supports `O(log n)` insertion and
removal, and `O(1)` minimum value retrieval, but exclusively uses 32-bit `int`
keys and 32-bit `double` priorities associated with each element, making it
suitable for [`BestPathfinder`](Pathfinding-topic.html#weighted-graphs)
implementations:

```dart
import 'package:sector/sector.dart';

void main() {
  final queue = FlatQueue();
  queue.add(3, 1.0);
  queue.add(1, 3.0);
  queue.add(2, 2.0);
  print(queue.removeFirst()); // 3
  print(queue.removeFirst()); // 2
  print(queue.removeFirst()); // 1
}
```

`FlatQueue` is used in the A* and Dijkstra pathfinding algorithms.

## Fixed Length `Iterable`

Many of the algorithms in this package return a lazy iterable of fixed length
during iteration, which can be useful for performance-sensitive code over the
default `extends Iterable<E>` implementations:

```dart
import 'package:sector/sector.dart';

// An iterator over the rows of a grid, with fast random access.
final class GridRows<E> extends FixedLengthIterable<Iterable<E>> {
  const GridRows(this._grid);
  final Grid<E> _grid;

  @override
  int get length => _grid.height;

  @override
  Iterable<E> elementAt(int index) {
    return Iterable.generate(_grid.width, (x) {
      return _grid.getUnchecked(Pos(x, index));
    });
  }
}
```
