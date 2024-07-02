import 'package:meta/meta.dart';
import 'package:sector/sector.dart';

/// A partial rectangular view of another grid.
///
/// This class is not part of the public API, as it is an implementation detail
/// used to create sub-grids from existing grids. The public API is
/// [GridImpl.subGridView].
@internal
final class SubGridView<T> with Grid<T> {
  SubGridView.fromLTWH(
    this._view,
    this._left,
    this._top,
    this.width,
    this.height,
  );

  final Grid<T> _view;
  final int _left;
  final int _top;

  @override
  int width;

  @override
  int height;

  @override
  void clear() {
    if (width == _view.width && height == _view.height) {
      _view.clear();
    } else if (isNotEmpty) {
      throw UnsupportedError('Cannot clear a partial sub-grid');
    }
  }

  @override
  T getUnchecked(int x, int y) {
    return _view.getUnchecked(x + _left, y + _top);
  }

  @override
  void setUnchecked(int x, int y, T value) {
    _view.setUnchecked(x + _left, y + _top, value);
  }

  @override
  GridAxis<T> get rows => _Rows(this);

  @override
  GridAxis<T> get columns => _Columns(this);

  @override
  Grid<T> asSubGrid({
    int left = 0,
    int top = 0,
    int? width,
    int? height,
  }) {
    // Avoid infinitely nested sub-grids by using the original grid.
    width ??= this.width - left;
    height ??= this.height - top;
    return _view.asSubGrid(
      left: _left + left,
      top: _top + top,
      width: width,
      height: height,
    );
  }
}

final class _Rows<T> extends GridAxis<T> with RowsMixin<T> {
  _Rows(this.grid);

  @override
  final SubGridView<T> grid;

  @override
  void insertAt(int index, Iterable<T> row) {
    // Cannot insert if the view's width is not the same as the original grid.
    if (grid.width != grid._view.width) {
      throw UnsupportedError('Cannot insert a row into a partial sub-grid');
    }

    grid._view.rows.insertAt(index + grid._top, row);
    grid.height++;
  }

  @override
  void removeAt(int index) {
    // Cannot remove if the view's width is not the same as the original grid.
    if (grid.width != grid._view.width) {
      throw UnsupportedError('Cannot remove a row from a partial sub-grid');
    }

    grid._view.rows.removeAt(index + grid._top);
    grid.height--;
  }
}

final class _Columns<T> extends GridAxis<T> with ColumnsMixin<T> {
  _Columns(this.grid);

  @override
  final SubGridView<T> grid;

  @override
  void insertAt(int index, Iterable<T> column) {
    // Cannot insert if the view's height is not the same as the original grid.
    if (grid.height != grid._view.height) {
      throw UnsupportedError('Cannot insert a column into a partial sub-grid');
    }

    grid._view.columns.insertAt(index + grid._left, column);
    grid.width++;
  }

  @override
  void removeAt(int index) {
    // Cannot remove if the view's height is not the same as the original grid.
    if (grid.height != grid._view.height) {
      throw UnsupportedError('Cannot remove a column from a partial sub-grid');
    }

    grid._view.columns.removeAt(index + grid._left);
    grid.width--;
  }
}
