import 'package:sector/sector.dart';

/// A traversal that draws a rectangle between two positions.
///
/// This traversal draws a rectangle between a [top] and [left] position, and a
/// [width] and [height] from that position. The traversal will visit each cell
/// that the rectangle passes through.
///
/// ## Examples
///
/// ```dart
/// final grid = Grid.fromRows([
///   [1, 2, 3],
///   [4, 5, 6],
///   [7, 8, 9],
/// ]);
/// for (final cell in grid.traverse(drawRect(0, 0, 2, 2))) {
///   print(cell);
/// }
/// ```
///
/// The output of the example is:
///
/// ```txt
/// 1
/// 2
/// 4
/// 5
/// ```
Traversal<GridIterable<T>, T> drawRect<T>(
  int left,
  int top,
  int width,
  int height,
) {
  return (grid) {
    GridImpl.checkBoundsXYWH(grid, left, top, width, height);
    return GridIterable.from(() {
      return _RectIterator(
        grid,
        left,
        top,
        width,
        height,
      );
    });
  };
}

final class _RectIterator<T> with GridIterator<T> {
  _RectIterator(
    this._grid,
    this._left,
    this._top,
    this._width,
    this._height,
  );

  final Grid<T> _grid;
  final int _left;
  final int _top;
  final int _width;
  final int _height;

  int _x = 0;
  int _y = 0;

  @override
  late T current;

  @override
  late (int, int) position;

  @override
  bool moveNext() {
    if (_y >= _height) {
      return false;
    }

    if (_x >= _width) {
      _x = 0;
      _y++;
    }

    if (_y >= _height) {
      return false;
    }

    current = _grid.getUnchecked(_left + _x, _top + _y);
    position = (_left + _x, _top + _y);
    _x++;
    return true;
  }
}
