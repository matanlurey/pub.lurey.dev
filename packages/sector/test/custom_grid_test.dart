import 'package:sector/sector.dart';

import '_grid_suite.dart';

void main() {
  runSuite(
    'NaiveListGrid',
    filled: NaiveListGrid.filled,
    from: NaiveListGrid.from,
    generate: NaiveListGrid.generate,
    fromCells: NaiveListGrid.fromCells,
    fromRows: NaiveListGrid.fromRows,
    fromColumns: NaiveListGrid.fromColumns,
    empty: NaiveListGrid.empty,
  );
}

/// A naive implementation of [Grid] that does not specialize any behavior.
final class NaiveListGrid<T> with Grid<T> {
  factory NaiveListGrid.filled(int width, int height, T fill) {
    RangeError.checkNotNegative(width, 'width');
    RangeError.checkNotNegative(height, 'height');

    if (width == 0 || height == 0) {
      return NaiveListGrid.empty();
    }

    final cells = List<T>.filled(width * height, fill, growable: true);
    return NaiveListGrid._(cells, width);
  }

  factory NaiveListGrid.generate(
    int width,
    int height,
    T Function(int x, int y) generator,
  ) {
    RangeError.checkNotNegative(width, 'width');
    RangeError.checkNotNegative(height, 'height');

    if (width == 0 || height == 0) {
      return NaiveListGrid.empty();
    }

    final cells = List<T>.generate(width * height, (index) {
      final x = index % width;
      final y = index ~/ width;
      return generator(x, y);
    });
    return NaiveListGrid._(cells, width);
  }

  factory NaiveListGrid.from(Grid<T> grid) {
    return NaiveListGrid.generate(grid.width, grid.height, grid.get);
  }

  factory NaiveListGrid.fromCells(Iterable<T> cells, {required int width}) {
    RangeError.checkNotNegative(width, 'width');
    if (width == 0) {
      return NaiveListGrid.empty();
    }

    // Make accessing length predictable.
    final cellsList = List.of(cells);

    // Ensure the number of cells is a multiple of the width.
    if (cellsList.length % width != 0) {
      throw ArgumentError.value(
        cells,
        'cells',
        'Number of cells must be a multiple of the width.',
      );
    }

    return NaiveListGrid._(cellsList, width);
  }

  factory NaiveListGrid.fromRows(Iterable<Iterable<T>> rows) {
    // Make accessing length predictable.
    final rowsList = List.of(rows);

    final width = rowsList.isEmpty ? 0 : rowsList.first.length;
    final cells = List.of(GridImpl.checkedExpand(rowsList));
    return NaiveListGrid._(cells, width);
  }

  factory NaiveListGrid.fromColumns(Iterable<Iterable<T>> columns) {
    // Make accessing length predictable.
    final columnsList = List.of(columns);

    // If empty, the grid is empty.
    if (columnsList.isEmpty) {
      return NaiveListGrid.empty();
    }

    final width = columnsList.length;
    final cells = List.of(GridImpl.checkedExpand(columnsList));

    // Map the columns to rows.
    final rows = List.generate(width, (x) {
      return List.generate(cells.length ~/ width, (y) {
        return cells[x + y * width];
      });
    });

    return NaiveListGrid.fromRows(rows);
  }

  factory NaiveListGrid.empty() {
    return NaiveListGrid._([], 0);
  }

  NaiveListGrid._(this._cells, this._width);

  final List<T> _cells;

  @override
  int get width => _width;
  int _width;

  @override
  int get height => _width == 0 ? 0 : _cells.length ~/ _width;

  int _indexOfChecked(int x, int y) {
    GridImpl.checkBoundsExclusive(this, x, y);
    return x + y * _width;
  }

  @override
  T getUnchecked(int x, int y) {
    return _cells[_indexOfChecked(x, y)];
  }

  @override
  void setUnchecked(int x, int y, T value) {
    _cells[_indexOfChecked(x, y)] = value;
  }

  @override
  void clear() {
    _cells.clear();
    _width = 0;
  }

  @override
  Rows<T> get rows => _Rows(this);

  @override
  Columns<T> get columns => _Columns(this);
}

final class _Rows<T> extends Iterable<Iterable<T>> with RowsBase<T> {
  _Rows(this.grid);

  @override
  final NaiveListGrid<T> grid;

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

  @override
  void removeAt(int index) {
    GridImpl.checkBoundsExclusive(grid, 0, index);

    final start = index * grid.width;
    grid._cells.removeRange(start, start + grid.width);
  }
}

final class _Columns<T> extends Iterable<Iterable<T>> with ColumnsBase<T> {
  _Columns(this.grid);

  @override
  final NaiveListGrid<T> grid;

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

  @override
  void removeAt(int index) {
    GridImpl.checkBoundsExclusive(grid, index, 0);

    for (var i = index; i < grid._cells.length; i += grid.width) {
      grid._cells.removeAt(i);
    }

    grid._width -= 1;
  }
}
