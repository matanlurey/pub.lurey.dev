import 'dart:typed_data';

import 'package:sector/sector.dart';

part 'typed_data/uint8_grid.dart';

Never _cannotResize() => throw UnsupportedError('This grid is fixed-size');

void _buildIntHelper(
  List<int> output,
  int Function(int x, int y) generator, {
  required int width,
}) {
  final height = output.isEmpty ? 0 : output.length ~/ width;
  for (var y = 0; y < height; y++) {
    for (var x = 0; x < width; x++) {
      output[x + y * width] = generator(x, y);
    }
  }
}

void _fromIntColsHelper(
  List<int> output,
  Iterable<Iterable<int>> columns,
) {
  // Convert the columns to a sequential list of cells.
  final width = columns.length;
  final height = columns.isEmpty ? 0 : columns.first.length;
  final cells = List.of(GridImpl.checkedExpand(columns));
  for (var y = 0; y < height; y++) {
    for (var x = 0; x < width; x++) {
      output[x + y * width] = cells[y + x * height];
    }
  }
}

/// A _fixed_ grid of cells, each containing a single integer.
///
/// This is a more specialized version of [Grid] that is optimized for 8-bit
/// unsigned integer values, such as color channels or tile indices. Unlike
/// [Grid], this is backed by a single contiguous list of integers, which can
/// be more efficient for certain operations.
///
/// Operations that add, remove, or clear cells are not supported by this grid.
abstract final class TypedDataGrid<N extends num, T extends TypedData>
    with Grid<N> {
  TypedDataGrid._(
    this._data,
    int width,
  )   : height = width == 0 ? 0 : _data.lengthInBytes ~/ width,
        width = _data.lengthInBytes == 0 ? 0 : width {
    RangeError.checkNotNegative(width, 'width');
    if (width > 0 && _data.lengthInBytes % width != 0) {
      throw ArgumentError.value(
        width,
        'width',
        'Number of bytes must be a multiple of the width',
      );
    }
  }

  final T _data;

  @override
  final int width;

  @override
  final int height;

  @override
  bool get isEmpty => _data.lengthInBytes == 0;

  @override
  void clear() => _cannotResize();

  @override
  Rows<N> get rows => _Rows(this);

  @override
  Columns<N> get columns => _Columns(this);

  /// Returns the raw bytes of this grid.
  T asBytes() => _data;
}

final class _Rows<N extends num, T extends TypedData> //
    extends Iterable<Iterable<N>> //
    with
        RowsBase<N> {
  _Rows(this.grid);

  @override
  final TypedDataGrid<N, T> grid;

  @override
  void insertAt(int index, Iterable<N> row) => _cannotResize();

  @override
  void removeAt(int index) => _cannotResize();
}

final class _Columns<N extends num, T extends TypedData> //
    extends Iterable<Iterable<N>> //
    with
        ColumnsBase<N> {
  _Columns(this.grid);

  @override
  final TypedDataGrid<N, T> grid;

  @override
  void insertAt(int index, Iterable<N> column) => _cannotResize();

  @override
  void removeAt(int index) => _cannotResize();
}
