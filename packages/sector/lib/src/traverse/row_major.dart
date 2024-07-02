import 'package:sector/sector.dart';

/// A row-major traversal that visits each row in order from left to right.
///
/// This traversal visits each row in order from left to right, starting at the
/// top-left corner of the grid and moving to the right until the end of the
/// row, then moving to the next row and repeating the process until the entire
/// grid has been visited.
Traversal<T> rowMajor<T>({(int, int)? start}) {
  return (grid) {
    final (startX, startY) = start ?? (0, 0);
    return GridIterable.from(
      () => _RowMajorIterator(
        grid,
        startX,
        startY,
      ),
    );
  };
}

final class _RowMajorIterator<T> with GridIterator<T> {
  _RowMajorIterator(
    this._grid,
    int startX,
    int startY,
  )   : _x = startX - 1,
        _y = startY;

  final Grid<T> _grid;

  int _x;
  int _y;

  @override
  bool moveNext() {
    if (_x + 1 < _grid.width) {
      _x++;
    } else if (_y + 1 < _grid.height) {
      _x = 0;
      _y++;
    } else {
      return false;
    }
    return true;
  }

  @override
  T get current => _grid.getUnchecked(_x, _y);

  @override
  (int, int) get position => (_x, _y);
}
