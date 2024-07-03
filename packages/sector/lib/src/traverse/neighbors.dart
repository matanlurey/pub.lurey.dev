import 'package:sector/sector.dart';

/// Given a position, returns the neighbors of that position.
///
/// This traversal returns the neighbors of a position. The neighbors are
/// returned in the order of the compass directions: north, east, south, west,
/// with [ifAbsent] substituted for any neighbors that are outside the bounds
/// of the grid.
Traversal<GridIterable<T?>, T> neighbors<T>(
  int x,
  int y, {
  T? ifAbsent,
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
      return _NeighborsIterator(
        grid,
        x,
        y,
        directions,
        ifAbsent,
      );
    });
  };
}

/// Given a position, returns the neighbors of that position.
///
/// This traversal returns the neighbors of a position. The neighbors are
/// returned in the order of the compass directions, including the diagonal
/// directions: north, northeast, east, southeast, south, southwest, west,
/// northwest, with [ifAbsent] substituted for any neighbors that are outside
/// the bounds of the grid.
Traversal<GridIterable<T?>, T> neighborsDiagonal<T>(
  int x,
  int y, {
  T? ifAbsent,
}) {
  return (grid) {
    return GridIterable.from(() {
      return _NeighborsIterator(
        grid,
        x,
        y,
        const [
          // Up
          (0, -1),

          // Up-right
          (1, -1),

          // Right
          (1, 0),

          // Down-right
          (1, 1),

          // Down
          (0, 1),

          // Down-left
          (-1, 1),

          // Left
          (-1, 0),

          // Up-left
          (-1, -1),
        ],
        ifAbsent,
      );
    });
  };
}

final class _NeighborsIterator<T> with GridIterator<T?> {
  _NeighborsIterator(
    this._grid,
    this._x,
    this._y,
    this._directions,
    this._ifAbsent,
  );

  final Grid<T> _grid;
  final int _x;
  final int _y;
  final List<(int, int)> _directions;
  final T? _ifAbsent;

  var _index = 0;

  @override
  late T? current;

  @override
  late (int, int) position;

  @override
  bool moveNext() {
    if (_index >= _directions.length) {
      return false;
    }

    final (dx, dy) = _directions[_index];
    _index++;

    final x = _x + dx;
    final y = _y + dy;

    position = (x, y);
    if (_grid.containsXY(x, y)) {
      current = _grid.getUnchecked(x, y);
    } else {
      current = _ifAbsent;
    }

    return true;
  }
}
