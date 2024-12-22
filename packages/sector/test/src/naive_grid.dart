import 'package:sector/src/grid.dart';

final class NaiveGrid<E> with Grid<E> {
  NaiveGrid(this._rows, {required this.empty});
  final List<List<E>> _rows;

  @override
  int get height => _rows.length;

  @override
  set height(int value) {
    if (value < height) {
      _rows.removeRange(value, height);
    } else if (value > height) {
      _rows.addAll(
        List.generate(value - height, (_) => List.filled(width, empty)),
      );
    }
  }

  @override
  int get width => _rows.isEmpty ? 0 : _rows.first.length;

  @override
  set width(int value) {
    if (value < width) {
      for (final row in _rows) {
        row.removeRange(value, width);
      }
    } else if (value > width) {
      for (final row in _rows) {
        row.addAll(List.filled(value - width, empty));
      }
    }
  }

  @override
  final E empty;

  @override
  E getUnsafe(Pos pos) => _rows[pos.y][pos.x];

  @override
  bool get isEmpty => _rows.every((row) => row.every((cell) => cell == empty));

  @override
  void setUnsafe(Pos pos, E value) {
    _rows[pos.y][pos.x] = value;
  }
}
