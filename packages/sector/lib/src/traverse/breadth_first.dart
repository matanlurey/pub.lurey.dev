import 'dart:collection';

import 'package:sector/sector.dart';

/// A breadth-first traversal that visits each cell in the grid.
///
/// This traversal visits each cell in the grid in a breadth-first order
/// starting from the given position. The traversal will visit each cell in
/// the grid exactly once.
///
/// ## Examples
///
/// ```dart
/// final grid = Grid.fromRows([
///   [1, 2, 3],
///   [4, 5, 6],
///   [7, 8, 9],
/// ]);
/// for (final cell in grid.traverse(breadthFirst(1, 1))) {
///   print(cell);
/// }
/// ```
///
/// The output of the example is:
///
/// ```txt
/// 5
/// 2
/// 8
/// 4
/// 6
/// 1
/// 3
/// 7
/// 9
/// ```
Traversal<GridIterable<T>, T> breadthFirst<T>(
  int x,
  int y, {
  List<(int, int)> directions = const [
    // Up
    (0, -1),

    // Right
    (1, 0),

    // Down
    (0, 1),

    // Left
    (-1, 0),
  ],
}) {
  return (grid) {
    return GridIterable.from(() {
      return _BreadthFirstIterator(
        grid,
        x,
        y,
        directions,
      );
    });
  };
}

class _BreadthFirstIterator<T> with GridIterator<T> {
  _BreadthFirstIterator(
    Grid<T> grid,
    int x,
    int y,
    this._directions,
  )   : _grid = grid,
        _queue = Queue<(int, int)>(),
        _visited = <(int, int)>{} {
    _queue.add((x, y));
  }

  final Grid<T> _grid;
  final Queue<(int, int)> _queue;
  final Set<(int, int)> _visited;
  final List<(int, int)> _directions;

  @override
  late T current;

  @override
  late (int, int) position;

  @override
  bool moveNext() {
    while (_queue.isNotEmpty) {
      final position = _queue.removeFirst();
      final x = position.$1;
      final y = position.$2;

      if (_visited.contains(position)) {
        continue;
      }

      _visited.add(position);
      current = _grid.getUnchecked(x, y);
      this.position = (x, y);

      for (final direction in _directions) {
        final dx = direction.$1;
        final dy = direction.$2;

        final nx = x + dx;
        final ny = y + dy;

        if (_grid.containsXY(nx, ny)) {
          _queue.add((nx, ny));
        }
      }

      return true;
    }

    return false;
  }
}
