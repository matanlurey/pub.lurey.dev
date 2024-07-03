import 'package:sector/sector.dart';

/// Traverses the _edges_ of the grid.
///
/// This traversal visits the edges of the grid in a clockwise order starting
/// from the top-left corner of the grid. The traversal will visit each edge of
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
/// for (final cell in grid.traverse(edges)) {
///   print(cell);
/// }
/// ```
///
/// The output of the example is:
///
/// ```txt
/// 1
/// 2
/// 3
/// 6
/// 9
/// 8
/// 7
/// 4
/// ```
GridIterable<T> edges<T>(Grid<T> grid) {
  return GridIterable.from(() {
    return _EdgesIterator(grid);
  });
}

final class _EdgesIterator<T> with GridIterator<T> {
  _EdgesIterator(this._grid);

  final Grid<T> _grid;

  var _x = -1;
  var _y = 0;
  var _dx = 1;
  var _dy = 0;

  @override
  (int, int) get position => (_x, _y);

  @override
  T get current => _grid.getUnchecked(_x, _y);

  @override
  bool moveNext() {
    if (_dx == 1 && _dy == 0) {
      if (_x + 1 < _grid.width) {
        _x++;
      } else {
        _dx = 0;
        _dy = 1;
        _y++;
      }
    } else if (_dx == 0 && _dy == 1) {
      if (_y + 1 < _grid.height) {
        _y++;
      } else {
        _dx = -1;
        _dy = 0;
        _x--;
      }
    } else if (_dx == -1 && _dy == 0) {
      if (_x - 1 >= 0) {
        _x--;
      } else {
        _dx = 0;
        _dy = -1;
        _y--;
      }
    } else if (_dx == 0 && _dy == -1) {
      if (_y - 1 >= 0) {
        _y--;
      } else {
        return false;
      }
    }
    return true;
  }
}
