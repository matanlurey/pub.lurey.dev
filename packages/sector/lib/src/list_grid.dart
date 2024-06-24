import 'package:sector/sector.dart';

/// A dense grid implementation using a 1-dimensional [List] to store elements.
///
/// This implementation is the default grid type returned by the constructors in
/// the [Grid] interface. It is a row-major dense grid, where each row is stored
/// contiguously in memory. This is the most common layout for a grid, and is
/// the most efficient for most use-cases.
final class ListGrid<T> with Grid<T> {
  /// Creates a new grid with the provided [width] and [height].
  ///
  /// The grid is initialized with all elements set to [fill].
  ///
  /// The [width] and [height] must be non-negative.
  ///
  /// If either dimension is `0`, an [ListGrid.empty] is returned.
  factory ListGrid.filled(int width, int height, T fill) {
    RangeError.checkNotNegative(width, 'width');
    RangeError.checkNotNegative(height, 'height');

    if (width == 0 || height == 0) {
      return ListGrid.empty();
    }

    final cells = List<T>.filled(width * height, fill, growable: true);
    return ListGrid._(cells, width);
  }

  /// Creates a new grid with the provided [width] and [height].
  ///
  /// The grid is initialized with elements generated by the provided
  /// [generator], where the element at index `(x, y)` is `generator(x, y)`.
  ///
  /// The [width] and [height] must be non-negative.
  ///
  /// If either dimension is `0`, an [ListGrid.empty] is returned.
  factory ListGrid.generate(
    int width,
    int height,
    T Function(int x, int y) generator,
  ) {
    RangeError.checkNotNegative(width, 'width');
    RangeError.checkNotNegative(height, 'height');

    if (width == 0 || height == 0) {
      return ListGrid.empty();
    }

    final cells = List<T>.generate(width * height, (index) {
      final x = index % width;
      final y = index ~/ width;
      return generator(x, y);
    });
    return ListGrid._(cells, width);
  }

  /// Creates a new grid from an existing [grid].
  ///
  /// The new grid is a shallow copy of the original grid.
  factory ListGrid.from(Grid<T> grid) {
    return ListGrid.generate(grid.width, grid.height, grid.get);
  }

  /// Creates a new grid from the provided [cells].
  ///
  /// The grid will have a width equal to the provided [width], and a height
  /// equal to the number of cells divided by the width, which must be an
  /// integer.
  ///
  /// The grid is initialized with the elements in the cells, where the element
  /// at index `(x, y)` is `cells[y * width + x]`.
  ///
  /// If [width] is `0`, an [Grid.empty] is returned.
  factory ListGrid.fromCells(Iterable<T> cells, {required int width}) {
    RangeError.checkNotNegative(width, 'width');
    if (width == 0) {
      return ListGrid.empty();
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

    return ListGrid._(cellsList, width);
  }

  /// Creates a new grid from the provided [rows].
  ///
  /// Each row must have the same length, and the grid will have a width equal
  /// to the length of the first row, and a height equal to the number of rows.
  ///
  /// The grid is initialized with the elements in the rows, where the element
  /// at index `(x, y)` is `rows[y][x]`.
  factory ListGrid.fromRows(Iterable<Iterable<T>> rows) {
    // Make accessing length predictable.
    final rowsList = List.of(rows);

    final width = rowsList.isEmpty ? 0 : rowsList.first.length;
    final cells = List.of(GridImpl.checkedExpand(rowsList));
    return ListGrid._(cells, width);
  }

  /// Creates a new grid from the provided [columns].
  ///
  /// Each column must have the same length, and the grid will have a width
  /// equal to the number of columns, and a height equal to the length of the
  /// first column.
  ///
  /// The grid is initialized with the elements in the columns, where the
  /// element at index `(x, y)` is `columns[x][y]`.
  factory ListGrid.fromColumns(Iterable<Iterable<T>> columns) {
    // Make accessing length predictable.
    final columnsList = List.of(columns);

    // If empty, the grid is empty.
    if (columnsList.isEmpty) {
      return ListGrid.empty();
    }

    final width = columnsList.length;
    final cells = List.of(GridImpl.checkedExpand(columnsList));

    // Map the columns to rows.
    final rows = List.generate(width, (x) {
      return List.generate(cells.length ~/ width, (y) {
        return cells[x + y * width];
      });
    });

    return ListGrid.fromRows(rows);
  }

  /// Creates a new empty grid.
  ///
  /// The grid has a width and height of `0` and will not contain any elements.
  factory ListGrid.empty() {
    return ListGrid._([], 0);
  }

  ListGrid._(this._cells, this._width);

  final List<T> _cells;

  @override
  int get width => _width;
  int _width;

  @override
  int get height => _width == 0 ? 0 : _cells.length ~/ _width;

  @override
  Rows<T> get rows => _Rows(this);

  @override
  Columns<T> get columns => _Columns(this);

  @pragma('vm:prefer-inline')
  @override
  T getUnchecked(int x, int y) {
    return _cells[x + y * _width];
  }

  @pragma('vm:prefer-inline')
  @override
  void setUnchecked(int x, int y, T value) {
    _cells[x + y * _width] = value;
  }

  @override
  bool get isEmpty => _cells.isEmpty;

  @override
  void clear() {
    _cells.clear();
    _width = 0;
  }
}

final class _Rows<T> extends Iterable<Iterable<T>> with RowsBase<T> {
  _Rows(this.grid);

  @override
  final ListGrid<T> grid;

  @override
  Iterator<Iterable<T>> get iterator {
    return _RowsIterator(grid);
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

  @override
  void removeAt(int index) {
    GridImpl.checkBoundsExclusive(grid, 0, index);

    final start = index * grid.width;
    grid._cells.removeRange(start, start + grid.width);
  }
}

final class _RowsIterator<T> implements Iterator<Iterable<T>> {
  _RowsIterator(this.grid);

  final ListGrid<T> grid;
  var _row = 0;

  @override
  Iterable<T> get current {
    return _RowIterable(grid, _row - 1);
  }

  @override
  bool moveNext() {
    if (_row < grid.height) {
      _row++;
      return true;
    }

    return false;
  }
}

final class _RowIterable<T> extends Iterable<T> {
  _RowIterable(this._grid, this._row);

  final ListGrid<T> _grid;
  final int _row;

  @override
  Iterator<T> get iterator => _RowIterator(_grid, _row);
}

final class _RowIterator<T> implements Iterator<T> {
  factory _RowIterator(ListGrid<T> grid, int row) {
    final start = row * grid.width;
    final end = start + grid.width;
    return _RowIterator._(grid._cells, start - 1, end - 1);
  }

  _RowIterator._(this._cells, this._start, this._end);

  final List<T> _cells;
  final int _end;
  int _start;

  @override
  T get current => _cells[_start];

  @override
  bool moveNext() {
    if (_start < _end) {
      _start++;
      return true;
    }

    return false;
  }
}

final class _Columns<T> extends Iterable<Iterable<T>> with ColumnsBase<T> {
  _Columns(this.grid);

  @override
  final ListGrid<T> grid;

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
