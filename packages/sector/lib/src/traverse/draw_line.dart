import 'package:sector/sector.dart';

/// A traversal that draws a line between two positions.
///
/// This traversal draws a line between two positions using Bresenham's line
/// algorithm. The line is drawn from the start position to the end position
/// and the traversal will visit each cell that the line passes through.
///
/// Optionally, the [inclusive] parameter can be set to `false` to exclude the
/// end position from the traversal, otherwise the end position will be
/// included.
///
/// ## Examples
///
/// ```dart
/// final grid = Grid.fromRows([
///   [1, 2, 3],
///   [4, 5, 6],
///   [7, 8, 9],
/// ]);
/// for (final cell in grid.traverse(lineDraw((0, 0), (2, 2)))) {
///   print(cell);
/// }
/// ```
///
/// The output of the example is:
///
/// ```txt
/// 1
/// 5
/// 9
/// ```
Traversal<T> drawLine<T>(
  int x1,
  int y1,
  int x2,
  int y2, {
  bool inclusive = true,
}) {
  return (grid) {
    final octant = Octant.fromPoints(x1, y1, x2, y2);
    (x1, y1) = octant.toOctant1(x1, y1);
    (x2, y2) = octant.toOctant1(x2, y2);

    final dx = x2 - x1;
    final dy = y2 - y1;
    return GridIterable.from(() {
      return _BreshamIterator(
        grid,
        x1,
        y1,
        dx,
        dy,
        x2,
        dy - dx,
        octant,
        inclusive,
      );
    });
  };
}

final class _BreshamIterator<T> with GridIterator<T> {
  _BreshamIterator(
    this._grid,
    this._startX,
    this._startY,
    this._dx,
    this._dy,
    this._endX,
    this._diff,
    this._octant,
    // ignore: avoid_positional_boolean_parameters
    this._inclusive,
  );

  final Grid<T> _grid;

  final int _dx;
  final int _dy;
  final Octant _octant;
  final int _endX;

  int _startX;
  int _startY;
  int _diff;

  final bool _inclusive;

  @override
  late (int, int) position;

  @override
  late T current;

  @override
  bool moveNext() {
    final x = _startX;
    if (_inclusive ? x > _endX : x >= _endX) {
      return false;
    }

    final y = _startY;
    position = _octant.fromOctant1(x, y);
    current = _grid.getUnchecked(position.$1, position.$2);
    if (_diff >= 0) {
      _startY += 1;
      _diff -= _dx;
    }
    _diff += _dy;
    _startX += 1;

    return true;
  }
}
