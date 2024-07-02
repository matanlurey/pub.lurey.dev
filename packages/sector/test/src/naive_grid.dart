import 'package:sector/sector.dart';

/// A naive implementation of [Grid] that uses default methods where possible.
///
/// This class is not optimized for performance, and is intended to be used as a
/// reference implementation for testing and debugging default [Grid] methods.
final class NaiveListGrid<T> with Grid<T> {
  NaiveListGrid(this._cells, this._width);

  factory NaiveListGrid.fromRows(Iterable<Iterable<T>> rows) {
    final width = rows.isEmpty ? 0 : rows.first.length;
    final cells = rows.expand((row) => row).toList();
    return NaiveListGrid(cells, width);
  }

  factory NaiveListGrid.fromColumns(Iterable<Iterable<T>> columns) {
    // Make accessing length predictable.
    final columnsList = List.of(columns);

    // If empty, the grid is empty.
    if (columnsList.isEmpty) {
      return NaiveListGrid.fromRows([]);
    }

    final width = columnsList.length;
    final height = columnsList.first.length;
    final cells = List.of(GridImpl.checkedExpand(columnsList));

    // Map the columns to rows.
    final rows = List.generate(height, (y) {
      return List.generate(width, (x) {
        // Remember cells is column-major, so we need to swap x and y.
        return cells[y + x * height];
      });
    });

    return NaiveListGrid.fromRows(rows);
  }

  final List<T> _cells;

  @override
  int get width => _width;
  int _width;

  @override
  int get height => _width == 0 ? 0 : _cells.length ~/ _width;

  @override
  GridAxis<T> get rows => _Rows(this);

  @override
  GridAxis<T> get columns => _Columns(this);

  @override
  T getUnchecked(int x, int y) => _cells[x + y * _width];

  @override
  void setUnchecked(int x, int y, T value) {
    _cells[x + y * _width] = value;
  }
}

final class _Rows<T> extends GridAxis<T> with RowsMixin<T> {
  _Rows(this.grid);

  @override
  final NaiveListGrid<T> grid;

  @override
  void removeAt(int index) {
    GridImpl.checkBoundsExclusive(grid, 0, index);

    final start = index * grid.width;
    grid._cells.removeRange(start, start + grid.width);
  }

  @override
  void insertAt(int index, Iterable<T> row) {
    // If the grid is empty, and index is 0, this is the first row.
    if (grid.isEmpty && index == 0) {
      grid._cells.addAll(row);
      grid._width = row.length;
      return;
    }

    GridImpl.checkBoundsInclusive(grid, 0, index);
    GridImpl.checkLength(row, grid.width, name: 'row');

    final start = index * grid.width;
    grid._cells.insertAll(start, row);
  }
}

final class _Columns<T> extends GridAxis<T> with ColumnsMixin<T> {
  _Columns(this.grid);

  @override
  final NaiveListGrid<T> grid;

  @override
  void removeAt(int index) {
    GridImpl.checkBoundsExclusive(grid, index, 0);

    // Remove in reverse order to avoid shifting elements.
    for (var i = grid.height - 1; i >= 0; i--) {
      grid._cells.removeAt(index + i * grid.width);
    }

    grid._width -= 1;
  }

  @override
  void insertAt(int index, Iterable<T> column) {
    // If the grid is empty, and index is 0, this is the first column.
    if (grid.isEmpty && index == 0) {
      grid._cells.addAll(column);
      grid._width = 1;
      return;
    }

    GridImpl.checkBoundsInclusive(grid, index, 0);
    GridImpl.checkLength(column, grid.height, name: 'column');

    // Insert in reverse order to avoid shifting elements.
    final columnList = List.of(column);
    for (var y = grid.height - 1; y >= 0; y--) {
      grid._cells.insert(index + y * grid.width, columnList[y]);
    }

    grid._width += 1;
  }
}
